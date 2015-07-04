package view;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JOptionPane;

import model.Schafkopfmodel;
import model.SystemValues.Games;
import model.SystemValues.Players;
import model.SystemValues.Schneider;
import model.SystemValues.Spritzen;

public class SavingActionListener implements ActionListener {

    private AddGamePopup parentPopup;
    private GUI parent;
    private Schafkopfmodel model;

    public SavingActionListener(GUI parent, AddGamePopup parentPopup,
            Schafkopfmodel model) {
        this.model = model;
        this.parent = parent;
        this.parentPopup = parentPopup;
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        Games game = Games.values()[parentPopup.spielComboBox.getSelectedIndex()+1]; // we need to exclude Games.NOONE here
        if (game == Games.WEITER) {
            model.addWeiter();
            parent.updateValues();
            parentPopup.dispose();

        } else {
            int p1Idx = parentPopup.vonComboBox.getSelectedIndex();
            int p2Idx = parentPopup.mitComboBox.getSelectedIndex();

            Players p1 = Players.values()[p1Idx];
            Players p2 = Players.PLAYER_1;

            // combobox removes irrelevant matchings, so we have to take
            // care of correct index here
            if (p2Idx >= p1Idx && p2Idx >= 0) {
                p2Idx++;
                p2 = Players.values()[p2Idx];
            }

            Schneider schneider = Schneider.values()[parentPopup.schneiderComboBox.getSelectedIndex()];
            Spritzen spritze = Spritzen.values()[parentPopup.spritzeComboBox.getSelectedIndex()];

            int laufende = parentPopup.laufendeComboBox.getSelectedIndex();
            int gedoppelt = parentPopup.gedoppeltComboBox.getSelectedIndex();

            if (laufende > 14 || laufende < 0 || gedoppelt < 0
                    || gedoppelt > 4) {
                JOptionPane.showMessageDialog(parentPopup,
                        "Nur zahlen im richtigen Wertebereich zulässig.");
            }

            switch (game) {
            case RUFSPIEL:
                model.addRufspiel(p1, p2, parentPopup.spielerGewinntRadioButton.isSelected(),
                                  laufende, schneider, spritze, gedoppelt);
                break;
            case SOLO:
                model.addSolo(p1, parentPopup.spielerGewinntRadioButton.isSelected(),
                              laufende, schneider, spritze, gedoppelt);
                break;
            case TOUT:
                model.addSoloTout(p1, parentPopup.spielerGewinntRadioButton.isSelected(),
                                  laufende, spritze, gedoppelt);
                break;
            case SIE:
                model.addSoloSie(p1, gedoppelt);
            default:
                throw new AssertionError("unhandled case statement");
            }

            parent.updateValues();
            parentPopup.dispose();
        }
    }
}
