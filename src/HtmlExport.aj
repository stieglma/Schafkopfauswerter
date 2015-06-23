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
            str.append(it.next().asHtmlTableRow(index)+ "\n");
            index++;
        }
        return str.toString();
    }

    private String DataObject.asHtmlTableRow(int index) {
       return "<tr><td>"+index+"</td><td>"+player+"</td><td>"+game+"</td><td>"+gameVal+"</td><td>"+valP1+"</td><td>"+valP2+"</td><td>"+valP3+"</td><td>"+valP4+"</td><td>"+won+"</td><td>"+stock+"</td></tr>";
    }

    after() returning(JMenuBar bar): call(JMenuBar GUI.createMenu()) {
        JMenuItem itemSave = new JMenuItem("Spielstand speichern");
        itemSave.addActionListener(new ExportActionListener(gui));

        Component[] menus = bar.getComponents();
        if (menus.length != 0 && menus[0] instanceof JMenu) {
            ((JMenu)bar.getComponents()[0]).add(itemSave);
        } else {
            throw new AssertionError("There should be a menu entry!");
        }
    }

    before() : execution(* ExportActionListener.actionPerformed(*)) {
        ExportActionListener.htmlTable = ((SchafkopfTableModel) gui.table.getModel()).asHtmlTable();
    }
}
