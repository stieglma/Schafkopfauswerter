package me.stieglmaier.schafkopfAuswerter.view;

import java.awt.Component;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JOptionPane;
import javax.swing.JTextField;

import me.stieglmaier.schafkopfAuswerter.model.SystemValues;
import me.stieglmaier.schafkopfAuswerter.model.SystemValues.Players;

public class ConfigSaveListener implements ActionListener {

    private JTextField player1;
    private JTextField player2;
    private JTextField player3;
    private JTextField player4;
    private JTextField schneider;
    private JTextField rufspiel;
    private JTextField solo;
    private GUI parent;
    private Component parentTab;

    public ConfigSaveListener(JTextField player1, JTextField player2, JTextField player3, JTextField player4, JTextField schneider, JTextField rufspiel, JTextField solo, GUI parent, Component parentTab) {
        this.player1 = player1;
        this.player2 = player2;
        this.player3 = player3;
        this.player4 = player4;
        this.schneider = schneider;
        this.rufspiel = rufspiel;
        this.solo = solo;
        this.parent = parent;
        this.parentTab = parentTab;
    }
    @Override
    public void actionPerformed(ActionEvent e) {
        Players.PLAYER_1.setName(player1.getText());
        Players.PLAYER_2.setName(player2.getText());
        Players.PLAYER_3.setName(player3.getText());
        Players.PLAYER_4.setName(player4.getText());

        try {
            SystemValues.schneider = Integer.parseInt(schneider.getText());
            SystemValues.rufspiel = Integer.parseInt(rufspiel.getText());
            SystemValues.solo = Integer.parseInt(solo.getText());
            parent.updateValues();
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(parentTab, "Nur Zahlen als Werte für Schneider, Rufspiel und Solo erlaubt.");
        }
    }
}
