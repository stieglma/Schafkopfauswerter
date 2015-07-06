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
        statText.setText(getOverallStatisticsString());
    }

    public String getOverallStatisticsString() {
        OverallStatistics data = gui.model.getGameData().getOverallStatistics();

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

        return "#Spiele (ohne weiter): "
                + anzahlSpieleGesamt
                + " (gewonnen: "
                + String.format("%.2f",
                        (anzahlSpieleGesamt > 0 ? anzahlSpieleGesamtGewonnen
                                / ((double) anzahlSpieleGesamt) : 0) * 100)
                + "%)\n"
                + "#Rufspiele: "
                + anzahlRufspiele
                + " (gewonnen: "
                + String.format("%.2f",
                        (anzahlRufspiele > 0 ? anzahlGewonneneRufspiele
                                / ((double) anzahlRufspiele) : 0) * 100)
                + "%)\n"
                + "          -> teurstes Rufspiel: "
                + teuerstesRufspiel
                + "\n"
                + "#Soli gesamt: "
                + (anzahlSoli + anzahlSoliTout + anzahlSoliSie)
                + " (gewonnen: "
                + String.format("%.2f", sologesamtwin * 100)
                + "%)\n"
                + "#Soli normal: "
                + anzahlSoli
                + " (gewonnen: "
                + String.format("%.2f", (anzahlSoli > 0 ? anzahlGewonneneSoli
                        / ((double) anzahlSoli) : 0) * 100)
                + "%)\n"
                + "            -> teurstes Solo: "
                + teuerstesSolo
                + "\n"
                + "#Solo Tout: "
                + anzahlSoliTout
                + " (gewonnen: "
                + String.format("%.2f",
                        (anzahlSoliTout > 0 ? anzahlGewonneneSoliTout
                                / ((double) anzahlSoliTout) : 0) * 100)
                + "%)\n"
                + "          -> teurstes Solo Tout: "
                + teuerstesSoloTout
                + "\n"
                + "#Solo Sie: "
                + anzahlSoliSie
                + " (gewonnen: "
                + String.format("%.2f",
                        (anzahlSoliSie > 0 ? anzahlGewonneneSoliSie
                                / ((double) anzahlSoliSie) : 0) * 100) + "%)\n"
                + "         -> teurstes Solo Sie: " + teuerstesSoloSie + "\n"
                + "#Weiter: " + anzahlWeiter;
    }

    public OverallStatistics GameData.getOverallStatistics() {
        int anzahlSpieleGesamt = 0;
        int anzahlSpieleGesamtGewonnen = 0;
        int teuerstesRufspiel = 0;
        int teuerstesSolo = 0;
        int teuerstesSoloTout = 0;
        int teuerstesSoloSie = 0;
        int anzahlRufspiele = 0;
        int anzahlSoli = 0;
        int anzahlSoliTout = 0;
        int anzahlSoliSie = 0;
        int anzahlSoliGesamt = 0;
        int anzahlGewonneneSoliGesamt = 0;
        int anzahlGewonneneRufspiele = 0;
        int anzahlGewonneneSoli = 0;
        int anzahlGewonneneSoliTout = 0;
        int anzahlGewonneneSoliSie = 0;
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
                anzahlSoli++;
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
                anzahlSoliTout++;
                break;
            case SIE:
                anzahlSpieleGesamt++;
                if (obj.getGameWon() == WIN.PLAYER) {
                    anzahlGewonneneSoliSie++;
                    anzahlSpieleGesamtGewonnen++;
                }
                anzahlSoliSie++;
                if (obj.getGameValue() > teuerstesSoloSie) {
                    teuerstesSoloSie = obj.getGameValue();
                }
                break;
            case WEITER:
                anzahlWeiter++;
                break;
            case NONE: // nothing to do here
                break;
            default: // here neither
                break;
            }
        }

        anzahlSoliGesamt = anzahlSoli + anzahlSoliTout + anzahlSoliSie;
        anzahlGewonneneSoliGesamt = anzahlGewonneneSoli
                + anzahlGewonneneSoliSie + anzahlGewonneneSoliTout;

        return new OverallStatistics(anzahlSpieleGesamt,
                anzahlSpieleGesamtGewonnen, anzahlRufspiele,
                anzahlGewonneneRufspiele, anzahlSoli, anzahlGewonneneSoli,
                anzahlSoliTout, anzahlGewonneneSoliTout, anzahlSoliSie,
                anzahlGewonneneSoliSie, anzahlSoliGesamt,
                anzahlGewonneneSoliGesamt, anzahlWeiter, teuerstesRufspiel,
                teuerstesSolo, teuerstesSoloTout, teuerstesSoloSie);
    }
}

class OverallStatistics {

    private int anzahlSpieleGesamt;
    private int anzahlSpieleGesamtGewonnen;
    private int anzahlRufspiele;
    private int anzahlGewonneneRufspiele;
    private int anzahlSoli;
    private int anzahlGewonneneSoli;
    private int anzahlSoliTout;
    private int anzahlGewonneneSoliTout;
    private int anzahlSoliSie;
    private int anzahlGewonneneSoliSie;
    private int anzahlSoliGesamt;
    private int anzahlGewonneneSoliGesamt;
    private int anzahlWeiter;
    private int teuerstesRufspiel = 0;
    private int teuerstesSolo = 0;
    private int teuerstesSoloTout = 0;
    private int teuerstesSoloSie = 0;

    public OverallStatistics(int anzahlSpieleGesamt,
            int anzahlSpieleGesamtGewonnen, int anzahlRufspiele,
            int anzahlGewonneneRufspiele, int anzahlSoli,
            int anzahlGewonneneSoli, int anzahlSoliTout,
            int anzahlGewonneneSoliTout, int anzahlSoliSie,
            int anzahlGewonneneSoliSie, int anzahlSoliGesamt,
            int anzahlGewonneneSoliGesamt, int anzahlWeiter,
            int teuerstesRufspiel, int teuerstesSolo, int teuerstesSoloTout,
            int teuerstesSoloSie) {
        this.anzahlSpieleGesamt = anzahlSpieleGesamt;
        this.anzahlSpieleGesamtGewonnen = anzahlSpieleGesamtGewonnen;
        this.anzahlRufspiele = anzahlRufspiele;
        this.anzahlGewonneneRufspiele = anzahlGewonneneRufspiele;
        this.anzahlSoli = anzahlSoli;
        this.anzahlGewonneneSoli = anzahlGewonneneSoli;
        this.anzahlSoliTout = anzahlSoliTout;
        this.anzahlGewonneneSoliTout = anzahlGewonneneSoliTout;
        this.anzahlSoliSie = anzahlSoliSie;
        this.anzahlGewonneneSoliSie = anzahlGewonneneSoliSie;
        this.anzahlSoliGesamt = anzahlSoliGesamt;
        this.anzahlGewonneneSoliGesamt = anzahlGewonneneSoliGesamt;
        this.anzahlWeiter = anzahlWeiter;
        this.teuerstesRufspiel = teuerstesRufspiel;
        this.teuerstesSolo = teuerstesSolo;
        this.teuerstesSoloTout = teuerstesSoloTout;
        this.teuerstesSoloSie = teuerstesSoloSie;
    }

    public int getAnzahlSpieleGesamt() {
        return anzahlSpieleGesamt;
    }

    public int getAnzahlSpieleGesamtGewonnen() {
        return anzahlSpieleGesamtGewonnen;
    }

    public int getAnzahlRufspiele() {
        return anzahlRufspiele;
    }

    public int getAnzahlGewonneneRufspiele() {
        return anzahlGewonneneRufspiele;
    }

    public int getAnzahlSoli() {
        return anzahlSoli;
    }

    public int getAnzahlGewonneneSoli() {
        return anzahlGewonneneSoli;
    }

    public int getAnzahlSoliTout() {
        return anzahlSoliTout;
    }

    public int getAnzahlGewonneneSoliTout() {
        return anzahlGewonneneSoliTout;
    }

    public int getAnzahlSoliSie() {
        return anzahlSoliSie;
    }

    public int getAnzahlGewonneneSoliSie() {
        return anzahlGewonneneSoliSie;
    }

    public int getAnzahlSoliGesamt() {
        return anzahlSoliGesamt;
    }

    public int getAnzahlGewonneneSoliGesamt() {
        return anzahlGewonneneSoliGesamt;
    }

    public int getAnzahlWeiter() {
        return anzahlWeiter;
    }

    public int getTeuerstesRufspiel() {
        return teuerstesRufspiel;
    }

    public int getTeuerstesSolo() {
        return teuerstesSolo;
    }

    public int getTeuerstesSoloTout() {
        return teuerstesSoloTout;
    }

    public int getTeuerstesSoloSie() {
        return teuerstesSoloSie;
    }
}
