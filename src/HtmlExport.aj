import java.awt.Component;
import java.util.Iterator;

import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;

import model.db.DataObject;
import model.db.GameData;
import view.GUI;
import view.SchafkopfTableModel;

privileged aspect HtmlExport {

    private GUI gui;

    /**
     * catch constructor call, so that we have the correct gui, to refer to everywhere
     */
    after() returning(GUI gui): call(GUI.new(*)) {
        this.gui = gui;
    }

    private String SchafkopfTableModel.asHtmlTable() {
        StringBuilder str = new StringBuilder();
        str.append("<table>\n<thead>\n<tr>");
        for (int i = 0; i < getColumnCount(); i++) {
            str.append("<th>"+getColumnName(i)+"</th>");
        }
        str.append("</tr>\n</thead>\n<tbody>\n");
        str.append(data.asHtmlTableRows());
        str.append("</tbody>\n</table>");
        return str.toString();
    }

    private String GameData.asHtmlTableRows() {
        StringBuilder str = new StringBuilder();
        Iterator<DataObject> it = data.iterator();
        int index = 0;
        while (it.hasNext()) {
            str.append(asHtmlTableRow(index, it.next()) + "\n");
            index++;
        }
        return str.toString();
    }

    private static String asHtmlTableRow(int index, DataObject obj) {
        StringBuilder builder = new StringBuilder();
        builder.append("<tr>");
        for (String part : obj.asTextArray(index)) {
            builder.append("<td>" + part + "</td>");
        }
        builder.append("</tr>");
       return builder.toString();
    }

    /**
     * Add the save file feature to the menu bar
     */
    after() returning(JMenuBar bar): call(JMenuBar GUI.createMenu()) {
        JMenuItem itemSave = new JMenuItem("Spielstand speichern");
        itemSave.addActionListener(new ExportActionListener(gui));

        Component[] menus = bar.getComponents();
        if (menus.length != 0 && menus[0] instanceof JMenu) {
            ((JMenu)bar.getComponents()[0]).add(itemSave, 0);
        } else {
            throw new AssertionError("There should be a menu entry!");
        }
    }

    /**
     * set the htmltable value of the export action listener
     */
    before() : execution(* ExportActionListener.actionPerformed(*)) {
        ExportActionListener.htmlTable = ((SchafkopfTableModel) gui.table.getModel()).asHtmlTable();
    }
}
