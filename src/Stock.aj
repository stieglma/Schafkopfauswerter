
import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.util.Arrays;

import javax.swing.JCheckBox;
import javax.swing.JPanel;

import model.Schafkopfmodel;
import model.SystemValues.Games;
import model.SystemValues.Players;
import model.SystemValues.WIN;
import static model.SystemValues.rufspiel;
import model.db.DataObject;
import view.ConfigPopup;
import view.GUI;
import view.SchafkopfTableModel;
import view.ConfigSaveListener;

public privileged aspect Stock {

    private static GUI gui;
    private boolean useStock = false;

    /**
     * catch constructor call, so that we have the correct gui, to refer to everywhere
     */
    after() returning(GUI gui): call(GUI.new(*)) {
        Stock.gui = gui;
    }


    /** add stock variable to DataObject */
    private int DataObject.stock;

    /** catch constructor call and set stock to appropriate value */
    DataObject around(String[] values) : call ( DataObject.new(String[])) && args(values){
        DataObject obj = proceed(values);
        obj.stock = Integer.parseInt(values[9]);
        return obj;
    }
 
    /** add method to retrieve value of stock */
    public int DataObject.getStock() {
        return stock;
    }

    /** when a new dataobject is created, set to value of last dataobject or 0 */
    DataObject around(String player, String game, int gameVal, int valP1, int valP2, int valP3, int valP4, WIN winner)
            : call (DataObject.new(String, String, int, int, int, int, int, WIN))
            && args (player, game, gameVal, valP1, valP2, valP3, valP4, winner) {
        DataObject obj = proceed(player, game, gameVal, valP1, valP2, valP3, valP4, winner);
        if (gui != null) {
            obj.stock = gui.model.gameDB.getLast().getStock();
        } else {
            obj.stock = 0;
        }
        return obj;
    }

    /** add stock object to asTextArray method of DataObject */
    String[] around(int index) : call (* DataObject.asTextArray(int)) && args(index) && target(DataObject){
        String[] obj = proceed(index);
        String[] retStr = Arrays.copyOf(obj, obj.length+1);
        retStr[obj.length] = Integer.toString(((DataObject)thisJoinPoint.getTarget()).stock);
        return retStr;
    }

    /** addWeiter has to be changed if stock is used, such that the stock is increased then */
    void around() : call (* Schafkopfmodel.addWeiter()) {
        DataObject obj = gui.model.gameDB.getLast().copyOf();
        obj.player = "/";
        obj.game = Games.WEITER;
        obj.won = WIN.NOONE;
        obj.gameVal = 0;

        if (useStock) {
            obj.valP1 = obj.valP1 - rufspiel;
            obj.valP2 = obj.valP2 - rufspiel;
            obj.valP3 = obj.valP3 - rufspiel;
            obj.valP4 = obj.valP4 - rufspiel;
            obj.stock = gui.model.gameDB.getLast().getStock() + rufspiel*4;
            obj.gameVal = rufspiel;
        }

        gui.model.gameDB.addData(obj);

    }

    /** For Rufspiele we have to adjust the stock (if won, add stock to players,
     *  if lost double up stock */
    void around(int price, Players one, Players two, boolean won)
            : call (* Schafkopfmodel.addRufspielHelp(int, Players, Players, boolean))
            && args(price, one, two, won) {
        DataObject obj = gui.model.gameDB.getLast();
        int[] playerVals = {obj.getValP1(), obj.getValP2(), obj.getValP3(), obj.getValP4()};
        int stock = obj.getStock();

        if (!won) {
            price *= -1;
            if (useStock) {
                stock *= -1;
            }
        }

        for (int i = 0; i < playerVals.length; i++) {
            if (i == one.getNumber() || i == two.getNumber()) {
                playerVals[i] += price + (useStock ? (stock / 2) : 0);
            } else {
                playerVals[i] -= price;
            }
        }
        
        if (!won && useStock) {
            stock *= -2;
        } else if (useStock){
            stock = 0;
        }

        WIN win = won ? WIN.PLAYER : WIN.ENEMY;

        DataObject newObj = new DataObject(one.toString(), Games.RUFSPIEL, price,
                playerVals[0], playerVals[1], playerVals[2], playerVals[3], win);
        newObj.stock = stock;
        gui.model.gameDB.addData(newObj);
    }

    /** with stock we have one more columnn */
    int around() : execution (* SchafkopfTableModel.getColumnCount()) {
        return proceed() + 1;
    }

    /** retrieve stock value when needed */
    Object around(int rowIndex, int columnIndex)
    : execution (* SchafkopfTableModel.getValueAt(int, int))
    && args(rowIndex, columnIndex) {
        if (columnIndex < 9) {
            return proceed(rowIndex, columnIndex);
        } else {
            return gui.model.gameDB.data.get(gui.model.gameDB.size() - rowIndex - 1).getStock();
        }
    }

    /** Table header for stock */
    Object around(int index)
    : execution (* SchafkopfTableModel.getColumnName(int))
    && args(index) {
        if (index < 9) {
            return proceed(index);
        } else {
            return "Stock";
        }
    }

    private JCheckBox checkboxStock;

    /** Add stock checkbox to config screen*/
    after() returning(JPanel pane): execution (* ConfigPopup.createOptionsPane()) {
        JPanel panelStock = new JPanel();
        panelStock.setLayout(new FlowLayout(FlowLayout.CENTER, 5, 5));

        checkboxStock = new JCheckBox("Stock");
        panelStock.add(checkboxStock);

        pane.add(panelStock, BorderLayout.NORTH);
    }

    after() : execution(* ConfigSaveListener.actionPerformed(*)) {
        useStock = checkboxStock.isSelected();
    }

    /** create html header with stock */
    String around() : execution(* ExportActionListener.createHeader()) {
        return proceed() + "<p>Stock: " + (useStock ? "ja" : "nein") + "</p>";
    }

    /** read stock value for Import */
    boolean around(String firstLine, String secondLine)
      : execution(* LoadFileListener.setSystemValues(String, String))
      && args(firstLine, secondLine) {

        if (proceed(firstLine, secondLine)) {
            if (secondLine.contains("Stock")) {
                useStock = secondLine.replaceAll("</p>", "").split("<p>")[3].replaceFirst("Stock: ", "").equals("ja");
                return true;
            }
        } 
        return false;
    }
}
