package me.stieglmaier.schafkopfAuswerter.view;

import javax.swing.table.AbstractTableModel;

import me.stieglmaier.schafkopfAuswerter.model.SystemValues;
import me.stieglmaier.schafkopfAuswerter.model.db.GameData;

public class SchafkopfTableModel extends AbstractTableModel {

    private static final long serialVersionUID = 1L;
    private GameData data;

    public SchafkopfTableModel(GameData data) {
        this.data = data;
    }

    @Override
    public int getRowCount() {
        return data.size();
    }

    @Override
    public int getColumnCount() {
        return 9;
    }

    @Override
    public Object getValueAt(int rowIndex, int columnIndex) {
        if(rowIndex >= data.size()) {
            return null;
        }
        switch(columnIndex) {
        case 0: return data.size() - rowIndex -1;
        case 1: return data.get(data.size() - rowIndex - 1).getPlayer();
        case 2: return data.get(data.size() - rowIndex - 1).getGameKind();
        case 3: return data.get(data.size() - rowIndex - 1).getGameValue();
        case 4: return data.get(data.size() - rowIndex - 1).getValP1();
        case 5: return data.get(data.size() - rowIndex - 1).getValP2();
        case 6: return data.get(data.size() - rowIndex - 1).getValP3();
        case 7: return data.get(data.size() - rowIndex - 1).getValP4();
        case 8: return data.get(data.size() - rowIndex - 1).getGameWon();
        default: return null;
        }
    }

    @Override
    public String getColumnName(int index) {
        switch(index) {
        case 0: return "Anzahl";
        case 1: return "Spieler";
        case 2: return "Spiel";
        case 3: return "Preis";
        case 4: return SystemValues.Players.PLAYER_1.toString();
        case 5: return SystemValues.Players.PLAYER_2.toString();
        case 6: return SystemValues.Players.PLAYER_3.toString();
        case 7: return SystemValues.Players.PLAYER_4.toString();
        case 8: return "Gewonnen";
        default: return null;
        }
    }
}
