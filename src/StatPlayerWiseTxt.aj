import javax.swing.JScrollPane;
import javax.swing.JTabbedPane;
import javax.swing.JTextArea;
import javax.swing.ScrollPaneConstants;

import me.stieglmaier.schafkopfAuswerter.view.GUI;
import me.stieglmaier.schafkopfAuswerter.view.UIUpdater;
import me.stieglmaier.schafkopfAuswerter.model.db.GameData;
import me.stieglmaier.schafkopfAuswerter.model.SystemValues.Games;
import me.stieglmaier.schafkopfAuswerter.model.SystemValues.Players;

public privileged aspect StatPlayerWiseTxt {
    /**
     * Statistics has to be the last feature executed, such that the subfeatures
     * have the correct gui object before statistics can create the tabbed pane
     */
    declare precedence : Statistics, StatPlayerWiseTxt, StatOverallGraph, StatOverallTxt;

    private static GUI gui;
    private static JTextArea statText = new JTextArea();

    after() returning(GUI gui): call(GUI.new(*)) {
        StatPlayerWiseTxt.gui = gui;
    }

    after(JTabbedPane tabbedPane): 
                        execution(public static void StatisticsHelper.StatisticsPaneCreated(JTabbedPane))
                        && args(tabbedPane) {
        statText.setEditable(false);
        JScrollPane scrollPane = new JScrollPane(statText,
                ScrollPaneConstants.VERTICAL_SCROLLBAR_AS_NEEDED,
                ScrollPaneConstants.HORIZONTAL_SCROLLBAR_AS_NEEDED);
        ((JTabbedPane) tabbedPane).addTab("Einzelstatistiken", scrollPane);
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

            PlayerWiseStatistics data = gui.model.getGameData()
                    .getPlayerWiseStatistics(player);

            result.append(
                    "Gespielte Spiele:" + System.lineSeparator() + "\t"
                            + "- Gesamt: " + data.getGamesPlayedTot())
                    .append(", davon gewonnen: " + data.getGamesWonTot())
                    .append(" ("
                            + String.format("%.2f", data.getGamesWonPerc())
                            + "%)" + System.lineSeparator());

            for (Games game : Games.values()) {
                if (game != Games.WEITER && game != Games.NONE) {
                    int i = game.ordinal();
                    result.append(
                            "\t- " + game.toString() + ": "
                                    + data.getGamesPlayedPerType()[i])
                            .append(", davon gewonnen: "
                                    + data.getGamesWonPerType()[i])
                            .append(" ("
                                    + String.format("%.2f",
                                            data.getGamesWonPerTypePerc()[i])
                                    + "%)" + System.lineSeparator());
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