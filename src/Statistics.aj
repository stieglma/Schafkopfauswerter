
import javax.swing.JPanel;
import javax.swing.JTabbedPane;

import view.GUI;

public privileged aspect Statistics {

    private JTabbedPane tabbedPane = new JTabbedPane(JTabbedPane.TOP);
    private JPanel statsPanel = new JPanel();

    /**
     * catch constructor call, so that we have the correct gui, to refer to everywhere
     */
    after() returning(GUI gui): call(GUI.new(*)) {
        gui.tabbedPane.addTab("Statistik", null, statsPanel, null);
        statsPanel.add(tabbedPane);
        StatisticsHelper.StatisticsPaneCreated(tabbedPane);
    }
}
