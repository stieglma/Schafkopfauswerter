import java.awt.Color;
import java.awt.Font;
import java.awt.GridLayout;

import javax.swing.JPanel;
import javax.swing.JTabbedPane;

import model.SystemValues.WIN;
import model.db.DataObject;
import de.erichseifert.gral.data.DataTable;
import de.erichseifert.gral.plots.PiePlot;
import de.erichseifert.gral.ui.InteractivePanel;
import de.erichseifert.gral.plots.PiePlot.PieSliceRenderer;
import de.erichseifert.gral.util.Insets2D;
import view.GUI;
import view.UIUpdater;
import model.db.GameData;

public privileged aspect StatOverallGraphical {

    private static GUI gui;
    private static JPanel panel = new JPanel();

    @SuppressWarnings("unchecked")
    private static DataTable playedTypesTable = new DataTable(Integer.class);

    after() returning(GUI gui): call(GUI.new(*)) {
        StatOverallGraphical.gui = gui;
    }

    after(JTabbedPane tabbedPane): 
        execution(public static void StatisticsHelper.StatisticsPaneCreated(JTabbedPane))
        && args(tabbedPane) {
        panel.setLayout(new GridLayout(1, 2));

        panel.add(new InteractivePanel(createPlayedTypesPlot()));

        tabbedPane.addTab("OverallGrafik", panel);
    }

    after() : execution(* UIUpdater.run()) {
        updateData();
    }

    private static void updateData() {
        StatsData data = gui.model.getGameData().getOverallStatisticsData();

        playedTypesTable.clear();
        playedTypesTable.add(data.anzahlRufspiele);
        playedTypesTable.add(data.anzahlSolo);
        playedTypesTable.add(data.anzahlSoloTout);
        playedTypesTable.add(data.anzahlSoloSie);
        playedTypesTable.add(data.anzahlWeiter);
    }

    private static PiePlot createPlayedTypesPlot() {
        updateData();
        PiePlot plot = new PiePlot(playedTypesTable);

        // Format plot
        plot.getTitle().setText("Anzahl gespielter Spieltypen");
        // Change plot size
        plot.setRadius(0.9);
        // Display a legend
        plot.setLegendVisible(true);
        // Add some margin to the plot area
        plot.setInsets(new Insets2D.Double(20.0, 40.0, 40.0, 40.0));

        PieSliceRenderer pointRenderer = (PieSliceRenderer) plot.getPointRenderer(playedTypesTable);
        // Change relative size of inner region
        pointRenderer.setInnerRadius(0.4);
        // Change the width of gaps between segments
        pointRenderer.setGap(0.2);
        // Show labels
        pointRenderer.setValueVisible(true);
        pointRenderer.setValueColor(Color.WHITE);
        pointRenderer.setValueFont(Font.decode(null).deriveFont(Font.BOLD));

        return plot;
    }

    public StatsData GameData.getOverallStatisticsData() {
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
        int anzahlWeiter = 0;

        for (DataObject obj : data) {
            switch (obj.getGameKind()) {
            case "Rufspiel":
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
            case "Solo":
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
            case "Solo Tout":
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
            case "Solo Sie":
                anzahlSpieleGesamt++;
                anzahlSpieleGesamtGewonnen++;
                anzahlSoloSie++;
                if (obj.getGameValue() > teuerstesSoloSie) {
                    teuerstesSoloSie = obj.getGameValue();
                }
                break;
            case "weiter":
                anzahlWeiter++;
                break;
            }
        }

        double sologesamtwin = (anzahlSolo + anzahlSoloSie + anzahlSoloTout) > 0 ? ((anzahlGewonneneSoli
                + anzahlGewonneneSoliTout + anzahlSoloSie) / 1.0 / (anzahlSolo
                + anzahlSoloSie + anzahlSoloTout))
                : 0;

        return new StatsData(anzahlSpieleGesamt, anzahlSpieleGesamtGewonnen,
                teuerstesRufspiel, teuerstesSolo, teuerstesSoloTout,
                teuerstesSoloSie, anzahlRufspiele, anzahlSolo, anzahlSoloTout,
                anzahlSoloSie, anzahlGewonneneRufspiele, anzahlGewonneneSoli,
                anzahlGewonneneSoliTout, anzahlWeiter);
    }

    private static class StatsData {
        protected int anzahlSpieleGesamt = 0;
        protected int anzahlSpieleGesamtGewonnen = 0;
        protected int teuerstesRufspiel = 0;
        protected int teuerstesSolo = 0;
        protected int teuerstesSoloTout = 0;
        protected int teuerstesSoloSie = 0;
        protected int anzahlRufspiele = 0;
        protected int anzahlSolo = 0;
        protected int anzahlSoloTout = 0;
        protected int anzahlSoloSie = 0;
        protected int anzahlGewonneneRufspiele = 0;
        protected int anzahlGewonneneSoli = 0;
        protected int anzahlGewonneneSoliTout = 0;
        protected int anzahlWeiter = 0;

        public StatsData(int anzahlSpieleGesamt,
                int anzahlSpieleGesamtGewonnen, int teuerstesRufspiel,
                int teuerstesSolo, int teuerstesSoloTout, int teuerstesSoloSie,
                int anzahlRufspiele, int anzahlSolo, int anzahlSoloTout,
                int anzahlSoloSie, int anzahlGewonneneRufspiele,
                int anzahlGewonneneSoli, int anzahlGewonneneSoliTout,
                int anzahlWeiter) {
            this.anzahlSpieleGesamt = anzahlSpieleGesamt;
            this.anzahlSpieleGesamtGewonnen = anzahlSpieleGesamtGewonnen;
            this.teuerstesRufspiel = teuerstesRufspiel;
            this.teuerstesSolo = teuerstesSolo;
            this.teuerstesSoloTout = teuerstesSoloTout;
            this.teuerstesSoloSie = teuerstesSoloSie;
            this.anzahlRufspiele = anzahlRufspiele;
            this.anzahlSolo = anzahlSolo;
            this.anzahlSoloTout = anzahlSoloTout;
            this.anzahlSoloSie = anzahlSoloSie;
            this.anzahlGewonneneRufspiele = anzahlGewonneneRufspiele;
            this.anzahlGewonneneSoli = anzahlGewonneneSoli;
            this.anzahlGewonneneSoliTout = anzahlGewonneneSoliTout;
            this.anzahlWeiter = anzahlWeiter;
        }
    }
}