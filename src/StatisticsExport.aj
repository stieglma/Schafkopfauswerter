import java.io.IOException;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.edit.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType1Font;

import view.GUI;

public privileged aspect StatisticsExport {
	
	private GUI gui;

    /**
     * catch constructor call, so that we have the correct gui, to refer to everywhere
     */
    after() returning(GUI gui): call(GUI.new(*)) {
        this.gui = gui;
    }
    
    /**
     * Catch the call on {@link PDFReportListener.drawTable(PDDocument)} to get the pdf
     * creator object.
     * 
     * @param document
     * @throws IOException
     */
	void around(PDDocument document) throws IOException
		: execution (* PDFReportListener.drawTable(PDDocument))
		&& args(document) {
		PDPage page = new PDPage();
		document.addPage(page);
		PDPageContentStream contentStream = new PDPageContentStream(document, page);
		contentStream.setFont(PDType1Font.HELVETICA_BOLD, 10);
		contentStream.beginText();
		createContent(contentStream);
		contentStream.endText();
		contentStream.close();
	}
	
	/**
	 * Write statistics to given <code>contentStream</code> of a pdf page.
	 * 
	 * @param contentStream The <code>contentStream</code> of the pdf page to write on.
	 * @throws IOException
	 */
	private void createContent(PDPageContentStream contentStream) throws IOException {
		OverallStatistics data = gui.model.gameDB.getOverallStatistics();

        contentStream.moveTextPositionByAmount(50, 650);
        contentStream.drawString("#Spiele (ohne weiter): " + data.getAnzahlSpieleGesamt()
        		+ " (gewonnen: "
        		+ String.format("%.2f", data.getGesamtWinPerc()) + "%)");
        
        contentStream.moveTextPositionByAmount(0, -20);
        contentStream.drawString("#Rufspiele: " + data.getAnzahlRufspiele() + " (gewonnen: "
        		+ String.format("%.2f", data.getRufspieleWinPerc()) + "%)");
        
        contentStream.moveTextPositionByAmount(50, -20);
        contentStream.drawString("-> teurstes Rufspiel: "
        + data.getTeuerstesRufspiel());
        
        contentStream.moveTextPositionByAmount(-50, -20);
        contentStream.drawString("#Soli gesamt: "
        		+ data.getAnzahlSoliGesamt() + " (gewonnen: "
        		+ String.format("%.2f", data.getSoliGesamtWinPerc())
        		+ "%)");
        
        contentStream.moveTextPositionByAmount(0, -20);
        contentStream.drawString("#Soli normal: " + data.getAnzahlSoli()
        		+ " (gewonnen: "
        		+ String.format("%.2f", data.getSoliNormalWinPerc()) + "%)");
        
        contentStream.moveTextPositionByAmount(50, -20);
        contentStream.drawString("-> teurstes Solo: " + data.getTeuerstesSolo());
        
        contentStream.moveTextPositionByAmount(-50, -20);
        contentStream.drawString("#Solo Tout: " + data.getAnzahlSoliTout()
        		+ " (gewonnen: "
        		+ String.format("%.2f", data.getSoliToutWinPerc()) + "%)");
        
        contentStream.moveTextPositionByAmount(50, -20);
        contentStream.drawString("-> teurstes Solo Tout: "
        		+ data.getTeuerstesSoloTout());
        
        contentStream.moveTextPositionByAmount(-50, -20);
        contentStream.drawString("#Solo Sie: " + data.getAnzahlSoliSie());
        
        contentStream.moveTextPositionByAmount(50, -20);
        contentStream.drawString("-> teurstes Solo Sie: " + data.getTeuerstesSoloSie());
        
        contentStream.moveTextPositionByAmount(-50, -20);
        contentStream.drawString("#Weiter: " + data.getAnzahlWeiter());
	}
}
