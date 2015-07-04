import view.GUI;


public privileged aspect RemoveLastDealer {

    private GUI gui;

    /**
     * catch constructor call, so that we have the correct gui, to refer to everywhere
     */
    after() returning(GUI gui): call(GUI.new(*)) {
        this.gui = gui;
    }

    before() : execution (* RemoveLastGameListener.actionPerformed(*)) {
        if (gui.model.gameDB.size() != 1) {
          Dealer.dealerIndex--;
          if (Dealer.dealerIndex < 0) {
              Dealer.dealerIndex = 3;
          }
          Dealer.updateShownDealer();
        }
    }
}
