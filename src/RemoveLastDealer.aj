
public privileged aspect RemoveLastDealer {

    before() : execution (* RemoveLastGameListener.actionPerformed(*)) {
      Dealer.dealerIndex--;
      if (Dealer.dealerIndex < 0) {
          Dealer.dealerIndex = 3;
      }
      Dealer.updateShownDealer();
    }
}
