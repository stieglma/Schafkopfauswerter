package me.stieglmaier.schafkopfAuswerter.model;

public final class SystemValues {

  public static int schneider = 10;
  public static int rufspiel = 20;
  public static int solo = 50;

  public static enum Games {
    NONE("/"),
    WEITER("Weiter"),
    RUFSPIEL("Rufspiel"),
    SOLO("Solo"),
    TOUT("Solo Tout"),
    SIE("Solo Sie");

    private String name;

    private Games(String name) {
      this.name = name;
    }

    public String getName() {
      return this.name;
    }

    public String toString() {
      return this.name;
    }
  }

  public static enum Spritzen {
    NORMAL,
    CONTRA,
    RE,
    SUB,
    HIRSCH;
  }

  public static enum Schneider {
    NORMAL,
    SCHNEIDER,
    SCHWARZ;
  }

  public static enum Players {
    PLAYER_1("Spieler 1", 0),
    PLAYER_2("Spieler 2", 1),
    PLAYER_3("Spieler 3", 2),
    PLAYER_4("Spieler 4", 3);

    private String name;
    private int number;

    private Players(String str, int num) {
      name = str;
      number = num;
    }

    public int getNumber() {
      return number;
    }

    public void setName(String str) {
      name = str;
    }

    public String toString() {
      return name;
    }
  }

  public static enum WIN {
    NOONE,
    PLAYER,
    ENEMY;

    public static WIN getEnumFromString(String str) {
      if (str.equals(ENEMY.toString())) {
        return ENEMY;
      } else if (str.equals(PLAYER.toString())) {
        return PLAYER;
      } else if (str.equals(NOONE.toString())) {
        return NOONE;
      } else {
        throw new IllegalArgumentException();
      }
    }

    public String toString() {
      switch (this) {
        case ENEMY:
          return "nein";
        case NOONE:
          return "keiner";
        case PLAYER:
          return "ja";
      }
      // does never happen
      throw new AssertionError();
    }
  }
}
