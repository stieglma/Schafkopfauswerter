package me.stieglmaier.schafkopfAuswerter.view;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.SQLException;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTabbedPane;
import javax.swing.ScrollPaneConstants;
import javax.swing.SwingConstants;

import me.stieglmaier.schafkopfAuswerter.model.Schafkopfmodel;

public class GUI extends JFrame {

    private static final long serialVersionUID = 1L;
    private JTable table;
    private JTabbedPane tabbedPane = new JTabbedPane(JTabbedPane.TOP);
    private Schafkopfmodel model;
    /**
     * Create the frame.
     * 
     * @throws SQLException
     * @throws ClassNotFoundException
     */
    public GUI(Schafkopfmodel m) {
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setBounds(100, 100, 600, 400);

        model = m;

        add(createMenu(), BorderLayout.NORTH);
        add(createTabbedPane(), BorderLayout.CENTER);
        add(createButtonPane(), BorderLayout.SOUTH);
    }

    public void updateValues() {
        EventQueue.invokeLater(new UIUpdater(table));

    }

    private JMenuBar createMenu() {
        JMenuBar menuBar = new JMenuBar();

        JMenu menuFile = new JMenu("Datei");
        JMenuItem endProgram = new JMenuItem("Beenden");
        endProgram.addActionListener(new ActionListener() {
            
            @Override
            public void actionPerformed(ActionEvent e) {
                for (Frame frame : JFrame.getFrames()) {
                    frame.dispose();
                }
            }
        });
        menuFile.add(endProgram);
        menuBar.add(menuFile);

        return menuBar;
    }

    private JPanel createButtonPane() {
        JPanel buttonPane = new JPanel();

        buttonPane.setLayout(new FlowLayout(FlowLayout.CENTER, 5, 5));

        JButton buttonAddGame = new JButton("Spiel hinzufügen");
        buttonAddGame.addActionListener(new ActionListener() {

            @Override
            public void actionPerformed(ActionEvent e) {
                tabbedPane.setSelectedIndex(1);
                JFrame addGame = new AddGamePopup(GUI.this, model);
                addGame.pack();
                addGame.setLocation(getLocation());
                addGame.setVisible(true);
                updateValues();
                tabbedPane.setEnabledAt(1, true);
            }
        });
        buttonPane.add(buttonAddGame);

        return buttonPane;
    }

    private JTabbedPane createTabbedPane() {

        table = new JTable(new SchafkopfTableModel(model.getGameData()));
        table.setDragEnabled(false);
        ((JLabel) table.getDefaultRenderer(Object.class))
                .setHorizontalAlignment(SwingConstants.CENTER);
        JScrollPane scrollPane = new JScrollPane(table,
                ScrollPaneConstants.VERTICAL_SCROLLBAR_AS_NEEDED,
                ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);

        tabbedPane.addTab("Einstellungen", null, new ConfigPopup(this), null);
        tabbedPane.addTab("Tabelle", null, scrollPane, null);

        tabbedPane.setEnabledAt(1, false);

        return tabbedPane;
    }
}
