import javax.swing.JMenu;

import model.SystemValues.Players;


public class Dealer {

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
