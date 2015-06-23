import java.awt.Color;

import javax.swing.JMenuBar;

import view.GUI;
import view.SavingActionListener;


privileged aspect ShowDealer {

    /**
     * Add dealer to menu
     */
    after() returning(JMenuBar bar): call(private JMenuBar GUI.createMenu()) {
        Dealer.dealer.setForeground(Color.red);
        bar.add(Dealer.dealer);
        Dealer.updateShownDealer();
    }

    /**
     * advance dealer after adding a game entry
     */
    before(): execution(public void SavingActionListener.actionPerformed(*)) {
        Dealer.updateDealer();
    }
}
