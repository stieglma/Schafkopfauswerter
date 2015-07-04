import java.awt.GridLayout;
import java.util.Iterator;

import javax.swing.JPanel;
import javax.swing.JTabbedPane;
import javax.swing.JTextArea;

import view.GUI;
import view.UIUpdater;
import model.db.GameData;
import model.SystemValues.Games;
import model.SystemValues.Players;
import model.SystemValues.WIN;
import model.db.DataObject;

public privileged aspect StatPlayerWiseTxt {
    declare precedence : StatPlayerWiseTxt, StatOverallGraph, StatOverallTxt;

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

            int gamesPlayedTot = 0;
            int gamesWonTot = 0;
            int highestAcc = 0;
            int lowestAcc = 0;
            int highestWin = 0;
            int highestLoss = 0;

            int[] gamesPlayedPerType = new int[Games.values().length];
            int[] gamesWonPerType = new int[Games.values().length];

            Iterator<DataObject> it = data.iterator();
            DataObject lastObj = it.next();

            while (it.hasNext()) {
                DataObject dataObj = it.next();

                if (dataObj.getPlayer().equals(player.toString())) {
                    gamesPlayedTot++;
                    gamesPlayedPerType[dataObj.getGameKind().ordinal()]++;
                    if (dataObj.getGameWon() == WIN.PLAYER) {
                        gamesWonTot++;
                        gamesWonPerType[dataObj.getGameKind().ordinal()]++;
                    }
                }
                int gameVal = dataObj.getPlayerVal(player) - lastObj.getPlayerVal(player);
                if (gameVal > highestWin) {
                    highestWin = gameVal;
                } else if (gameVal < highestLoss) {
                    highestLoss = gameVal;
                }

                int accVal = dataObj.getPlayerVal(player);
                System.out.println(player + ": " + accVal);
                if (accVal > highestAcc) {
                    highestAcc = accVal;
                } else if (accVal < lowestAcc) {
                    lowestAcc = accVal;
                }
                
                lastObj = dataObj;
            }

            double gamesWonPerc = ((gamesPlayedTot + gamesWonTot) > 0 ? (double) gamesWonTot
                    / gamesPlayedTot
                    : 0.0) * 100;

            double gamesWonPerTypePerc[] = new double[Games.values().length];
            for (Games game : Games.values()) {
                int i = game.ordinal();
                gamesWonPerTypePerc[i] = ((gamesPlayedPerType[i] + gamesWonPerType[i]) > 0 ? (double) gamesWonPerType[i]
                        / gamesPlayedPerType[i]
                        : 0.0) * 100;
            }

            result.append(
                    "Gespielte Spiele:" + System.lineSeparator() + "\t"
                            + "- Gesamt: " + gamesPlayedTot)
                    .append(", davon gewonnen: " + gamesWonTot)
                    .append(" (" + String.format("%.2f", gamesWonPerc) + "%)"
                            + System.lineSeparator());

            for (Games game : Games.values()) {
                if (game != Games.WEITER) {
                    int i = game.ordinal();
                    result.append(
                            "\t- " + game.toString() + ": "
                                    + gamesPlayedPerType[i])
                            .append(", davon gewonnen: " + gamesWonPerType[i])
                            .append(" ("
                                    + String.format("%.2f",
                                            gamesWonPerTypePerc[i]) + "%)"
                                    + System.lineSeparator());
                }
            }

            result.append("Höchster Kontostand: " + highestAcc
                    + System.lineSeparator() + "Niedrigster Kontostand: "
                    + lowestAcc + System.lineSeparator());

            result.append("Größter Gewinn: " + highestWin
                    + System.lineSeparator());
            result.append("Größter Verlust: " + highestLoss
                    + System.lineSeparator());

            result.append(System.lineSeparator());
        }
        return result.toString();
    }
}