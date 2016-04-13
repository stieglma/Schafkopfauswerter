package me.stieglmaier.schafkopfAuswerter.view;

import java.awt.*;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JComboBox;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JLabel;

import me.stieglmaier.schafkopfAuswerter.model.Schafkopfmodel;
import me.stieglmaier.schafkopfAuswerter.model.SystemValues;

import javax.swing.ButtonGroup;
import javax.swing.JRadioButton;
import javax.swing.JSeparator;
import javax.swing.JButton;

public class AddGamePopup extends JFrame {

  private static final long serialVersionUID = 1L;
  private JPanel mainPanel;
  private JPanel gamePanel;
  private JPanel chooser;
  private JLabel lblGame;
  JComboBox<String> spielComboBox =
      new JComboBox<String>(new String[] {"weiter", "Rufspiel", "Solo", "Solo Tout", "Solo Sie"});
  private JLabel lblVon;
  JComboBox<String> vonComboBox =
      new JComboBox<String>(
          new String[] {
            SystemValues.Players.PLAYER_1.toString(),
            SystemValues.Players.PLAYER_2.toString(),
            SystemValues.Players.PLAYER_3.toString(),
            SystemValues.Players.PLAYER_4.toString()
          });
  private JLabel lblMit;
  JComboBox<String> mitComboBox =
      new JComboBox<String>(
          new String[] {
            SystemValues.Players.PLAYER_2.toString(),
            SystemValues.Players.PLAYER_3.toString(),
            SystemValues.Players.PLAYER_4.toString()
          });
  private JPanel separatorPanel;
  private JSeparator separatorTop;
  private JPanel valuesPanel;
  private JPanel schneiderPanel;
  private JLabel lblSchneider;
  JComboBox<String> schneiderComboBox;
  private JPanel spritzePanel;
  private JLabel lblSpritze;
  JComboBox<String> spritzeComboBox;
  private JPanel gedoppeltPanel;
  private JLabel lblGedoppelt;
  JComboBox<String> gedoppeltComboBox;
  JPanel laufendePanel;
  private JLabel lblLaufende;
  JComboBox<String> laufendeComboBox;
  private JPanel bottomPanel;
  private JPanel winnerPanel;
  JRadioButton spielerGewinntRadioButton;
  private JRadioButton spielerVerliertRadioButton;
  private JButton saveGameButton;
  private JSeparator separatorBottom;
  private Schafkopfmodel model;
  private GUI parent;

  /**
   * Create the frame.
   */
  public AddGamePopup(final GUI parent, final Schafkopfmodel model) {
    this.parent = parent;
    this.model = model;
    setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
    createFrameContent();
    createAllActionListeners();
    disableForWeiter();
    setContentPane(mainPanel);
  }

  private void disableForWeiter() {
    vonComboBox.setEnabled(false);
    mitComboBox.setEnabled(false);
    schneiderComboBox.setEnabled(false);
    spritzeComboBox.setEnabled(false);
    gedoppeltComboBox.setEnabled(false);
    laufendeComboBox.setEnabled(false);
    spielerGewinntRadioButton.setEnabled(false);
    spielerVerliertRadioButton.setEnabled(false);
  }

  private void enableEverything() {
    vonComboBox.setEnabled(true);
    mitComboBox.setEnabled(true);
    schneiderComboBox.setEnabled(true);
    spritzeComboBox.setEnabled(true);
    gedoppeltComboBox.setEnabled(true);
    laufendeComboBox.setEnabled(true);
    spielerGewinntRadioButton.setEnabled(true);
    spielerVerliertRadioButton.setEnabled(true);
  }

  private void disableForSolo() {
    vonComboBox.setEnabled(true);
    mitComboBox.setEnabled(false);
    schneiderComboBox.setEnabled(true);
    spritzeComboBox.setEnabled(true);
    gedoppeltComboBox.setEnabled(true);
    laufendeComboBox.setEnabled(true);
    spielerGewinntRadioButton.setEnabled(true);
    spielerVerliertRadioButton.setEnabled(true);
  }

  private void disableForSoloTout() {
    vonComboBox.setEnabled(true);
    mitComboBox.setEnabled(false);
    schneiderComboBox.setEnabled(false);
    spritzeComboBox.setEnabled(true);
    gedoppeltComboBox.setEnabled(true);
    laufendeComboBox.setEnabled(true);
    spielerGewinntRadioButton.setEnabled(true);
    spielerVerliertRadioButton.setEnabled(true);
  }

  private void disableForSoloSie() {
    vonComboBox.setEnabled(true);
    mitComboBox.setEnabled(false);
    schneiderComboBox.setEnabled(false);
    spritzeComboBox.setEnabled(true);
    gedoppeltComboBox.setEnabled(true);
    laufendeComboBox.setEnabled(false);
    laufendeComboBox.setSelectedIndex(7);
    spielerGewinntRadioButton.setEnabled(false);
    spielerVerliertRadioButton.setEnabled(false);
  }

  private void createFrameContent() {
    mainPanel = new JPanel();
    mainPanel.setLayout(new BorderLayout(0, 0));
    gamePanel = new JPanel();
    gamePanel.setLayout(new BorderLayout(0, 0));
    mainPanel.add(gamePanel, BorderLayout.NORTH);
    chooser = new JPanel();
    chooser.setLayout(new FlowLayout(FlowLayout.CENTER, 5, 5));
    gamePanel.add(chooser, BorderLayout.CENTER);
    lblGame = new JLabel();
    lblGame.setText("Spiel:");
    chooser.add(lblGame);
    spielComboBox =
        new JComboBox<String>(new String[] {"weiter", "Rufspiel", "Solo", "Solo Tout", "Solo Sie"});
    chooser.add(spielComboBox);
    lblVon = new JLabel();
    lblVon.setText("von:");
    chooser.add(lblVon);
    vonComboBox =
        new JComboBox<String>(
            new String[] {
              SystemValues.Players.PLAYER_1.toString(),
              SystemValues.Players.PLAYER_2.toString(),
              SystemValues.Players.PLAYER_3.toString(),
              SystemValues.Players.PLAYER_4.toString()
            });
    chooser.add(vonComboBox);
    lblMit = new JLabel();
    lblMit.setText("mit:");
    chooser.add(lblMit);
    mitComboBox =
        new JComboBox<String>(
            new String[] {
              SystemValues.Players.PLAYER_2.toString(),
              SystemValues.Players.PLAYER_3.toString(),
              SystemValues.Players.PLAYER_4.toString()
            });
    chooser.add(mitComboBox);
    separatorPanel = new JPanel();
    separatorPanel.setLayout(new FlowLayout(FlowLayout.CENTER, 5, 5));
    gamePanel.add(separatorPanel, BorderLayout.SOUTH);
    separatorTop = new JSeparator();
    separatorPanel.add(separatorTop);
    valuesPanel = new JPanel();
    valuesPanel.setLayout(new FlowLayout(FlowLayout.CENTER, 5, 5));
    mainPanel.add(valuesPanel, BorderLayout.CENTER);
    schneiderPanel = new JPanel();
    schneiderPanel.setLayout(new BorderLayout(0, 0));
    valuesPanel.add(schneiderPanel);
    lblSchneider = new JLabel();
    lblSchneider.setText("Schneider:");
    schneiderPanel.add(lblSchneider, BorderLayout.NORTH);
    schneiderComboBox = new JComboBox<String>(new String[] {"normal", "schneider", "schwarz"});
    schneiderPanel.add(schneiderComboBox, BorderLayout.CENTER);
    spritzePanel = new JPanel();
    spritzePanel.setLayout(new BorderLayout(0, 0));
    valuesPanel.add(spritzePanel);
    lblSpritze = new JLabel();
    lblSpritze.setText("Spritze:");
    spritzePanel.add(lblSpritze, BorderLayout.NORTH);
    spritzeComboBox =
        new JComboBox<String>(new String[] {"normal", "contra", "re", "sup", "hirsch"});
    spritzePanel.add(spritzeComboBox, BorderLayout.CENTER);
    gedoppeltPanel = new JPanel();
    gedoppeltPanel.setLayout(new BorderLayout(0, 0));
    valuesPanel.add(gedoppeltPanel);
    lblGedoppelt = new JLabel();
    lblGedoppelt.setText("Gedoppelt:");
    gedoppeltPanel.add(lblGedoppelt, BorderLayout.NORTH);
    gedoppeltComboBox = new JComboBox<String>(new String[] {"0", "1", "2", "3", "4"});
    gedoppeltPanel.add(gedoppeltComboBox, BorderLayout.CENTER);
    laufendePanel = new JPanel();
    laufendePanel.setLayout(new BorderLayout(0, 0));
    valuesPanel.add(laufendePanel);
    lblLaufende = new JLabel();
    lblLaufende.setText("Laufende:");
    laufendePanel.add(lblLaufende, BorderLayout.NORTH);
    laufendeComboBox =
        new JComboBox<String>(
            new String[] {
              "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14"
            });
    laufendePanel.add(laufendeComboBox, BorderLayout.CENTER);
    bottomPanel = new JPanel();
    bottomPanel.setLayout(new BorderLayout(0, 0));
    mainPanel.add(bottomPanel, BorderLayout.SOUTH);
    winnerPanel = new JPanel();
    winnerPanel.setLayout(new FlowLayout(FlowLayout.CENTER, 5, 5));
    bottomPanel.add(winnerPanel, BorderLayout.CENTER);
    spielerGewinntRadioButton = new JRadioButton();
    spielerGewinntRadioButton.setSelected(true);
    spielerGewinntRadioButton.setText("Spieler gewinnt");
    winnerPanel.add(spielerGewinntRadioButton);
    spielerVerliertRadioButton = new JRadioButton();
    spielerVerliertRadioButton.setText("Spieler verliert");
    winnerPanel.add(spielerVerliertRadioButton);
    saveGameButton = new JButton();
    saveGameButton.setText("Spiel speichern");
    bottomPanel.add(saveGameButton, BorderLayout.SOUTH);
    separatorBottom = new JSeparator();
    bottomPanel.add(separatorBottom, BorderLayout.NORTH);
    lblGame.setLabelFor(spielComboBox);
    lblVon.setLabelFor(vonComboBox);
    lblMit.setLabelFor(mitComboBox);
    lblSchneider.setLabelFor(schneiderComboBox);
    lblSpritze.setLabelFor(spritzeComboBox);
    lblGedoppelt.setLabelFor(gedoppeltComboBox);
    lblLaufende.setLabelFor(laufendeComboBox);
    ButtonGroup buttonGroup;
    buttonGroup = new ButtonGroup();
    buttonGroup.add(spielerGewinntRadioButton);
    buttonGroup.add(spielerGewinntRadioButton);
    buttonGroup.add(spielerVerliertRadioButton);
  }

  private void createAllActionListeners() {
    spielComboBox.addActionListener(
        new ActionListener() {

          @Override
          public void actionPerformed(ActionEvent e) {
            enableEverything();
            if (spielComboBox.getSelectedIndex() == 0) {
              disableForWeiter();
            } else if (spielComboBox.getSelectedIndex() == 2) {
              disableForSolo();
            } else if (spielComboBox.getSelectedIndex() == 3) {
              disableForSoloTout();
            } else if (spielComboBox.getSelectedIndex() == 4) {
              disableForSoloSie();
            }
          }
        });

    vonComboBox.addActionListener(
        new ActionListener() {
          @Override
          public void actionPerformed(ActionEvent e) {
            mitComboBox.removeAllItems();
            switch (vonComboBox.getSelectedIndex()) {
              case 0:
                mitComboBox.addItem(SystemValues.Players.PLAYER_2.toString());
                mitComboBox.addItem(SystemValues.Players.PLAYER_3.toString());
                mitComboBox.addItem(SystemValues.Players.PLAYER_4.toString());
                break;
              case 1:
                mitComboBox.addItem(SystemValues.Players.PLAYER_1.toString());
                mitComboBox.addItem(SystemValues.Players.PLAYER_3.toString());
                mitComboBox.addItem(SystemValues.Players.PLAYER_4.toString());
                break;
              case 2:
                mitComboBox.addItem(SystemValues.Players.PLAYER_1.toString());
                mitComboBox.addItem(SystemValues.Players.PLAYER_2.toString());
                mitComboBox.addItem(SystemValues.Players.PLAYER_4.toString());
                break;
              case 3:
                mitComboBox.addItem(SystemValues.Players.PLAYER_1.toString());
                mitComboBox.addItem(SystemValues.Players.PLAYER_2.toString());
                mitComboBox.addItem(SystemValues.Players.PLAYER_3.toString());
                break;
            }
          }
        });

    saveGameButton.addActionListener(new SavingActionListener(parent, this, model));
  }
}
