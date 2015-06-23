import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import org.apache.pdfbox.exceptions.COSVisitorException;
import org.apache.pdfbox.pdmodel.PDDocument;

public class PDFReportListener implements ActionListener {

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
