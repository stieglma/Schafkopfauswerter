import java.awt.Color;

import javax.swing.JMenu;
import javax.swing.JMenuBar;

import me.stieglmaier.schafkopfAuswerter.model.SystemValues.Players;
import me.stieglmaier.schafkopfAuswerter.view.GUI;
import me.stieglmaier.schafkopfAuswerter.view.SavingActionListener;


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

class Dealer {

    private static int dealerIndex = 0;
    private static JMenu dealer = new JMenu();

    @SuppressWarnings("unused")
    private static void updateDealer() {
        dealerIndex++;
        dealerIndex %= 4;
        updateShownDealer();
    }

    private static void updateShownDealer() {
        String text = "       Austeiler: ";
        switch (dealerIndex) {
        case 0:
            text += Players.PLAYER_1.toString();
            break;
        case 1:
            text += Players.PLAYER_2.toString();
            break;
        case 2:
            text += Players.PLAYER_3.toString();
            break;
        case 3:
            text += Players.PLAYER_4.toString();
            break;
        }
        dealer.setText(text);
    }
}