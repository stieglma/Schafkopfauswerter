
import java.awt.BorderLayout;
import java.awt.FlowLayout;

import javax.swing.JCheckBox;
import javax.swing.JPanel;

import model.Schafkopfmodel;
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


    private int DataObject.stock;

    DataObject around(String[] values) : call ( DataObject.new(String[])) && args(values){
        DataObject obj = proceed(values);
        obj.stock = Integer.parseInt(values[9]);
        return obj;
    }
 
    public int DataObject.getStock() {
        return stock;
    }

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

    void around() : call (* Schafkopfmodel.addWeiter()) {
        DataObject obj = gui.model.gameDB.getLast();

        if (!useStock) {
            gui.model.gameDB.addData(obj);
            return;
        }

        int valP1 = obj.getValP1() - rufspiel;
        int valP2 = obj.getValP2() - rufspiel;
        int valP3 = obj.getValP3() - rufspiel;
        int valP4 = obj.getValP4() - rufspiel;

        DataObject newObj = new DataObject("/", "weiter", rufspiel, valP1, valP2, valP3, valP4, WIN.NOONE);
        newObj.stock = gui.model.gameDB.getLast().getStock() + rufspiel*4;
        gui.model.gameDB.addData(newObj);

    }

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

        DataObject newObj = new DataObject(one.toString(), "Rufspiel", price,
                playerVals[0], playerVals[1], playerVals[2], playerVals[3], win);
        newObj.stock = stock;
        gui.model.gameDB.addData(newObj);
    }

    int around() : execution (* SchafkopfTableModel.getColumnCount()) {
        return 9;
    }

    Object around(int rowIndex, int columnIndex)
    : execution (* SchafkopfTableModel.getValueAt(int, int))
    && args(rowIndex, columnIndex) {
        if (columnIndex < 8) {
            return proceed(rowIndex, columnIndex);
        } else {
            return gui.model.gameDB.data.get(gui.model.gameDB.size() - rowIndex - 1).getStock();
        }
    }

    Object around(int index)
    : execution (* SchafkopfTableModel.getColumnName(int))
    && args(index) {
        if (index < 8) {
            return proceed(index);
        } else {
            return "Stock";
        }
    }

    private JCheckBox checkboxStock;

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

    String around() : execution(* ExportActionListener.createHeader()) {
        return proceed() + "<p>Stock: " + (useStock ? "ja" : "nein") + "</p>";
    }

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
