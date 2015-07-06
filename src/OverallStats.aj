import model.SystemValues.WIN;
import model.db.DataObject;
import model.db.GameData;

public privileged aspect OverallStats {
    public OverallStatistics GameData.getOverallStatistics() {
        int anzahlSpieleGesamt = 0;
        int anzahlSpieleGesamtGewonnen = 0;
        int teuerstesRufspiel = 0;
        int teuerstesSolo = 0;
        int teuerstesSoloTout = 0;
        int teuerstesSoloSie = 0;
        int anzahlRufspiele = 0;
        int anzahlSoli = 0;
        int anzahlSoliTout = 0;
        int anzahlSoliSie = 0;
        int anzahlSoliGesamt = 0;
        int anzahlGewonneneSoliGesamt = 0;
        int anzahlGewonneneRufspiele = 0;
        int anzahlGewonneneSoli = 0;
        int anzahlGewonneneSoliTout = 0;
        int anzahlGewonneneSoliSie = 0;
        int anzahlWeiter = -1;
        double gesamtWinPerc = 0.0;
        double rufspieleWinPerc = 0.0;
        double soliGesamtWinPerc = 0.0;
        double soliNormalWinPerc = 0.0;
        double soliToutWinPerc = 0.0;
        double soliSieWinPerc = 0.0;

        for (DataObject obj : data) {
            switch (obj.getGameKind()) {
            case RUFSPIEL:
                anzahlRufspiele++;
                anzahlSpieleGesamt++;
                if (obj.getGameWon() == WIN.PLAYER) {
                    anzahlGewonneneRufspiele++;
                    anzahlSpieleGesamtGewonnen++;
                }
                if (obj.getGameValue() > teuerstesRufspiel) {
                    teuerstesRufspiel = obj.getGameValue();
                }
                break;
            case SOLO:
                anzahlSoli++;
                anzahlSpieleGesamt++;
                if (obj.getGameWon() == WIN.PLAYER) {
                    anzahlGewonneneSoli++;
                    anzahlSpieleGesamtGewonnen++;
                }
                if (obj.getGameValue() > teuerstesSolo) {
                    teuerstesSolo = obj.getGameValue();
                }
                break;
            case TOUT:
                anzahlSpieleGesamt++;
                if (obj.getGameWon() == WIN.PLAYER) {
                    anzahlGewonneneSoliTout++;
                    anzahlSpieleGesamtGewonnen++;
                }
                if (obj.getGameValue() > teuerstesSoloTout) {
                    teuerstesSoloTout = obj.getGameValue();
                }
                anzahlSoliTout++;
                break;
            case SIE:
                anzahlSpieleGesamt++;
                if (obj.getGameWon() == WIN.PLAYER) {
                    anzahlGewonneneSoliSie++;
                    anzahlSpieleGesamtGewonnen++;
                }
                anzahlSoliSie++;
                if (obj.getGameValue() > teuerstesSoloSie) {
                    teuerstesSoloSie = obj.getGameValue();
                }
                break;
            case WEITER:
                anzahlWeiter++;
                break;
            case NONE: // nothing to do here
                break;
            default: // here neither
                break;
            }
        }

        anzahlSoliGesamt = anzahlSoli + anzahlSoliTout + anzahlSoliSie;
        anzahlGewonneneSoliGesamt = anzahlGewonneneSoli
                + anzahlGewonneneSoliSie + anzahlGewonneneSoliTout;

        gesamtWinPerc = (anzahlSpieleGesamt > 0 ? anzahlSpieleGesamtGewonnen
                / ((double) anzahlSpieleGesamt) : 0) * 100;
        rufspieleWinPerc = (anzahlRufspiele > 0 ? anzahlGewonneneRufspiele
                / ((double) anzahlRufspiele) : 0) * 100;
        soliGesamtWinPerc = ((anzahlSoli + anzahlSoliSie + anzahlSoliTout) > 0 ? ((anzahlGewonneneSoli
                + anzahlGewonneneSoliTout + anzahlSoliSie) / 1.0 / (anzahlSoli
                + anzahlSoliSie + anzahlSoliTout))
                : 0) * 100;
        soliNormalWinPerc = (anzahlSoli > 0 ? anzahlGewonneneSoli
                / ((double) anzahlSoli) : 0) * 100;
        soliToutWinPerc = (anzahlSoliTout > 0 ? anzahlGewonneneSoliTout
                / ((double) anzahlSoliTout) : 0) * 100;
        soliSieWinPerc = (anzahlSoliSie > 0 ? anzahlSoliSie
                / ((double) anzahlSoliSie) : 0) * 100;

        return new OverallStatistics(anzahlSpieleGesamt,
                anzahlSpieleGesamtGewonnen, anzahlRufspiele,
                anzahlGewonneneRufspiele, anzahlSoli, anzahlGewonneneSoli,
                anzahlSoliTout, anzahlGewonneneSoliTout, anzahlSoliSie,
                anzahlGewonneneSoliSie, anzahlSoliGesamt,
                anzahlGewonneneSoliGesamt, anzahlWeiter, teuerstesRufspiel,
                teuerstesSolo, teuerstesSoloTout, teuerstesSoloSie,
                gesamtWinPerc, rufspieleWinPerc, soliGesamtWinPerc,
                soliNormalWinPerc, soliToutWinPerc, soliSieWinPerc);
    }
}

class OverallStatistics {
    private int anzahlSpieleGesamt;
    private int anzahlSpieleGesamtGewonnen;
    private int anzahlRufspiele;
    private int anzahlGewonneneRufspiele;
    private int anzahlSoli;
    private int anzahlGewonneneSoli;
    private int anzahlSoliTout;
    private int anzahlGewonneneSoliTout;
    private int anzahlSoliSie;
    private int anzahlGewonneneSoliSie;
    private int anzahlSoliGesamt;
    private int anzahlGewonneneSoliGesamt;
    private int anzahlWeiter;
    private int teuerstesRufspiel = 0;
    private int teuerstesSolo = 0;
    private int teuerstesSoloTout = 0;
    private int teuerstesSoloSie = 0;
    private double gesamtWinPerc = 0.0;
    private double rufspieleWinPerc = 0.0;
    private double soliGesamtWinPerc = 0.0;
    private double soliNormalWinPerc = 0.0;
    private double soliToutWinPerc = 0.0;
    private double soliSieWinPerc = 0.0;

    public OverallStatistics(int anzahlSpieleGesamt,
            int anzahlSpieleGesamtGewonnen, int anzahlRufspiele,
            int anzahlGewonneneRufspiele, int anzahlSoli,
            int anzahlGewonneneSoli, int anzahlSoliTout,
            int anzahlGewonneneSoliTout, int anzahlSoliSie,
            int anzahlGewonneneSoliSie, int anzahlSoliGesamt,
            int anzahlGewonneneSoliGesamt, int anzahlWeiter,
            int teuerstesRufspiel, int teuerstesSolo, int teuerstesSoloTout,
            int teuerstesSoloSie, double gesamtWinPerc,
            double rufspieleWinPerc, double soliGesamtWinPerc,
            double soliNormalWinPerc, double soliToutWinPerc,
            double soliSieWinPerc) {
        this.anzahlSpieleGesamt = anzahlSpieleGesamt;
        this.anzahlSpieleGesamtGewonnen = anzahlSpieleGesamtGewonnen;
        this.anzahlRufspiele = anzahlRufspiele;
        this.anzahlGewonneneRufspiele = anzahlGewonneneRufspiele;
        this.anzahlSoli = anzahlSoli;
        this.anzahlGewonneneSoli = anzahlGewonneneSoli;
        this.anzahlSoliTout = anzahlSoliTout;
        this.anzahlGewonneneSoliTout = anzahlGewonneneSoliTout;
        this.anzahlSoliSie = anzahlSoliSie;
        this.anzahlGewonneneSoliSie = anzahlGewonneneSoliSie;
        this.anzahlSoliGesamt = anzahlSoliGesamt;
        this.anzahlGewonneneSoliGesamt = anzahlGewonneneSoliGesamt;
        this.anzahlWeiter = anzahlWeiter;
        this.teuerstesRufspiel = teuerstesRufspiel;
        this.teuerstesSolo = teuerstesSolo;
        this.teuerstesSoloTout = teuerstesSoloTout;
        this.teuerstesSoloSie = teuerstesSoloSie;
        this.gesamtWinPerc = gesamtWinPerc;
        this.rufspieleWinPerc = rufspieleWinPerc;
        this.soliGesamtWinPerc = soliGesamtWinPerc;
        this.soliNormalWinPerc = soliNormalWinPerc;
        this.soliToutWinPerc = soliToutWinPerc;
        this.soliSieWinPerc = soliSieWinPerc;
    }

    public int getAnzahlSpieleGesamt() {
        return anzahlSpieleGesamt;
    }

    public int getAnzahlSpieleGesamtGewonnen() {
        return anzahlSpieleGesamtGewonnen;
    }

    public int getAnzahlRufspiele() {
        return anzahlRufspiele;
    }

    public int getAnzahlGewonneneRufspiele() {
        return anzahlGewonneneRufspiele;
    }

    public int getAnzahlSoli() {
        return anzahlSoli;
    }

    public int getAnzahlGewonneneSoli() {
        return anzahlGewonneneSoli;
    }

    public int getAnzahlSoliTout() {
        return anzahlSoliTout;
    }

    public int getAnzahlGewonneneSoliTout() {
        return anzahlGewonneneSoliTout;
    }

    public int getAnzahlSoliSie() {
        return anzahlSoliSie;
    }

    public int getAnzahlGewonneneSoliSie() {
        return anzahlGewonneneSoliSie;
    }

    public int getAnzahlSoliGesamt() {
        return anzahlSoliGesamt;
    }

    public int getAnzahlGewonneneSoliGesamt() {
        return anzahlGewonneneSoliGesamt;
    }

    public int getAnzahlWeiter() {
        return anzahlWeiter;
    }

    public int getTeuerstesRufspiel() {
        return teuerstesRufspiel;
    }

    public int getTeuerstesSolo() {
        return teuerstesSolo;
    }

    public int getTeuerstesSoloTout() {
        return teuerstesSoloTout;
    }

    public int getTeuerstesSoloSie() {
        return teuerstesSoloSie;
    }

    public double getGesamtWinPerc() {
        return gesamtWinPerc;
    }

    public double getRufspieleWinPerc() {
        return rufspieleWinPerc;
    }

    public double getSoliGesamtWinPerc() {
        return soliGesamtWinPerc;
    }

    public double getSoliNormalWinPerc() {
        return soliNormalWinPerc;
    }

    public double getSoliToutWinPerc() {
        return soliToutWinPerc;
    }

    public double getSoliSieWinPerc() {
        return soliSieWinPerc;
    }
}