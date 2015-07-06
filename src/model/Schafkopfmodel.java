package model;

import model.SystemValues;
import model.SystemValues.Games;
import model.SystemValues.Players;
import model.SystemValues.Schneider;
import model.SystemValues.Spritzen;
import model.SystemValues.WIN;
import model.db.DataObject;
import model.db.GameData;

public class Schafkopfmodel {

    GameData gameDB = new GameData();

    public GameData getGameData() {
        return gameDB;
    }

    public void addRufspiel(Players one, Players two, boolean won,
            int laufende, Schneider schneider, Spritzen spritze, int gedoppelt) {

        int price = (int) ((SystemValues.rufspiel + laufende
                * SystemValues.schneider + schneider.ordinal()
                * SystemValues.schneider) * Math.pow(2,
                (spritze.ordinal() + gedoppelt)));

        addRufspielHelp(price, one, two, won);
    }

    private void addRufspielHelp(int price, Players one, Players two,
            boolean won) {

        DataObject obj = gameDB.getLast();
        int[] playerVals = { obj.getValP1(), obj.getValP2(), obj.getValP3(),
                obj.getValP4() };

        if (!won) {
            price *= -1;
        }

        for (int i = 0; i < playerVals.length; i++) {
            if (i == one.getNumber() || i == two.getNumber()) {
                playerVals[i] += price;
            } else {
                playerVals[i] -= price;
            }
        }

        WIN win = won ? WIN.PLAYER : WIN.ENEMY;

        gameDB.addData(new DataObject(one.toString(), Games.RUFSPIEL, price,
                playerVals[0], playerVals[1], playerVals[2], playerVals[3], win));
    }

    public void addSolo(Players one, boolean won, int laufende,
            Schneider schneider, Spritzen spritze, int gedoppelt) {

        int price = (int) ((SystemValues.solo + laufende
                * SystemValues.schneider + schneider.ordinal()
                * SystemValues.schneider) * Math.pow(2,
                (spritze.ordinal() + gedoppelt)));

        addSoloHelp(price, one, won, Games.SOLO);
    }

    public void addSoloTout(Players one, boolean won, int laufende,
            Spritzen spritze, int gedoppelt) {

        int price = (int) ((SystemValues.solo + laufende
                * SystemValues.schneider) * Math.pow(2, (spritze.ordinal()
                + gedoppelt + 1)));

        addSoloHelp(price, one, won, Games.TOUT);
    }

    private void addSoloHelp(int price, Players one, boolean won, Games game) {
        DataObject obj = gameDB.getLast();
        int[] playerVals = { obj.getValP1(), obj.getValP2(), obj.getValP3(),
                obj.getValP4() };

        if (!won) {
            price *= -1;
        }

        for (int i = 0; i < playerVals.length; i++) {
            if (i == one.getNumber()) {
                playerVals[i] += price * 3;
            } else {
                playerVals[i] -= price;
            }
        }

        WIN win = won ? WIN.PLAYER : WIN.ENEMY;

        gameDB.addData(new DataObject(one.toString(), game, price,
                playerVals[0], playerVals[1], playerVals[2], playerVals[3], win));
    }

    public void addSoloSie(Players one, int gedoppelt) {
        int price = (int) ((SystemValues.solo + 8
                * SystemValues.schneider) * Math.pow(2, gedoppelt + 1));

        addSoloHelp(price, one, true, Games.SIE);
    }

    public void addWeiter() {
        DataObject obj = gameDB.getLast();
        gameDB.addData(new DataObject("/", Games.WEITER, 0, obj.getValP1(), obj
                .getValP2(), obj.getValP3(), obj.getValP4(), WIN.NOONE));
    }
}
