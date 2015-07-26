import me.stieglmaier.schafkopfAuswerter.view.GUI;


public privileged aspect ImportDealer {
    /** Import has to happen before ImportDealer */
    declare precedence : ImportDealer, Import;

    private GUI gui;

    /**
     * catch constructor call, so that we have the correct gui, to refer to everywhere
     */
    after() returning(GUI gui): call(GUI.new(*)) {
        this.gui = gui;
    }

    /** reset the dealer index to the appropriate value after importing */
    after() : execution(* LoadFileListener.actionPerformed(*)) {
        Dealer.dealerIndex = (gui.model.gameDB.size()-1) % 4;
        Dealer.updateShownDealer();
    }
}