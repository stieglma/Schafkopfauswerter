
import java.util.Iterator;

import javax.swing.JPanel;
import javax.swing.JTextArea;

import view.GUI;
import view.UIUpdater;
import model.SystemValues.WIN;
import model.db.DataObject;
import model.db.GameData;

public privileged aspect Statistics {

    private static GUI gui;
    private JPanel tabStatOverall = new JPanel();
    private JTextArea statOverall = new JTextArea();

    /**
     * catch constructor call, so that we have the correct gui, to refer to everywhere
     */
    after() returning(GUI gui): call(GUI.new(*)) {
        Statistics.gui = gui;
        statOverall.setEditable(false);
        tabStatOverall.add(statOverall);
        gui.tabbedPane.addTab("Statistik", null, tabStatOverall, null);
    }

    after() : execution(* UIUpdater.run()) {
        statOverall.setText(gui.model.getGameData().getOverallStatistics());
    }

    public String GameData.getOverallStatistics() {
        int anzahlSpieleGesamt = 0;
        int anzahlSpieleGesamtGewonnen = 0;
        int teuerstesRufspiel = 0;
        int teuerstesSolo = 0;
        int teuerstesSoloTout = 0;
        int teuerstesSoloSie = 0;
        int anzahlRufspiele = 0;
        int anzahlSolo = 0;
        int anzahlSoloTout = 0;
        int anzahlSoloSie = 0;
        int anzahlGewonneneRufspiele = 0;
        int anzahlGewonneneSoli = 0;
        int anzahlGewonneneSoliTout = 0;
        int anzahlWeiter = 0;
        
        Iterator<DataObject> it = data.iterator();
        DataObject obj;
        while(it.hasNext()) {
            obj = it.next();
            switch(obj.getGameKind()) {
            case "Rufspiel":
                anzahlRufspiele++;
                anzahlSpieleGesamt++;
                if(obj.getGameWon() == WIN.PLAYER) {
                    anzahlGewonneneRufspiele++;
                    anzahlSpieleGesamtGewonnen++;
                }
                if(obj.getGameValue() > teuerstesRufspiel) {
                    teuerstesRufspiel = obj.getGameValue();
                }
                break;
            case "Solo":
                anzahlSolo++;
                anzahlSpieleGesamt++;
                if(obj.getGameWon() == WIN.PLAYER) {
                    anzahlGewonneneSoli++;
                    anzahlSpieleGesamtGewonnen++;
                }
                if(obj.getGameValue() > teuerstesSolo) {
                    teuerstesSolo = obj.getGameValue();
                }
                break;
            case "Solo Tout":
                anzahlSpieleGesamt++;
                if(obj.getGameWon() == WIN.PLAYER) {
                    anzahlGewonneneSoliTout++;
                    anzahlSpieleGesamtGewonnen++;
                }
                if(obj.getGameValue() > teuerstesSoloTout) {
                    teuerstesSoloTout = obj.getGameValue();
                }
                anzahlSoloTout++;
                break;
            case "Solo Sie":
                anzahlSpieleGesamt++;
                anzahlSpieleGesamtGewonnen++;
                anzahlSoloSie++;
                if(obj.getGameValue() > teuerstesSoloSie) {
                    teuerstesSoloSie = obj.getGameValue();
                }
                break;
            case "weiter":
                anzahlWeiter++;
            break;
            }
        }


        double sologesamtwin = (anzahlSolo + anzahlSoloSie + anzahlSoloTout) > 0 ? ((anzahlGewonneneSoli + anzahlGewonneneSoliTout + anzahlSoloSie) / 1.0 / (anzahlSolo + anzahlSoloSie + anzahlSoloTout)) : 0;
       
        return "#Spiele (ohne weiter): " + anzahlSpieleGesamt + " (gewonnen: " + (anzahlSpieleGesamt > 0 ? anzahlSpieleGesamtGewonnen/((double)anzahlSpieleGesamt) : 0) + "%)\n" +
               "#Rufspiele: " + anzahlRufspiele + " (gewonnen: " + (anzahlRufspiele > 0 ? anzahlGewonneneRufspiele/((double)anzahlRufspiele) : 0) + "%)\n" +
               "          -> teurstes Rufspiel: " + teuerstesRufspiel + "\n" +
               "#Soli gesamt: " + (anzahlSolo + anzahlSoloTout + anzahlSoloSie) + " (gewonnen: " + sologesamtwin + "%)\n" +
               "#Soli normal: " + anzahlSolo + " (gewonnen: " + (anzahlSolo > 0 ? anzahlGewonneneSoli / ((double)anzahlSolo) : 0) + "%)\n" +
               "            -> teurstes Solo: " + teuerstesSolo + "\n" +
               "#Solo Tout: " + anzahlSoloTout + " (gewonnen: " + (anzahlSoloTout > 0 ? anzahlGewonneneSoliTout/((double)anzahlSoloTout) : 0) + "%)\n" +
               "          -> teurstes Solo Tout: " + teuerstesSoloTout + "\n" +
               "#Solo Sie: " + anzahlSoloSie + "\n" +
               "         -> teurstes Solo Sie: " + teuerstesSoloSie + "\n" +
               "#Weiter: " + anzahlWeiter;
    }
}
