import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.LinearGradientPaint;

import javax.swing.JPanel;
import javax.swing.JTabbedPane;

import model.SystemValues.WIN;
import model.db.DataObject;
import de.erichseifert.gral.data.DataTable;
import de.erichseifert.gral.plots.BarPlot;
import de.erichseifert.gral.plots.PiePlot;
import de.erichseifert.gral.ui.InteractivePanel;
import de.erichseifert.gral.plots.BarPlot.BarRenderer;
import de.erichseifert.gral.plots.PiePlot.PieSliceRenderer;
import de.erichseifert.gral.plots.points.PointRenderer;
import de.erichseifert.gral.util.GraphicsUtils;
import de.erichseifert.gral.util.Insets2D;
import de.erichseifert.gral.util.Location;
import view.GUI;
import view.UIUpdater;
import model.db.GameData;

public privileged aspect StatPlayerWiseGraph {
    /** Statistics has to be the last feature executed, such that the subfeatures have the correct gui
     * object before statistics can create the tabbed pane
     */
    declare precedence : Statistics, StatPlayerWiseGraph, StatPlayerWiseTxt, StatOverallGraph, StatOverallTxt;

    private static GUI gui;
    private static JPanel panel = new JPanel();

    private static final Color COLOR1 = Color.GREEN;

    @SuppressWarnings("unchecked")
    private static DataTable playedTypes = new DataTable(Integer.class, String.class);
    @SuppressWarnings("unchecked")
    private static DataTable mostExpsvGame = new DataTable(Integer.class, Integer.class, String.class);
    @SuppressWarnings("unchecked")
    private static DataTable wonGames = new DataTable(Integer.class, Double.class, String.class);

    after() returning(GUI gui): call(GUI.new(*)) {
        StatPlayerWiseGraph.gui = gui;
    }

    after(JTabbedPane tabbedPane): 
                        execution(public static void StatisticsHelper.StatisticsPaneCreated(JTabbedPane))
                        && args(tabbedPane) {
        panel.setLayout(new GridLayout(2, 2));

        updateData();
        panel.add(new InteractivePanel(createExpGameBarPlot()));
        panel.add(new InteractivePanel(createWonGamesBarPlot()));
        panel.add(new InteractivePanel(createPlayedTypesPlot()));

        tabbedPane.addTab("PlayerWiseGrafik", panel);
    }

    after() : execution(* UIUpdater.run()) {
        updateData();
    }

    private static void updateData() {
        StatsData data = gui.model.getGameData().getPlayerWiseStatisticsData();

        while (playedTypes.getRowCount() > 0) {
            playedTypes.removeLast();
        }
        playedTypes.add(data.anzahlRufspiele, "Rufspiele");
        playedTypes.add(data.anzahlSolo, "Soli");
        playedTypes.add(data.anzahlSoloTout, "Soli Tout");
        playedTypes.add(data.anzahlSoloSie, "Soli Sie");
        playedTypes.add(data.anzahlWeiter, "Weiter");

        while (mostExpsvGame.getRowCount() > 0) {
            mostExpsvGame.removeLast();
        }
        mostExpsvGame.add(1, data.teuerstesRufspiel, "Rufspiel");
        mostExpsvGame.add(2, data.teuerstesSolo, "Solo");
        mostExpsvGame.add(3, data.teuerstesSoloTout, "Solo Tout");
        mostExpsvGame.add(4, data.teuerstesSoloSie, "Solo Sie");

        // percentage of won games by gametype
        double gesamt = (data.anzahlSpieleGesamt > 0 ? data.anzahlSpieleGesamtGewonnen
                / ((double) data.anzahlSpieleGesamt)
                : 0) * 100;
        double rufspiele = (data.anzahlRufspiele > 0 ? data.anzahlGewonneneRufspiele
                / ((double) data.anzahlRufspiele)
                : 0) * 100;
        double soli_gesamt = ((data.anzahlSolo + data.anzahlSoloSie + data.anzahlSoloTout) > 0 ? ((data.anzahlGewonneneSoli
                + data.anzahlGewonneneSoliTout + data.anzahlSoloSie) / 1.0 / (data.anzahlSolo
                + data.anzahlSoloSie + data.anzahlSoloTout))
                : 0) * 100;
        double soli_normal = (data.anzahlSolo > 0 ? data.anzahlGewonneneSoli
                / ((double) data.anzahlSolo) : 0) * 100;
        double soli_tout = (data.anzahlSoloTout > 0 ? data.anzahlGewonneneSoliTout
                / ((double) data.anzahlSoloTout)
                : 0) * 100;
        double soli_sie = (data.anzahlSoloSie > 0 ? data.anzahlSoloSie
                / ((double) data.anzahlSoloSie) : 0) * 100;

        while (wonGames.getRowCount() > 0) {
            wonGames.removeLast();
        }
        wonGames.add(1, gesamt, "Gesamt");
        wonGames.add(2, rufspiele, "Rufspiele");
        wonGames.add(3, soli_gesamt, "Soli gesamt");
        wonGames.add(4, soli_normal, "Soli normal");
        wonGames.add(5, soli_tout, "Soli Tout");
        wonGames.add(6, soli_sie, "Soli Sie");
    }

    private static PiePlot createPlayedTypesPlot() {
        PiePlot plot = new PiePlot(playedTypes);

        PointRenderer pointRenderer = plot.getPointRenderer(playedTypes);
        pointRenderer.setValueVisible(true);
        pointRenderer.setValueColumn(1);

        // Format plot
        plot.getTitle().setText("Anzahl gespielter Spieltypen");
        // Change plot size
        plot.setRadius(0.9);
        // Display a legend
        plot.setLegendVisible(true);
        // Add some margin to the plot area
        plot.setInsets(new Insets2D.Double(20.0, 40.0, 40.0, 40.0));

        PieSliceRenderer pieSliceRenderer = (PieSliceRenderer) plot
                .getPointRenderer(playedTypes);

        // Change relative size of inner region
        pieSliceRenderer.setInnerRadius(0.4);
        // Change the width of gaps between segments
        pieSliceRenderer.setGap(0.2);
        // Show labels
        pieSliceRenderer.setValueVisible(true);
        pieSliceRenderer.setValueColor(Color.WHITE);
        pieSliceRenderer.setValueFont(Font.decode(null).deriveFont(Font.BOLD));

        return plot;
    }

    public BarPlot createExpGameBarPlot() {
        // Create new bar plot
        BarPlot plot = new BarPlot(mostExpsvGame);

        // Format plot
        plot.getTitle().setText("Teuerstes Spiel pro Spieltyp");
        plot.setInsets(new Insets2D.Double(40.0, 40.0, 40.0, 40.0));
        plot.setBarWidth(0.075);

        // Format bars
        PointRenderer pointRenderer = plot.getPointRenderer(mostExpsvGame);
        BarRenderer barRenderer = (BarRenderer) pointRenderer;

        barRenderer.setColor(new LinearGradientPaint(0f, 0f, 0f, 1f,
                new float[] { 0.0f, 1.0f }, new Color[] { COLOR1,
                        GraphicsUtils.deriveBrighter(COLOR1) }));
        barRenderer.setBorderStroke(new BasicStroke(3f));
        barRenderer.setBorderColor(new LinearGradientPaint(0f, 0f, 0f, 1f,
                new float[] { 0.0f, 1.0f }, new Color[] {
                        GraphicsUtils.deriveBrighter(COLOR1), COLOR1 }));

        pointRenderer.setValueVisible(true);
        pointRenderer.setValueColumn(2);

        pointRenderer.setValueLocation(Location.CENTER);
        pointRenderer.setValueColor(GraphicsUtils.deriveDarker(COLOR1));
        pointRenderer.setValueFont(Font.decode(null).deriveFont(Font.BOLD));

        return plot;
    }

    public BarPlot createWonGamesBarPlot() {
        // Create new bar plot
        BarPlot plot = new BarPlot(wonGames);

        // Format plot
        plot.getTitle().setText("Gewonnene Spiele pro Spieltyp (in %)");
        plot.setInsets(new Insets2D.Double(40.0, 40.0, 40.0, 40.0));
        plot.setBarWidth(0.075);

        // Format bars
        PointRenderer pointRenderer = plot.getPointRenderer(wonGames);
        BarRenderer barRenderer = (BarRenderer) pointRenderer;

        barRenderer.setColor(new LinearGradientPaint(0f, 0f, 0f, 1f,
                new float[] { 0.0f, 1.0f }, new Color[] { COLOR1,
                        GraphicsUtils.deriveBrighter(COLOR1) }));
        barRenderer.setBorderStroke(new BasicStroke(3f));
        barRenderer.setBorderColor(new LinearGradientPaint(0f, 0f, 0f, 1f,
                new float[] { 0.0f, 1.0f }, new Color[] {
                        GraphicsUtils.deriveBrighter(COLOR1), COLOR1 }));

        pointRenderer.setValueVisible(true);
        pointRenderer.setValueColumn(2);

        pointRenderer.setValueLocation(Location.CENTER);
        pointRenderer.setValueColor(GraphicsUtils.deriveDarker(COLOR1));
        pointRenderer.setValueFont(Font.decode(null).deriveFont(Font.BOLD));

        return plot;
    }

    public StatsData GameData.getPlayerWiseStatisticsData() {
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
            case NONE:
                break; // nothing to do here
            default:
                break;
            }
        }

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