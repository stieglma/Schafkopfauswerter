import java.io.IOException;

import model.SystemValues.Games;
import model.SystemValues.Players;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.edit.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType1Font;

import view.GUI;

public privileged aspect StatisticsPlayerWiseExport {

	declare precedence: StatisticsPlayerWiseExport, StatisticsExport, GraphExport, PdfExport;
	private GUI gui;

	/**
	 * catch constructor call, so that we have the correct gui, to refer to
	 * everywhere
	 */
	after() returning(GUI gui): call(GUI.new(*)) {
		this.gui = gui;
	}
	
	/**
	 * Catch the call on {@link PDFReportListener.drawTable(PDDocument)} to get
	 * the pdf creator object.
	 * 
	 * This method then creates the pages and writes the statistics to the pdf.
	 * 
	 * @param document
	 * @throws IOException
	 */
	after(PDDocument document) returning() throws IOException
    		: call(* PDFReportListener.drawTable(PDDocument))
    		&& args(document) {
		PDPage page = new PDPage();
		document.addPage(page);
		PDPageContentStream contentStream = new PDPageContentStream(
				document, page);

		contentStream.beginText();
		contentStream.setFont(PDType1Font.HELVETICA_BOLD, 15);
		contentStream.moveTextPositionByAmount(100, 680);
		contentStream.drawString("Statistik fuer jeden einzelnen Spieler");
		contentStream.endText();

		for (int i = 0; i < Players.values().length; ++i) {
			contentStream.beginText();
			contentStream.setFont(PDType1Font.HELVETICA_BOLD, 10);
			createIndividualContent(contentStream, Players.values()[i]);
			contentStream.endText();
			contentStream.close();
			if (i < Players.values().length - 1) {
				page = new PDPage();
				document.addPage(page);
				contentStream = new PDPageContentStream(document, page);
			}
		}
	}
	
	/**
	 * Write the individual statistics for a given <code>player</code> to the
	 * given <code>contentStream</code>.
	 * 
	 * @param contentStream
	 * @param player
	 * @throws IOException
	 */
	private void createIndividualContent(PDPageContentStream contentStream,
			Players player) throws IOException {
		contentStream.moveTextPositionByAmount(50, 650);
		contentStream.drawString(player.toString());

		contentStream.moveTextPositionByAmount(0, -22);

		PlayerWiseStatistics data = gui.model.getGameData()
				.getPlayerWiseStatistics(player);

		contentStream.drawString("Gespielte Spiele:");
		contentStream.moveTextPositionByAmount(50, -16);
		contentStream.drawString("- Gesamt: " + data.getGamesPlayedTot()
				+ ", davon gewonnen: " + data.getGamesWonTot() + " ("
				+ String.format("%.2f", data.getGamesWonPerc()) + "%)");

		for (Games game : Games.values()) {
			if (game != Games.WEITER && game != Games.NONE) {
				int i = game.ordinal();
				contentStream.moveTextPositionByAmount(0, -16);
				contentStream.drawString("- "
						+ game.toString()
						+ ": "
						+ data.getGamesPlayedPerType()[i]
						+ ", davon gewonnen: "
						+ data.getGamesWonPerType()[i]
						+ " ("
						+ String.format("%.2f",
								data.getGamesWonPerTypePerc()[i]) + "%");
			}
		}

		contentStream.moveTextPositionByAmount(-50, -16);
		contentStream
				.drawString("Höchster Kontostand: " + data.getHighestAcc());

		contentStream.moveTextPositionByAmount(0, -16);
		contentStream.drawString("Niedrigster Kontostand: "
				+ data.getLowestAcc());

		contentStream.moveTextPositionByAmount(0, -16);
		contentStream.drawString("Größter Gewinn: " + data.getHighestWin());

		contentStream.moveTextPositionByAmount(0, -16);
		contentStream.drawString("Größter Verlust: " + data.getHighestLoss());

		contentStream.moveTextPositionByAmount(0, -32);
	}

}