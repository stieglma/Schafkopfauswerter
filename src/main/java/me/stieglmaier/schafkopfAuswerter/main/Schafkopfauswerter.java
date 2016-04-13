package me.stieglmaier.schafkopfAuswerter.main;

import java.awt.EventQueue;

import javax.swing.UIManager;

import me.stieglmaier.schafkopfAuswerter.model.Schafkopfmodel;
import me.stieglmaier.schafkopfAuswerter.view.GUI;

public class Schafkopfauswerter {

  /**
   * @param args
   */
  public static void main(String[] args) {
    EventQueue.invokeLater(
        new Runnable() {
          public void run() {
            try {
              try {
                for (UIManager.LookAndFeelInfo info : UIManager.getInstalledLookAndFeels()) {
                  if ("Nimbus".equals(info.getName())) {
                    UIManager.setLookAndFeel(info.getClassName());
                    break;
                  }
                }
              } catch (Exception e) {
                UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
              }

              GUI frame = new GUI(new Schafkopfmodel());
              frame.setVisible(true);
            } catch (Exception e) {
              e.printStackTrace();
            }
          }
        });
  }
}
