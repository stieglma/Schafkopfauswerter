
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.util.PDFMergerUtility;

import de.erichseifert.gral.io.plots.DrawableWriter;
import de.erichseifert.gral.io.plots.DrawableWriterFactory;

public privileged aspect GraphExport {

    after(PDDocument document) returning() throws IOException
    : execution (* PDFReportListener.drawTable(PDDocument)) 
    && args(document) {

        // create bytes array from graph
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        DrawableWriter wr = DrawableWriterFactory.getInstance().get("application/pdf");
        wr.write(Graph.createPlot(), baos, 800, 600);
        baos.flush();
        byte[] bytes = baos.toByteArray();
        baos.close();

        PDDocument picture = PDDocument.load(new ByteArrayInputStream(bytes));
        new PDFMergerUtility().appendDocument(document, picture);
        picture.close();
    }
}
