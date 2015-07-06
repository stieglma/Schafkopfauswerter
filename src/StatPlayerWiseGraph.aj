import java.awt.BasicStroke;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.LinearGradientPaint;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.ButtonGroup;
import javax.swing.JPanel;
import javax.swing.JRadioButton;
import javax.swing.JTabbedPane;

import model.SystemValues.Games;
import model.SystemValues.Players;
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
    /**
     * Statistics has to be the last feature executed, such that the subfeatures
     * have the correct gui object before statistics can create the tabbed pane
     */
    declare precedence : Statistics, StatPlayerWiseGraph, StatPlayerWiseTxt, StatOverallGraph, StatOverallTxt;

    private static GUI gui;
    private static JPanel containerPanel = new JPanel();
    private static JPanel buttonPanel = new JPanel();
    private static JPanel[] graphPanels = new JPanel[4];

    private static final Color COLOR1 = Color.GREEN;

    private static DataTable playedTypes[] = new DataTable[4];
    private static DataTable wonGames[] = new DataTable[4];

    after() returning(GUI gui): call(GUI.new(*)) {
        StatPlayerWiseGraph.gui = gui;
    }

    after(JTabbedPane tabbedPane): 
                        execution(public static void StatisticsHelper.StatisticsPaneCreated(JTabbedPane))
                        && args(tabbedPane) {
        for (int i = 0; i < graphPanels.length; i++) {
            graphPanels[i] = new JPanel();
            playedTypes[i] = new DataTable(Integer.class, String.class);
            wonGames[i] = new DataTable(Integer.class, Double.class,
                    String.class);

        }

        updateData();

        JRadioButton player1CheckBox = new JRadioButton("Spieler 1");
        JRadioButton player2CheckBox = new JRadioButton("Spieler 2");
        JRadioButton player3CheckBox = new JRadioButton("Spieler 3");
        JRadioButton player4CheckBox = new JRadioButton("Spieler 4");

        player1CheckBox.setSelected(true);
        ButtonGroup buttonGroup = new ButtonGroup();
        buttonGroup.add(player1CheckBox);
        buttonGroup.add(player2CheckBox);
        buttonGroup.add(player3CheckBox);
        buttonGroup.add(player4CheckBox);

        player1CheckBox.addActionListener(new ActionListener() {

            @Override
            public void actionPerformed(ActionEvent e) {
                containerPanel.remove(1);
                containerPanel.add(graphPanels[0], BorderLayout.CENTER, 1);
                containerPanel.repaint();
            }
        });
        player2CheckBox.addActionListener(new ActionListener() {

            @Override
            public void actionPerformed(ActionEvent e) {
                containerPanel.remove(1);
                containerPanel.add(graphPanels[1], BorderLayout.CENTER, 1);
                containerPanel.repaint();
            }
        });
        player3CheckBox.addActionListener(new ActionListener() {

            @Override
            public void actionPerformed(ActionEvent e) {
                containerPanel.remove(1);
                containerPanel.add(graphPanels[2], BorderLayout.CENTER, 1);
                containerPanel.repaint();
            }
        });
        player4CheckBox.addActionListener(new ActionListener() {

            @Override
            public void actionPerformed(ActionEvent e) {
                containerPanel.remove(1);
                containerPanel.add(graphPanels[3], BorderLayout.CENTER, 1);
                containerPanel.repaint();
            }
        });

        buttonPanel.setLayout(new FlowLayout());
        buttonPanel.add(player1CheckBox);
        buttonPanel.add(player2CheckBox);
        buttonPanel.add(player3CheckBox);
        buttonPanel.add(player4CheckBox);

        for (JPanel graphPanel : graphPanels) {
            graphPanel.setLayout(new GridLayout(2, 2));
        }

        for (Players player : Players.values()) {
            int i = player.ordinal();
            graphPanels[i].add(new InteractivePanel(
                    createWonGamesBarPlot(player)));
            graphPanels[i].add(new InteractivePanel(
                    createPlayedTypesPlot(player)));
        }

        containerPanel.setLayout(new BorderLayout());
        containerPanel.add(buttonPanel, BorderLayout.NORTH, 0);
        containerPanel.add(graphPanels[0], BorderLayout.CENTER, 1);

        tabbedPane.addTab("PlayerWiseGrafik", containerPanel);
    }

    after() : execution(* UIUpdater.run()) {
        updateData();
    }

    private static void updateData() {
        for (Players player : Players.values()) {
            PlayerWiseStatistics data = gui.model.getGameData()
                    .getPlayerWiseStatistics(player);

            int i = player.ordinal();

            while (playedTypes[i].getRowCount() > 0) {
                playedTypes[i].removeLast();
            }
            playedTypes[i].add(
                    data.getGamesPlayedPerType()[Games.RUFSPIEL.ordinal()],
                    "Rufspiele");
            playedTypes[i].add(
                    data.getGamesPlayedPerType()[Games.SOLO.ordinal()], "Soli");
            playedTypes[i].add(
                    data.getGamesPlayedPerType()[Games.TOUT.ordinal()],
                    "Soli Tout");
            playedTypes[i].add(
                    data.getGamesPlayedPerType()[Games.SIE.ordinal()],
                    "Soli Sie");
            playedTypes[i].add(
                    data.getGamesPlayedPerType()[Games.WEITER.ordinal()],
                    "Weiter");

            // percentage of won games by gametype
            int soli_complete_amount = data.getGamesPlayedPerType()[Games.SOLO
                    .ordinal()]
                    + data.getGamesPlayedPerType()[Games.SIE.ordinal()]
                    + data.getGamesPlayedPerType()[Games.TOUT.ordinal()];
            int soli_complete_amount_won = data.getGamesWonPerType()[Games.SOLO
                    .ordinal()]
                    + data.getGamesWonPerType()[Games.SIE.ordinal()]
                    + data.getGamesWonPerType()[Games.TOUT.ordinal()];
            double soli_gesamt_won_perc = soli_complete_amount > 0 ? (double) soli_complete_amount_won
                    / soli_complete_amount
                    : 0.0;

            while (wonGames[i].getRowCount() > 0) {
                wonGames[i].removeLast();
            }
            wonGames[i].add(1, data.getGamesWonPerc(), "Gesamt");
            wonGames[i].add(2,
                    data.getGamesWonPerTypePerc()[Games.RUFSPIEL.ordinal()],
                    "Rufspiele");
            wonGames[i].add(3, soli_gesamt_won_perc, "Soli gesamt");
            wonGames[i].add(4,
                    data.getGamesWonPerTypePerc()[Games.SOLO.ordinal()],
                    "Soli normal");
            wonGames[i].add(5,
                    data.getGamesWonPerTypePerc()[Games.TOUT.ordinal()],
                    "Soli Tout");
            wonGames[i].add(6,
                    data.getGamesWonPerTypePerc()[Games.SIE.ordinal()],
                    "Soli Sie");
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
        PointRenderer pointRenderer = plot
                .getPointRenderer(wonGames[playerIndex]);
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