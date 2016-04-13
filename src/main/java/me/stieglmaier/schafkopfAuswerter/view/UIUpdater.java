package me.stieglmaier.schafkopfAuswerter.view;

import javax.swing.JTable;

import me.stieglmaier.schafkopfAuswerter.model.SystemValues.Players;

public class UIUpdater implements Runnable {

  private JTable table;

  public UIUpdater(JTable gameTable) {
    table = gameTable;
  }

  @Override
  public void run() {
    table.updateUI();
    table.getColumnModel().getColumn(4).setHeaderValue(Players.PLAYER_1.toString());
    table.getColumnModel().getColumn(5).setHeaderValue(Players.PLAYER_2.toString());
    table.getColumnModel().getColumn(6).setHeaderValue(Players.PLAYER_3.toString());
    table.getColumnModel().getColumn(7).setHeaderValue(Players.PLAYER_4.toString());
    table.getTableHeader().resizeAndRepaint();
  }
}
