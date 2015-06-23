import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.swing.JOptionPane;

import model.SystemValues;
import view.GUI;


public class ExportActionListener implements ActionListener {

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
