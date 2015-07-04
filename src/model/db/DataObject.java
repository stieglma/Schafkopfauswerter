package model.db;

import model.SystemValues;
import model.SystemValues.Games;
import model.SystemValues.Players;
import model.SystemValues.WIN;

public class DataObject {

    private String player;
    private Games game;
    private int gameVal;
    private int valP1;
    private int valP2;
    private int valP3;
    private int valP4;
    private WIN won;

    public DataObject(String player, Games game, int gameVal, int valP1,
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
        
        String str = values[2];
        if (str.equals(Games.RUFSPIEL.toString())) {
            game = Games.RUFSPIEL;
        } else if (str.equals(Games.SIE.toString())) {
            game = Games.SIE;
        } else if (str.equals(Games.TOUT.toString())) {
            game = Games.TOUT;
        } else if (str.equals(Games.SOLO.toString())) {
            game = Games.SOLO;
        } else if (str.equals(Games.WEITER.toString())) {
            game = Games.WEITER;
        } else if (str.equals(Games.NONE.toString())) {
            game = Games.NONE;
        } else {
            throw new IllegalArgumentException();
        }

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
                             game.toString(),
                             Integer.toString(gameVal),
                             Integer.toString(valP1),
                             Integer.toString(valP2),
                             Integer.toString(valP3),
                             Integer.toString(valP4),
                             won.toString()};
    }

    public String getPlayer() {
        return player;
    }

    public Games getGameKind() {
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
    
    public int getPlayerVal(Players player) {
        if (player == Players.PLAYER_1) {
            return valP1;
        } else if (player == Players.PLAYER_2) {
            return valP2;
        } else if (player == Players.PLAYER_3) {
            return valP3;
        } else {
            return valP4;
        }
    }

    public WIN getGameWon() {
        return won;
    }

}
