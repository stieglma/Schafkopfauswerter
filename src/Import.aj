import java.awt.Component;
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;

import javax.swing.JFileChooser;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;

import model.SystemValues;
import model.db.DataObject;
import model.db.GameData;
import view.GUI;
import view.SchafkopfTableModel;

privileged aspect Import {

    private GUI gui;

    /**
     * catch constructor call, so that we have the correct gui, to refer to everywhere
     */
    after() returning(GUI gui): call(GUI.new(*)) {
        this.gui = gui;
    }

    private void importFromHtmlTable(BufferedReader in) throws IOException {
        GameData newData = new GameData();
        String line;

        while((line=in.readLine()) != null) {
            if (line.startsWith("<tr>")) {
                line = line.replaceAll("<tr>", "");
                line = line.replaceAll("</tr>", "");
                if (line.startsWith("<th>")) {
                    line = line.replaceAll("</th>", "");
                    line = line.replaceFirst("<th>", "");
                    String[] tmp = line.split("<th>");
                    SystemValues.Players.PLAYER_1.setName(tmp[4]);
                    SystemValues.Players.PLAYER_2.setName(tmp[5]);
                    SystemValues.Players.PLAYER_3.setName(tmp[6]);
                    SystemValues.Players.PLAYER_4.setName(tmp[7]);
                    continue;
                } else if (!line.startsWith("<td>")) {
                    continue;
                }
                line = line.replaceAll("</td>", "");
                line = line.replaceFirst("<td>", "");
                String[] tmp = line.split("<td>");
                // first line is ignored
                if (tmp[0].equals("0")) {
                    continue;
                }
                newData.addData(new DataObject(tmp));
            }
        }
        gui.model.gameDB = newData;
        gui.table.setModel(new SchafkopfTableModel(gui.model.getGameData()));
        gui.updateValues();
    }

    /**
     * Add import feature to the menubar
     */
    after() returning(JMenuBar bar): call(JMenuBar GUI.createMenu()) {
        JMenuItem itemLoad = new JMenuItem("Spielstand laden");
        itemLoad.addActionListener(new LoadFileListener());

        Component[] menus = bar.getComponents();
        if (menus.length != 0 && menus[0] instanceof JMenu) {
            ((JMenu)bar.getComponents()[0]).add(itemLoad,0);
        } else {
            throw new AssertionError("There should be a menu entry!");
        }
    }

    /**
     * pointcut for the LoadFileListener, this is necessary to be able to change
     * the gameDB object (c.f. importFromHtmlTable).
     */
    after() : execution(* LoadFileListener.actionPerformed(*)) {
        JFileChooser chooser = new JFileChooser();
        if (chooser.showOpenDialog(gui) == JFileChooser.APPROVE_OPTION) {
            try {
                BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream(chooser.getSelectedFile())));
                if (!LoadFileListener.setSystemValues(in.readLine(), in.readLine())) {
                    JOptionPane.showConfirmDialog(gui, "Laden fehlgeschlagen\n(Ungültiges Dateiformat)");
                    in.close();
                }
                importFromHtmlTable(in);
                gui.tabbedPane.setEnabledAt(1, true);
                gui.repaint();
            } catch (IOException e1) {
                JOptionPane.showConfirmDialog(gui, "Laden fehlgeschlagen\n"+e1.getMessage());
            }
        }
    }
}
