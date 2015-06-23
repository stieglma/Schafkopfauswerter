import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import model.SystemValues;


/**
 * Dummy class such that we can have a joinpoint in another aspect here, too
 */
public class LoadFileListener implements ActionListener {

    @Override
    public void actionPerformed(ActionEvent e) {}

    public static boolean setSystemValues(String firstLine, String secondLine)  {

        if (!firstLine.equals("Preise:")) {
            return false;
        }
;
        if (!secondLine.startsWith("<p>")) {
            return false;
        }

        secondLine = secondLine.replaceAll("</p>", "");
        String[] tmp = secondLine.split("<p>");
        SystemValues.rufspiel = Integer.parseInt(tmp[1].replaceFirst("Rufspiel: ", ""));
        SystemValues.solo = Integer.parseInt(tmp[2].replaceFirst("Solo: ", ""));
        SystemValues.schneider =Integer.parseInt(tmp[3].replaceFirst("Laufende/Schneider: ", ""));
        return true;
    }
}
