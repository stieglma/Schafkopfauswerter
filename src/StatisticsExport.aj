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
		
		int anzahlSpieleGesamt = data.getAnzahlSpieleGesamt();
        int anzahlSpieleGesamtGewonnen = data.getAnzahlSpieleGesamtGewonnen();
        int teuerstesRufspiel = data.getTeuerstesRufspiel();
        int teuerstesSolo = data.getTeuerstesSolo();
        int teuerstesSoloTout = data.getTeuerstesSoloTout();
        int teuerstesSoloSie = data.getTeuerstesSoloSie();
        int anzahlRufspiele = data.getAnzahlRufspiele();
        int anzahlSoli = data.getAnzahlSoli();
        int anzahlSoliTout = data.getAnzahlSoliTout();
        int anzahlSoliSie = data.getAnzahlSoliSie();
        int anzahlSoliGesamt = data.getAnzahlSoliGesamt();
        int anzahlGewonneneSoliGesamt = data.getAnzahlGewonneneSoliGesamt();
        int anzahlGewonneneRufspiele = data.getAnzahlGewonneneRufspiele();
        int anzahlGewonneneSoli = data.getAnzahlGewonneneSoli();
        int anzahlGewonneneSoliTout = data.getAnzahlGewonneneSoliTout();
        int anzahlGewonneneSoliSie = data.getAnzahlGewonneneSoliSie();
        int anzahlWeiter = data.getAnzahlWeiter();

        double sologesamtwin = (anzahlSoliGesamt) > 0 ? ((double) (anzahlGewonneneSoliGesamt) / (anzahlSoliGesamt))
                : 0;
        
        contentStream.moveTextPositionByAmount(50, 650);
        contentStream.drawString("#Spiele (ohne weiter): "
                + anzahlSpieleGesamt
                + " (gewonnen: "
                + String.format("%.2f",
                        (anzahlSpieleGesamt > 0 ? anzahlSpieleGesamtGewonnen
                                / ((double) anzahlSpieleGesamt) : 0) * 100)
                + "%)");
        
        contentStream.moveTextPositionByAmount(0, -20);
        contentStream.drawString("#Rufspiele: "
                + anzahlRufspiele
                + " (gewonnen: "
                + String.format("%.2f",
                        (anzahlRufspiele > 0 ? anzahlGewonneneRufspiele
                                / ((double) anzahlRufspiele) : 0) * 100)
                + "%)");
        
        contentStream.moveTextPositionByAmount(0, -20);
        contentStream.drawString("          -> teuerstes Rufspiel: "
                + teuerstesRufspiel);
        
        contentStream.moveTextPositionByAmount(0, -20);
        contentStream.drawString("#Soli gesamt: "
                + (anzahlSoli + anzahlSoliTout + anzahlSoliSie)
                + " (gewonnen: "
                + String.format("%.2f", sologesamtwin * 100)
                + "%)");
        
        contentStream.moveTextPositionByAmount(0, -20);
        contentStream.drawString("#Soli normal: "
                + anzahlSoli
                + " (gewonnen: "
                + String.format("%.2f", (anzahlSoli > 0 ? anzahlGewonneneSoli
                        / ((double) anzahlSoli) : 0) * 100)
                + "%)");
        
        contentStream.moveTextPositionByAmount(0, -20);
        contentStream.drawString("            -> teuerstes Solo: "
                + teuerstesSolo);
        
        contentStream.moveTextPositionByAmount(0, -20);
        contentStream.drawString("#Solo Tout: "
                + anzahlSoliTout
                + " (gewonnen: "
                + String.format("%.2f",
                        (anzahlSoliTout > 0 ? anzahlGewonneneSoliTout
                                / ((double) anzahlSoliTout) : 0) * 100)
                + "%)");
        
        contentStream.moveTextPositionByAmount(0, -20);
        contentStream.drawString("          -> teuerstes Solo Tout: "
                + teuerstesSoloTout);
        
        contentStream.moveTextPositionByAmount(0, -20);
        contentStream.drawString("#Solo Sie: "
                + anzahlSoliSie
                + " (gewonnen: "
                + String.format("%.2f",
                        (anzahlSoliSie > 0 ? anzahlGewonneneSoliSie
                                / ((double) anzahlSoliSie) : 0) * 100) + "%)");
        
        contentStream.moveTextPositionByAmount(0, -20);
        contentStream.drawString("         -> teuerstes Solo Sie: " + teuerstesSoloSie);
        
        contentStream.moveTextPositionByAmount(0, -20);
        contentStream.drawString("#Weiter: " + anzahlWeiter);
	}
}
