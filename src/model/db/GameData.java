package model.db;

import java.util.LinkedList;
import java.util.List;

import de.erichseifert.gral.data.DataTable;
import model.SystemValues.Games;
import model.SystemValues.WIN;


public class GameData {

    // items stored: index player game value valP1 valP2 valP3 valP4 stock
    private List<DataObject> data = new LinkedList<>();
    private DataTable p1 = new DataTable(2, Integer.class);
    private DataTable p2 = new DataTable(2, Integer.class);
    private DataTable p3 = new DataTable(2, Integer.class);
    private DataTable p4 = new DataTable(2, Integer.class);

    public GameData() {
        data.add(new DataObject("/", Games.WEITER, 0, 0, 0, 0, 0, WIN.NOONE));
        p1.add(0, 0);
        p2.add(0, 0);
        p3.add(0, 0);
        p4.add(0, 0);
    }

    public void addData(DataObject obj) {
        p1.add(data.size(), obj.getValP1());
        p2.add(data.size(), obj.getValP2());
        p3.add(data.size(), obj.getValP3());
        p4.add(data.size(), obj.getValP4());
        data.add(obj);
    }

    public DataTable[] getTables() {
        DataTable[] tmp = {p1, p2, p3, p4};
        return tmp;
    }

    public DataObject getLast() {
        return data.get(data.size() -1);
    }

    public DataObject get(int index) {
        if(index >= 0 && index < data.size()) {
            return data.get(index);
        } else {
            return null;
        }
    }

    public int size() {
        return data.size();
    }

}
