import java.awt.GridLayout;

import javax.swing.JPanel;
import javax.swing.JTabbedPane;
import javax.swing.JTextArea;

import view.GUI;
import view.UIUpdater;
import model.db.GameData;
import model.SystemValues.WIN;
import model.db.DataObject;

public privileged aspect StatOverallTxt {

    private static GUI gui;
    private static JPanel panel = new JPanel();
    private static JTextArea statText = new JTextArea();

    after() returning(GUI gui): call(GUI.new(*)) {
        StatOverallTxt.gui = gui;
    }

    after(JTabbedPane tabbedPane): 
			execution(public static void StatisticsHelper.StatisticsPaneCreated(JTabbedPane))
			&& args(tabbedPane) {
        statText.setEditable(false);
        panel.setLayout(new GridLayout(0, 1));
        panel.add(statText);
        ((JTabbedPane) tabbedPane).addTab("OverallText", panel);
    }

    after() : execution(* UIUpdater.run()) {
        statText.setText(gui.model.getGameData().getOverallStatisticsString());
    }

    public String GameData.getOverallStatisticsString() {
        int anzahlSpieleGesamt = 0;
        int anzahlSpieleGesamtGewonnen = 0;
        int teuerstesRufspiel = 0;
        int teuerstesSolo = 0;
        int teuerstesSoloTout = 0;
        int teuerstesSoloSie = 0;
        int anzahlRufspiele = 0;
        int anzahlSolo = 0;
        int anzahlSoloTout = 0;
        int anzahlSoloSie = 0;
        int anzahlGewonneneRufspiele = 0;
        int anzahlGewonneneSoli = 0;
        int anzahlGewonneneSoliTout = 0;
        int anzahlWeiter = -1;

        for (DataObject obj : data) {
            switch (obj.getGameKind()) {
            case RUFSPIEL:
                anzahlRufspiele++;
                anzahlSpieleGesamt++;
                if (obj.getGameWon() == WIN.PLAYER) {
                    anzahlGewonneneRufspiele++;
                    anzahlSpieleGesamtGewonnen++;
                }
                if (obj.getGameValue() > teuerstesRufspiel) {
                    teuerstesRufspiel = obj.getGameValue();
                }
                break;
            case SOLO:
                anzahlSolo++;
                anzahlSpieleGesamt++;
                if (obj.getGameWon() == WIN.PLAYER) {
                    anzahlGewonneneSoli++;
                    anzahlSpieleGesamtGewonnen++;
                }
                if (obj.getGameValue() > teuerstesSolo) {
                    teuerstesSolo = obj.getGameValue();
                }
                break;
            case TOUT:
                anzahlSpieleGesamt++;
                if (obj.getGameWon() == WIN.PLAYER) {
                    anzahlGewonneneSoliTout++;
                    anzahlSpieleGesamtGewonnen++;
                }
                if (obj.getGameValue() > teuerstesSoloTout) {
                    teuerstesSoloTout = obj.getGameValue();
                }
                anzahlSoloTout++;
                break;
            case SIE:
                anzahlSpieleGesamt++;
                anzahlSpieleGesamtGewonnen++;
                anzahlSoloSie++;
                if (obj.getGameValue() > teuerstesSoloSie) {
                    teuerstesSoloSie = obj.getGameValue();
                }
                break;
            case WEITER:
                anzahlWeiter++;
                break;
            }
        }

        double sologesamtwin = (anzahlSolo + anzahlSoloSie + anzahlSoloTout) > 0 ? ((anzahlGewonneneSoli
                + anzahlGewonneneSoliTout + anzahlSoloSie) / 1.0 / (anzahlSolo
                + anzahlSoloSie + anzahlSoloTout))
                : 0;

        return "#Spiele (ohne weiter): "
                + anzahlSpieleGesamt
                + " (gewonnen: "
                + String.format("%.2f", (anzahlSpieleGesamt > 0 ? anzahlSpieleGesamtGewonnen
                        / ((double) anzahlSpieleGesamt) : 0) * 100)
                + "%)\n"
                + "#Rufspiele: "
                + anzahlRufspiele
                + " (gewonnen: "
                + String.format("%.2f", (anzahlRufspiele > 0 ? anzahlGewonneneRufspiele
                        / ((double) anzahlRufspiele) : 0) * 100)
                + "%)\n"
                + "          -> teurstes Rufspiel: "
                + teuerstesRufspiel
                + "\n"
                + "#Soli gesamt: "
                + (anzahlSolo + anzahlSoloTout + anzahlSoloSie)
                + " (gewonnen: "
                + String.format("%.2f", sologesamtwin * 100)
                + "%)\n"
                + "#Soli normal: "
                + anzahlSolo
                + " (gewonnen: "
                + String.format("%.2f", (anzahlSolo > 0 ? anzahlGewonneneSoli / ((double) anzahlSolo)
                        : 0) * 100)
                + "%)\n"
                + "            -> teurstes Solo: "
                + teuerstesSolo
                + "\n"
                + "#Solo Tout: "
                + anzahlSoloTout
                + " (gewonnen: "
                + String.format("%.2f", (anzahlSoloTout > 0 ? anzahlGewonneneSoliTout
                        / ((double) anzahlSoloTout) : 0) * 100) + "%)\n"
                + "          -> teurstes Solo Tout: " + teuerstesSoloTout
                + "\n" + "#Solo Sie: " + anzahlSoloSie + "\n"
                + "         -> teurstes Solo Sie: " + teuerstesSoloSie + "\n"
                + "#Weiter: " + anzahlWeiter;
    }
}
