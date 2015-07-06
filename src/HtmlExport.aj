import java.awt.Component;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Iterator;

import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;

import model.SystemValues;
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

class ExportActionListener implements ActionListener {

    /** htmlTable will be set by advice from htmlExport */
    private static String htmlTable = "";
    private GUI gui;

    public ExportActionListener(GUI gui) {
        this.gui = gui;
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        PrintWriter writer;
        try {
            writer = new PrintWriter("Session_vom_"+new SimpleDateFormat("dd.MM_'um'_HH:mm").format(Calendar.getInstance().getTime()) + ".html", "UTF-8");
            writer.println(createHeader());
            writer.println("<p>Tabelle:</p>");
            writer.println(htmlTable);
            writer.close();
        } catch (FileNotFoundException | UnsupportedEncodingException e1) {
            JOptionPane.showConfirmDialog(gui, "Speichern fehlgeschlagen\n"+e1.getMessage());
        }
    }

    private String createHeader() {
        StringBuilder builder = new StringBuilder();
        builder.append("Preise:\n");
        builder.append("<p>Rufspiel: " + SystemValues.rufspiel + "</p>");
        builder.append("<p>Solo: " + SystemValues.solo + "</p>");
        builder.append("<p>Laufende/Schneider: " + SystemValues.schneider + "</p>");
        return builder.toString();
    }
}