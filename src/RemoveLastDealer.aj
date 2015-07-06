
public privileged aspect RemoveLastDealer {

    /** decrease dealer when game is removed */
    before() : execution (* RemoveLastGameListener.actionPerformed(*)) {
      Dealer.dealerIndex--;
      if (Dealer.dealerIndex < 0) {
          Dealer.dealerIndex = 3;
      }
      Dealer.updateShownDealer();
    }
}
