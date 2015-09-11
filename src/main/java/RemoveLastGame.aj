import java.awt.Button;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JPanel;

import me.stieglmaier.schafkopfAuswerter.model.Schafkopfmodel;
import me.stieglmaier.schafkopfAuswerter.model.db.GameData;
import me.stieglmaier.schafkopfAuswerter.view.GUI;


public privileged aspect RemoveLastGame {

    private GUI gui;
    private JButton buttonRemoveLastGame;

    /**
     * catch constructor call, so that we have the correct gui, to refer to everywhere
     */
    after() returning(GUI gui): call(GUI.new(Schafkopfmodel)) {
        this.gui = gui;
    }

    private boolean Schafkopfmodel.removeLastGame() {
        return gameDB.removeLast();
    }

    private boolean GameData.removeLast() {
        if(data.size() > 1) {
            data.remove(data.size()-1);
            p1.removeLast();
            p2.removeLast();
            p3.removeLast();
            p4.removeLast();
            return true;
        }
        return false;
    }

    after() : execution(* GameData.addData(*)) {
        this.buttonRemoveLastGame.setEnabled(true);
    }

    /** add remove last game button */
    after() returning(JPanel panel): call(JPanel GUI.createButtonPane()) {
        this.buttonRemoveLastGame = new JButton("letztes Spiel löschen");
        this.buttonRemoveLastGame.addActionListener(new RemoveLastGameListener());
        panel.add(buttonRemoveLastGame);
        this.buttonRemoveLastGame.setEnabled(false);
    }

    /** catch execution of removelastgamelistener and remove the game + update ui */
    after() : execution(* RemoveLastGameListener.actionPerformed(*)) {
        gui.tabbedPane.setSelectedIndex(1);
        if (gui.model.removeLastGame()) {
            gui.table.updateUI();
            gui.updateValues();
        }

        if(gui.model.getGameData().size() <= 1) {
            this.buttonRemoveLastGame.setEnabled(false);
        }
    }

}

class RemoveLastGameListener implements ActionListener {

    /** filled with pointcut from RemoveLastGame.aj*/
    @Override
    public void actionPerformed(ActionEvent e) {}
}