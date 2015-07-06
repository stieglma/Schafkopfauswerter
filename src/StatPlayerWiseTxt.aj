import java.awt.GridLayout;

import javax.swing.JPanel;
import javax.swing.JTabbedPane;
import javax.swing.JTextArea;

import view.GUI;
import view.UIUpdater;
import model.db.GameData;
import model.SystemValues.Games;
import model.SystemValues.Players;

public privileged aspect StatPlayerWiseTxt {
    /** Statistics has to be the last feature executed, such that the subfeatures have the correct gui
     * object before statistics can create the tabbed pane
     */
    declare precedence : Statistics, StatPlayerWiseTxt, StatOverallGraph, StatOverallTxt;

    private static GUI gui;
    private static JPanel panel = new JPanel();
    private static JTextArea statText = new JTextArea();

    after() returning(GUI gui): call(GUI.new(*)) {
        StatPlayerWiseTxt.gui = gui;
    }

    after(JTabbedPane tabbedPane): 
                        execution(public static void StatisticsHelper.StatisticsPaneCreated(JTabbedPane))
                        && args(tabbedPane) {
        statText.setEditable(false);
        panel.setLayout(new GridLayout(0, 1));
        panel.add(statText);
        ((JTabbedPane) tabbedPane).addTab("PlayerWiseText", panel);
    }

    after() : execution(* UIUpdater.run()) {
        statText.setText(gui.model.getGameData()
                .getPlayerWiseStatisticsString());
    }

    public String GameData.getPlayerWiseStatisticsString() {
        StringBuilder result = new StringBuilder();

        for (Players player : Players.values()) {
            result.append(player);
            result.append(":" + System.lineSeparator() + System.lineSeparator());

            PlayerWiseStatistics data = gui.model.getGameData().getPlayerWiseStatistics(player);

            result.append(
                    "Gespielte Spiele:" + System.lineSeparator() + "\t"
                            + "- Gesamt: " + data.getGamesPlayedTot())
                    .append(", davon gewonnen: " + data.getGamesWonTot())
                    .append(" (" + String.format("%.2f", data.getGamesWonPerc()) + "%)"
                            + System.lineSeparator());

            for (Games game : Games.values()) {
                if (game != Games.WEITER && game != Games.NONE) {
                    int i = game.ordinal();
                    result.append(
                            "\t- " + game.toString() + ": "
                                    + data.getGamesPlayedPerType()[i])
                            .append(", davon gewonnen: " + data.getGamesWonPerType()[i])
                            .append(" ("
                                    + String.format("%.2f",
                                            data.getGamesWonPerTypePerc()[i]) + "%)"
                                    + System.lineSeparator());
                }
            }

            result.append("Höchster Kontostand: " + data.getHighestAcc()
                    + System.lineSeparator() + "Niedrigster Kontostand: "
                    + data.getLowestAcc() + System.lineSeparator());

            result.append("Größter Gewinn: " + data.getHighestWin()
                    + System.lineSeparator());
            result.append("Größter Verlust: " + data.getHighestLoss()
                    + System.lineSeparator());

            result.append(System.lineSeparator());
        }
        return result.toString();
    }
}