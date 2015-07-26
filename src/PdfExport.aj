import java.awt.Component;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Iterator;

import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;

import org.apache.pdfbox.exceptions.COSVisitorException;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.edit.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType1Font;

import me.stieglmaier.schafkopfAuswerter.model.db.DataObject;
import me.stieglmaier.schafkopfAuswerter.model.db.GameData;
import me.stieglmaier.schafkopfAuswerter.view.GUI;
import me.stieglmaier.schafkopfAuswerter.view.SchafkopfTableModel;

public privileged aspect PdfExport {

    /** This precendence makes the order of the items in the file menu sure */
    declare precedence : Import, HtmlExport, PdfExport;
    private GUI gui;

    /**
     * catch constructor call, so that we have the correct gui, to refer to everywhere
     */
    after() returning(GUI gui): call(GUI.new(*)) {
        this.gui = gui;
    }

    private String[][] SchafkopfTableModel.asTextArray() {
        String[][] completeTable = data.asTextArray();

        String[] headerLine = new String[getColumnCount()];
        for (int i = 0; i < getColumnCount(); i++) {
            headerLine[i] = getColumnName(i);
        }
        completeTable[0] = headerLine;
        return completeTable;
    }

    private String[][] GameData.asTextArray() {
        Iterator<DataObject> it = data.iterator();
        String[][] rows = new String[data.size()+1][];
        int index = 1;
        while (it.hasNext()) {
            rows[index] = it.next().asTextArray(index-1);
            index++;
        }
        return rows;
    }

    /**
     * Add pdf report feature to menu bar
     */
    after() returning(JMenuBar bar): call(JMenuBar GUI.createMenu()) {
        JMenuItem itemExportPdf = new JMenuItem("Generiere PDF Report");
        itemExportPdf.addActionListener(new PDFReportListener());

        Component[] menus = bar.getComponents();
        if (menus[0] instanceof JMenu) {
            ((JMenu)bar.getComponents()[0]).add(itemExportPdf,0);
        }
    }

    /**
     * generate pdf report (execution of PDFReportListener is suppressed, this
     * is just an empty method, to be able to create this pointcut
     * @throws IOException 
     */
    after(PDDocument document) returning() throws IOException
    : call(* PDFReportListener.drawTable(PDDocument))
    && args(document) {
        String[][] content = ((SchafkopfTableModel) gui.table.getModel()).asTextArray();

        // we have inches in us letter (8.5x11) therefore calculate correct width in points here
        // 1 pt = 1/72 inch
        final int height = 11 * 72;
        final int width = (int) (8.5* 72);
        // some values for drawing the table
        final int margin = 50;
        final int rowHeight = 20;
        final int maxRowsPerPage = (int) (height - 2*margin) / rowHeight;
        final int tableWidth = width - (2*margin);
        final int cellMargin=5;

        int rowsToBeDone = content.length;
        int actRow = 0;
        final int cols = content[0].length;
        final float colWidth = tableWidth/(float)cols;

        //draw the table
        do {
            // create initial page
            PDPage page = new PDPage();
            document.addPage(page);
            PDPageContentStream contentStream = new PDPageContentStream(document, page);
            final float tableHeight = rowHeight * (Math.min(rowsToBeDone, maxRowsPerPage));
            float y = height - margin;

            // draw table borders
            float nexty = y;
            for (int i = 0; i <= Math.min(rowsToBeDone, maxRowsPerPage); i++) {
                contentStream.drawLine(margin,nexty,margin+tableWidth,nexty);
                nexty-= rowHeight;
            }
            float nextx = margin;
            for (int i = 0; i <= cols; i++) {
                contentStream.drawLine(nextx,y,nextx,y-tableHeight);
                nextx += colWidth;
            }

          //now add the text
            contentStream.setFont(PDType1Font.HELVETICA_BOLD,10);
            float textx = margin+cellMargin;
            float texty = y-15;
            for(int i = actRow; i < Math.min(rowsToBeDone, maxRowsPerPage)+actRow; i++){
                for(int j = 0 ; j < cols; j++){
                    contentStream.beginText();
                    contentStream.moveTextPositionByAmount(textx,texty);
                    contentStream.drawString(content[i][j]);
                    contentStream.endText();
                    textx += colWidth;
                }
                texty-=rowHeight;
                textx = margin+cellMargin;
            }
            contentStream.close();

            // reduce number of rows that still have to be done
            rowsToBeDone -= maxRowsPerPage;
            actRow += maxRowsPerPage;
        } while (rowsToBeDone > 0);
    }
}

class PDFReportListener implements ActionListener {

    @Override
    public void actionPerformed(ActionEvent arg0) {
        // Create a document and add a page to it
        PDDocument document = new PDDocument();
        
        try {
            drawTable(document);  

            // Save the results and ensure that the document is properly closed:
            document.save("Session_vom_"+new SimpleDateFormat("dd.MM_'um'_HH:mm").format(Calendar.getInstance().getTime()) + ".pdf");
        } catch (IOException | COSVisitorException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } finally {
            try {
                document.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /** filled with pointcut from pdfExport.aj*/
    public static void drawTable(PDDocument document) throws IOException {
    }
}