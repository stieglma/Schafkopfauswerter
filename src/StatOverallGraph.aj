import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.LinearGradientPaint;

import javax.swing.JPanel;
import javax.swing.JTabbedPane;

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

public privileged aspect StatOverallGraph {
    /** Statistics has to be the last feature executed, such that the subfeatures have the correct gui
     * object before statistics can create the tabbed pane
     */
    declare precedence : Statistics, StatOverallGraph, StatOverallTxt;

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
        StatOverallGraph.gui = gui;
    }

    after(JTabbedPane tabbedPane): 
			execution(public static void StatisticsHelper.StatisticsPaneCreated(JTabbedPane))
			&& args(tabbedPane) {
        panel.setLayout(new GridLayout(2, 2));

        updateData();
        panel.add(new InteractivePanel(createExpGameBarPlot()));
        panel.add(new InteractivePanel(createWonGamesBarPlot()));
        panel.add(new InteractivePanel(createPlayedTypesPlot()));

        tabbedPane.addTab("Gesamtstatistiken (Grafik)", panel);
    }

    after() : execution(* UIUpdater.run()) {
        updateData();
    }

    private static void updateData() {
        OverallStatistics data = gui.model.getGameData().getOverallStatistics();

        while (playedTypes.getRowCount() > 0) {
            playedTypes.removeLast();
        }
        playedTypes.add(data.getAnzahlRufspiele(), "Rufspiele");
        playedTypes.add(data.getAnzahlSoli(), "Soli");
        playedTypes.add(data.getAnzahlSoliTout(), "Soli Tout");
        playedTypes.add(data.getAnzahlSoliSie(), "Soli Sie");
        playedTypes.add(data.getAnzahlWeiter(), "Weiter");

        while (mostExpsvGame.getRowCount() > 0) {
            mostExpsvGame.removeLast();
        }
        mostExpsvGame.add(1, data.getTeuerstesRufspiel(), "Rufspiel");
        mostExpsvGame.add(2, data.getTeuerstesSolo(), "Solo");
        mostExpsvGame.add(3, data.getTeuerstesSoloTout(), "Solo Tout");
        mostExpsvGame.add(4, data.getTeuerstesSoloSie(), "Solo Sie");

        while (wonGames.getRowCount() > 0) {
            wonGames.removeLast();
        }
        wonGames.add(1, data.getGesamtWinPerc(), "Gesamt");
        wonGames.add(2, data.getRufspieleWinPerc(), "Rufspiele");
        wonGames.add(3, data.getSoliGesamtWinPerc(), "Soli gesamt");
        wonGames.add(4, data.getSoliNormalWinPerc(), "Soli normal");
        wonGames.add(5, data.getSoliToutWinPerc(), "Soli Tout");
        wonGames.add(6, data.getSoliSieWinPerc(), "Soli Sie");
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
}
