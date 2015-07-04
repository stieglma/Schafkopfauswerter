import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;


/**
 * Dummy class such that we can have a joinpoint in another aspect here, too
 */
public class RemoveLastGameListener implements ActionListener {

    /** filled with pointcut from RemoveLastGame.aj*/
    @Override
    public void actionPerformed(ActionEvent e) {}
}
