import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.LinearGradientPaint;

import javax.swing.JPanel;
import javax.swing.JTabbedPane;

import model.SystemValues.Games;
import model.SystemValues.Players;
import view.GUI;
import view.UIUpdater;
import de.erichseifert.gral.data.DataTable;
import de.erichseifert.gral.plots.BarPlot;
import de.erichseifert.gral.plots.BarPlot.BarRenderer;
import de.erichseifert.gral.plots.PiePlot;
import de.erichseifert.gral.plots.PiePlot.PieSliceRenderer;
import de.erichseifert.gral.plots.points.PointRenderer;
import de.erichseifert.gral.ui.InteractivePanel;
import de.erichseifert.gral.util.GraphicsUtils;
import de.erichseifert.gral.util.Insets2D;
import de.erichseifert.gral.util.Location;

public privileged aspect StatPlayerWiseGraph {
    /**
     * Statistics has to be the last feature executed, such that the subfeatures
     * have the correct gui object before statistics can create the tabbed pane
     */
    declare precedence : Statistics, StatPlayerWiseGraph, StatPlayerWiseTxt, StatOverallGraph, StatOverallTxt;

    private static GUI gui;

    private static final JTabbedPane playersTabs = new JTabbedPane();
    private static final Color COLOR1 = Color.GREEN;

    private static DataTable playedTypes[] = new DataTable[4];
    private static DataTable wonGames[] = new DataTable[4];

    after() returning(GUI gui): call(GUI.new(*)) {
        StatPlayerWiseGraph.gui = gui;
    }

    @SuppressWarnings("unchecked")
    after(JTabbedPane tabbedPane): 
                        execution(public static void StatisticsHelper.StatisticsPaneCreated(JTabbedPane))
                        && args(tabbedPane) {

        for (int i = 0; i < Players.values().length; i++) {
            playedTypes[i] = new DataTable(Integer.class, String.class);
            wonGames[i] = new DataTable(Integer.class, Double.class,String.class);
        }

        for (Players player : Players.values()) {
            playersTabs.addTab(player.toString(), createPlayersPanel(player));
        }
        tabbedPane.addTab("Einzelstatistiken", playersTabs);
    }

    private JPanel createPlayersPanel(Players player) {
        JPanel containerPanel = new JPanel();
        containerPanel.setLayout(new GridLayout(2, 2));

        containerPanel.add(new InteractivePanel(createWonGamesBarPlot(player)));
        containerPanel.add(new InteractivePanel(createPlayedTypesPlot(player)));
        return containerPanel;
    }

    after() : execution(* UIUpdater.run()) {
        updateData();
        for (Players player : Players.values()) {
            playersTabs.setTitleAt(player.ordinal(), player.toString());
        }
    }

    private static void updateData() {
        for (Players player : Players.values()) {
            PlayerWiseStatistics data = gui.model.getGameData().getPlayerWiseStatistics(player);

            int curPlayer = player.ordinal();

            while (playedTypes[curPlayer].getRowCount() > 0) {
                playedTypes[curPlayer].removeLast();
            }
            playedTypes[curPlayer].add(data.getGamesPlayedPerType()[Games.RUFSPIEL.ordinal()], "Rufspiele");
            playedTypes[curPlayer].add(data.getGamesPlayedPerType()[Games.SOLO.ordinal()], "Soli");
            playedTypes[curPlayer].add(data.getGamesPlayedPerType()[Games.TOUT.ordinal()], "Soli Tout");
            playedTypes[curPlayer].add(data.getGamesPlayedPerType()[Games.SIE.ordinal()],"Soli Sie");
            playedTypes[curPlayer].add(data.getGamesPlayedPerType()[Games.WEITER.ordinal()], "Weiter");

            // percentage of won games by gametype
            int soliCompleteAmount = data.getGamesPlayedPerType()[Games.SOLO.ordinal()]
                    + data.getGamesPlayedPerType()[Games.SIE.ordinal()]
                    + data.getGamesPlayedPerType()[Games.TOUT.ordinal()];
            int soliCompleteAmountWon = data.getGamesWonPerType()[Games.SOLO.ordinal()]
                    + data.getGamesWonPerType()[Games.SIE.ordinal()]
                    + data.getGamesWonPerType()[Games.TOUT.ordinal()];
            double soliGesamtWonPerc = (soliCompleteAmount > 0
                    ? (double) soliCompleteAmountWon / soliCompleteAmount
                    : 0.0) * 100;

            while (wonGames[curPlayer].getRowCount() > 0) {
                wonGames[curPlayer].removeLast();
            }
            wonGames[curPlayer].add(1, data.getGamesWonPerc(), "Gesamt");
            wonGames[curPlayer].add(2, data.getGamesWonPerTypePerc()[Games.RUFSPIEL.ordinal()], "Rufspiele");
            wonGames[curPlayer].add(3, soliGesamtWonPerc, "Soli gesamt");
            wonGames[curPlayer].add(4, data.getGamesWonPerTypePerc()[Games.SOLO.ordinal()], "Soli normal");
            wonGames[curPlayer].add(5, data.getGamesWonPerTypePerc()[Games.TOUT.ordinal()], "Soli Tout");
            wonGames[curPlayer].add(6, data.getGamesWonPerTypePerc()[Games.SIE.ordinal()], "Soli Sie");
        }
    }

    private static PiePlot createPlayedTypesPlot(Players player) {
        int playerIndex = player.ordinal();

        PiePlot plot = new PiePlot(playedTypes[playerIndex]);

        PointRenderer pointRenderer = plot
                .getPointRenderer(playedTypes[playerIndex]);
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
                .getPointRenderer(playedTypes[playerIndex]);

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

    public BarPlot createWonGamesBarPlot(Players player) {
        int playerIndex = player.ordinal();

        // Create new bar plot
        BarPlot plot = new BarPlot(wonGames);

        // Format plot
        plot.getTitle().setText("Gewonnene Spiele pro Spieltyp (in %)");
        plot.setInsets(new Insets2D.Double(40.0, 40.0, 40.0, 40.0));
        plot.setBarWidth(0.075);

        // Format bars
        PointRenderer pointRenderer = plot.getPointRenderer(wonGames[playerIndex]);
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