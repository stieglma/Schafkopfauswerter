import java.awt.GridLayout;

import javax.swing.JPanel;
import javax.swing.JTabbedPane;
import javax.swing.JTextArea;

import view.GUI;
import view.UIUpdater;

public privileged aspect StatOverallTxt {

    private static GUI gui;
    private static JPanel panel = new JPanel();
    private static JTextArea statText = new JTextArea();

    after() returning(GUI gui): call(GUI.new(*)) {
        StatOverallTxt.gui = gui;
    }

    after(JTabbedPane tabbedPane): 
			execution(public static void StatisticsHelper.StatisticsPaneCreated(JTabbedPane))
			&& args(tabbedPane) {
        statText.setEditable(false);
        panel.setLayout(new GridLayout(0, 1));
        panel.add(statText);
        ((JTabbedPane) tabbedPane).addTab("OverallText", panel);
    }

    after() : execution(* UIUpdater.run()) {
        statText.setText(getOverallStatisticsString());
    }

    public String getOverallStatisticsString() {
        OverallStatistics data = gui.model.getGameData().getOverallStatistics();

        return "#Spiele (ohne weiter): " + data.getAnzahlSpieleGesamt()
                + " (gewonnen: "
                + String.format("%.2f", data.getGesamtWinPerc()) + "%)\n"
                + "#Rufspiele: " + data.getAnzahlRufspiele() + " (gewonnen: "
                + String.format("%.2f", data.getRufspieleWinPerc()) + "%)\n"
                + "          -> teuerstes Rufspiel: "
                + data.getTeuerstesRufspiel() + "\n" + "#Soli gesamt: "
                + data.getAnzahlSoliGesamt() + " (gewonnen: "
                + String.format("%.2f", data.getSoliGesamtWinPerc())
                + "%)\n" + "#Soli normal: " + data.getAnzahlSoli()
                + " (gewonnen: "
                + String.format("%.2f", data.getSoliNormalWinPerc()) + "%)\n"
                + "            -> teuerstes Solo: " + data.getTeuerstesSolo()
                + "\n" + "#Solo Tout: " + data.getAnzahlSoliTout()
                + " (gewonnen: "
                + String.format("%.2f", data.getSoliToutWinPerc()) + "%)\n"
                + "          -> teuerstes Solo Tout: "
                + data.getTeuerstesSoloTout() + "\n" + "#Solo Sie: "
                + data.getAnzahlSoliSie() + "\n"
                + "         -> teuerstes Solo Sie: "
                + data.getTeuerstesSoloSie() + "\n" + "#Weiter: "
                + data.getAnzahlWeiter();
    }
}