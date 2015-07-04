import java.awt.Component;
import java.io.IOException;
import java.util.Iterator;

import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.edit.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType1Font;

import model.db.DataObject;
import model.db.GameData;
import view.GUI;
import view.SchafkopfTableModel;

public privileged aspect PdfExport {

    declare precedence : PdfExport, HtmlExport, Import; 
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

    after() returning(JMenuBar bar): call(JMenuBar GUI.createMenu()) {
        JMenuItem itemExportPdf = new JMenuItem("Generiere PDF Report");
        itemExportPdf.addActionListener(new PDFReportListener());

        Component[] menus = bar.getComponents();
        if (menus.length != 0 && menus[0] instanceof JMenu) {
            ((JMenu)bar.getComponents()[0]).add(itemExportPdf);
        } else {
            throw new AssertionError("There should be a menu entry!");
        }
    }

    void around(PDDocument document) throws IOException
          : execution (* PDFReportListener.drawTable(PDDocument)) 
          && args(document) {
        PDPage page = new PDPage();
        document.addPage(page);
        PDPageContentStream contentStream = new PDPageContentStream(document, page);
        float y =750f;
        float margin =60f;
        String[][] content = ((SchafkopfTableModel) gui.table.getModel()).asTextArray();

        final int rows = content.length;
        final int cols = content[0].length;
        final float rowHeight = 20f;
        final float tableWidth = page.findMediaBox().getWidth()-(2*margin);
        final float tableHeight = rowHeight * rows;
        final float colWidth = tableWidth/(float)cols;
        final float cellMargin=5f;

        // TODO multisite tables
        //draw the rows
        float nexty = y ;
        for (int i = 0; i <= rows; i++) {
            contentStream.drawLine(margin,nexty,margin+tableWidth,nexty);
            nexty-= rowHeight;
        }
     
        //draw the columns
        float nextx = margin;
        for (int i = 0; i <= cols; i++) {
            contentStream.drawLine(nextx,y,nextx,y-tableHeight);
            nextx += colWidth;
        }
     
        //now add the text
        contentStream.setFont(PDType1Font.HELVETICA_BOLD,10);
     
        float textx = margin+cellMargin;
        float texty = y-15;
        for(int i = 0; i < content.length; i++){
            for(int j = 0 ; j < content[i].length; j++){
                String text = content[i][j];
                contentStream.beginText();
                contentStream.moveTextPositionByAmount(textx,texty);
                contentStream.drawString(text);
                contentStream.endText();
                textx += colWidth;
            }
            texty-=rowHeight;
            textx = margin+cellMargin;
        }
        contentStream.close();
    }
}
