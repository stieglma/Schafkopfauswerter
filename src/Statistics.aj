import java.awt.GridLayout;
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
        
        statsPanel.setLayout(new GridLayout(0, 1));
        statsPanel.add(tabbedPane);
        
        StatisticsHelper.StatisticsPaneCreated(tabbedPane);
    }
}

/**
 * This class contains a dummy method to enable the statistic subfeatures to
 * get the JTabbedPane of the "Statistics" aspect.
 */
class StatisticsHelper {

        public static void StatisticsPaneCreated(JTabbedPane tabbedPane) {}
}