package view;

import java.awt.BorderLayout;
import javax.swing.JPanel;
import javax.swing.JTextField;
import java.awt.FlowLayout;
import javax.swing.JLabel;

import java.awt.Component;
import java.awt.GridBagLayout;
import java.awt.GridBagConstraints;
import java.awt.Insets;
import javax.swing.JSeparator;
import javax.swing.SwingConstants;
import javax.swing.JButton;

import model.SystemValues;
import static model.SystemValues.Players;

public class ConfigPopup extends JPanel {

    private static final long serialVersionUID = 1L;
    private JTextField textPlayer1;
    private JTextField textPlayer2;
    private JTextField textPlayer3;
    private JTextField textPlayer4;
    private JTextField textSchneider;
    private JTextField textRufspiel;
    private JTextField textSolo;
    private GUI parent;

    /**
     * Create the frame.
     */
    public ConfigPopup(GUI parent) {
        this.parent = parent;
        initialize();
        setDefaultValues();
    }

    private void setDefaultValues() {
        textPlayer1.setText(Players.PLAYER_1.toString());
        textPlayer2.setText(Players.PLAYER_2.toString());
        textPlayer3.setText(Players.PLAYER_3.toString());
        textPlayer4.setText(Players.PLAYER_4.toString());

        textSchneider.setText(Integer.toString(SystemValues.schneider));
        textRufspiel.setText(Integer.toString(SystemValues.rufspiel));
        textSolo.setText(Integer.toString(SystemValues.solo));
    }

    private void initialize() {
        setBounds(100, 100, 500, 200);

        JPanel upperPane = new JPanel();
        add(upperPane, BorderLayout.NORTH);
        upperPane.setLayout(new BorderLayout());

        upperPane.add(createNamePanel());
        upperPane.add(new JSeparator(), BorderLayout.SOUTH);

        JPanel pricePaneOuter = new JPanel();
        add(pricePaneOuter, BorderLayout.WEST);
        pricePaneOuter.setLayout(new BorderLayout());

        pricePaneOuter.add(createPricePanel(), BorderLayout.CENTER);
        pricePaneOuter.add(new JSeparator(SwingConstants.VERTICAL),
                BorderLayout.EAST);

        add(createOptionsPane(), BorderLayout.CENTER);
    }

    private JPanel createOptionsPane() {
        JPanel optionsPane = new JPanel();
        optionsPane.setLayout(new BorderLayout(0, 0));
        optionsPane.add(createPanelSave(), BorderLayout.CENTER);
        return optionsPane;
    }

    private Component createPanelSave() {
        JPanel panelSave = new JPanel();
        panelSave.setLayout(new BorderLayout(0, 0));

        panelSave.add(new JSeparator(), BorderLayout.NORTH);

        JButton buttonSave = new JButton("Speichern");
        buttonSave.addActionListener(new ConfigSaveListener(textPlayer1, textPlayer2, textPlayer3, textPlayer4, textSchneider, textRufspiel, textSolo, parent, this));
        panelSave.add(buttonSave, BorderLayout.CENTER);
        return panelSave;
    }

    private JPanel createNamePanel() {
        JPanel namePane = new JPanel();
        namePane.setLayout(new FlowLayout(FlowLayout.CENTER, 5, 5));

        textPlayer1 = new JTextField();
        namePane.add(textPlayer1);
        textPlayer1.setColumns(10);

        textPlayer2 = new JTextField();
        namePane.add(textPlayer2);
        textPlayer2.setColumns(10);

        textPlayer3 = new JTextField();
        namePane.add(textPlayer3);
        textPlayer3.setColumns(10);

        textPlayer4 = new JTextField();
        namePane.add(textPlayer4);
        textPlayer4.setColumns(10);

        return namePane;
    }

    private JPanel createPricePanel() {
        JPanel pricePane = new JPanel();

        GridBagLayout gbl_pricePaneInner = new GridBagLayout();
        gbl_pricePaneInner.columnWidths = new int[] { 0, 0, 0, 0 };
        gbl_pricePaneInner.columnWeights = new double[] { 0.0, 0.0, 1.0,
                Double.MIN_VALUE };
        gbl_pricePaneInner.rowWeights = new double[] { Double.MIN_VALUE };
        pricePane.setLayout(gbl_pricePaneInner);

        GridBagConstraints gbc_separator_2 = new GridBagConstraints();
        gbc_separator_2.insets = new Insets(0, 0, 5, 5);
        gbc_separator_2.gridx = 0;
        gbc_separator_2.gridy = 0;
        pricePane.add(new JSeparator(), gbc_separator_2);

        GridBagConstraints gbc_lblSchneiderEtc = new GridBagConstraints();
        gbc_lblSchneiderEtc.insets = new Insets(0, 0, 5, 5);
        gbc_lblSchneiderEtc.gridx = 0;
        gbc_lblSchneiderEtc.gridy = 3;
        pricePane.add(new JLabel("Schneider, etc:"), gbc_lblSchneiderEtc);

        textSchneider = new JTextField();
        textSchneider.setHorizontalAlignment(SwingConstants.CENTER);
        GridBagConstraints gbc_textSchneider = new GridBagConstraints();
        gbc_textSchneider.insets = new Insets(0, 0, 5, 5);
        gbc_textSchneider.fill = GridBagConstraints.HORIZONTAL;
        gbc_textSchneider.gridx = 0;
        gbc_textSchneider.gridy = 4;
        pricePane.add(textSchneider, gbc_textSchneider);
        textSchneider.setColumns(10);

        GridBagConstraints gbc_lblRufspiel = new GridBagConstraints();
        gbc_lblRufspiel.insets = new Insets(0, 0, 5, 5);
        gbc_lblRufspiel.gridx = 0;
        gbc_lblRufspiel.gridy = 5;
        pricePane.add(new JLabel("Rufspiel:"), gbc_lblRufspiel);

        textRufspiel = new JTextField();
        textRufspiel.setHorizontalAlignment(SwingConstants.CENTER);
        GridBagConstraints gbc_textRufspiel = new GridBagConstraints();
        gbc_textRufspiel.insets = new Insets(0, 0, 5, 5);
        gbc_textRufspiel.fill = GridBagConstraints.HORIZONTAL;
        gbc_textRufspiel.gridx = 0;
        gbc_textRufspiel.gridy = 7;
        pricePane.add(textRufspiel, gbc_textRufspiel);
        textRufspiel.setColumns(10);

        GridBagConstraints gbc_textSolo = new GridBagConstraints();
        gbc_textSolo.insets = new Insets(0, 0, 5, 5);
        gbc_textSolo.gridx = 0;
        gbc_textSolo.gridy = 12;
        pricePane.add(new JLabel("Solo:"), gbc_textSolo);

        textSolo = new JTextField();
        textSolo.setHorizontalAlignment(SwingConstants.CENTER);
        GridBagConstraints gbc_textField_2 = new GridBagConstraints();
        gbc_textField_2.insets = new Insets(0, 0, 0, 5);
        gbc_textField_2.fill = GridBagConstraints.HORIZONTAL;
        gbc_textField_2.gridx = 0;
        gbc_textField_2.gridy = 13;
        pricePane.add(textSolo, gbc_textField_2);
        textSolo.setColumns(10);

        return pricePane;
    }

}
