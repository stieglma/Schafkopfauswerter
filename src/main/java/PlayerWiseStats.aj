import java.util.Iterator;

import me.stieglmaier.schafkopfAuswerter.model.SystemValues.Games;
import me.stieglmaier.schafkopfAuswerter.model.SystemValues.Players;
import me.stieglmaier.schafkopfAuswerter.model.SystemValues.WIN;
import me.stieglmaier.schafkopfAuswerter.model.db.DataObject;
import me.stieglmaier.schafkopfAuswerter.model.db.GameData;

public privileged aspect PlayerWiseStats {

    public PlayerWiseStatistics GameData.getPlayerWiseStatistics(Players player) {
        int gamesPlayedTot = 0;
        int gamesWonTot = 0;
        int highestAcc = 0;
        int lowestAcc = 0;
        int highestWin = 0;
        int highestLoss = 0;

        int[] gamesPlayedPerType = new int[Games.values().length];
        int[] gamesWonPerType = new int[Games.values().length];

        double gamesWonPerc = 0.0;
        double gamesWonPerTypePerc[] = new double[Games.values().length];

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
            int gameVal = dataObj.getPlayerVal(player)
                    - lastObj.getPlayerVal(player);
            if (gameVal > highestWin) {
                highestWin = gameVal;
            } else if (gameVal < highestLoss) {
                highestLoss = gameVal;
            }

            int accVal = dataObj.getPlayerVal(player);
            if (accVal > highestAcc) {
                highestAcc = accVal;
            } else if (accVal < lowestAcc) {
                lowestAcc = accVal;
            }

            lastObj = dataObj;
        }

        gamesWonPerc = ((gamesPlayedTot + gamesWonTot) > 0 ? (double) gamesWonTot
                / gamesPlayedTot
                : 0.0) * 100;

        for (Games game : Games.values()) {
            int i = game.ordinal();
            gamesWonPerTypePerc[i] = ((gamesPlayedPerType[i] + gamesWonPerType[i]) > 0 ? (double) gamesWonPerType[i]
                    / gamesPlayedPerType[i]
                    : 0.0) * 100;
        }
        
        return new PlayerWiseStatistics(gamesPlayedTot, gamesWonTot,
                highestAcc, lowestAcc, highestWin, highestLoss,
                gamesPlayedPerType, gamesWonPerType, gamesWonPerc,
                gamesWonPerTypePerc);
    }
}

class PlayerWiseStatistics {
    private int gamesPlayedTot = 0;
    private int gamesWonTot = 0;
    private int highestAcc = 0;
    private int lowestAcc = 0;
    private int highestWin = 0;
    private int highestLoss = 0;

    private int[] gamesPlayedPerType = new int[Games.values().length];
    private int[] gamesWonPerType = new int[Games.values().length];

    private double gamesWonPerc = 0.0;
    private double gamesWonPerTypePerc[] = new double[Games.values().length];;

    public PlayerWiseStatistics(int gamesPlayedTot, int gamesWonTot,
            int highestAcc, int lowestAcc, int highestWin, int highestLoss,
            int[] gamesPlayedPerType, int[] gamesWonPerType,
            double gamesWonPerc, double[] gamesWonPerTypePerc) {
        this.gamesPlayedTot = gamesPlayedTot;
        this.gamesWonTot = gamesWonTot;
        this.highestAcc = highestAcc;
        this.lowestAcc = lowestAcc;
        this.highestWin = highestWin;
        this.highestLoss = highestLoss;
        this.gamesPlayedPerType = gamesPlayedPerType;
        this.gamesWonPerType = gamesWonPerType;
        this.gamesWonPerc = gamesWonPerc;
        this.gamesWonPerTypePerc = gamesWonPerTypePerc;
    }

    public int getGamesPlayedTot() {
        return gamesPlayedTot;
    }

    public int getGamesWonTot() {
        return gamesWonTot;
    }

    public int getHighestAcc() {
        return highestAcc;
    }

    public int getLowestAcc() {
        return lowestAcc;
    }

    public int getHighestWin() {
        return highestWin;
    }

    public int getHighestLoss() {
        return highestLoss;
    }

    public int[] getGamesPlayedPerType() {
        return gamesPlayedPerType;
    }

    public int[] getGamesWonPerType() {
        return gamesWonPerType;
    }

    public double getGamesWonPerc() {
        return gamesWonPerc;
    }

    public double[] getGamesWonPerTypePerc() {
        return gamesWonPerTypePerc;
    }
}