package model.db;

import model.SystemValues;
import model.SystemValues.WIN;

public class DataObject {

    private String player;
    private String game;
    private int gameVal;
    private int valP1;
    private int valP2;
    private int valP3;
    private int valP4;
    private WIN won;

    public DataObject(String player, String game, int gameVal, int valP1,
            int valP2, int valP3, int valP4, WIN noone) {

        this.player = player;
        this.game = game;
        this.gameVal = gameVal;
        this.valP1 = valP1;
        this.valP2 = valP2;
        this.valP3 = valP3;
        this.valP4 = valP4;
        this.won = noone;
    }

    public DataObject(String[] values) {
        player = values[1];
        game = values[2];
        gameVal = Integer.parseInt(values[3]);
        valP1 = Integer.parseInt(values[4]);
        valP2 = Integer.parseInt(values[5]);
        valP3 = Integer.parseInt(values[6]);
        valP4 = Integer.parseInt(values[7]);
        won = SystemValues.WIN.getEnumFromString(values[8]);
    }

    public DataObject copyOf() {
        return new DataObject(player, game, gameVal, valP1, valP2, valP3, valP4, won);
    }

    public String[] asTextArray(int index) {
        return new String[] {Integer.toString(index),
                             player,
                             game,
                             Integer.toString(gameVal),
                             Integer.toString(valP1),
                             Integer.toString(valP2),
                             Integer.toString(valP3),
                             Integer.toString(valP4)};
    }

    public String getPlayer() {
        return player;
    }

    public String getGameKind() {
        return game;
    }

    public int getGameValue() {
        return gameVal;
    }

    public int getValP1() {
        return valP1;
    }

    public int getValP2() {
        return valP2;
    }

    public int getValP3() {
        return valP3;
    }

    public int getValP4() {
        return valP4;
    }

    public WIN getGameWon() {
        return won;
    }

}
