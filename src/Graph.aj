import java.awt.Color;

import de.erichseifert.gral.data.DataSeries;
import de.erichseifert.gral.data.DataTable;
import de.erichseifert.gral.plots.Plot;
import de.erichseifert.gral.plots.XYPlot;
import de.erichseifert.gral.plots.axes.AxisRenderer;
import de.erichseifert.gral.plots.legends.Legend;
import de.erichseifert.gral.plots.lines.DefaultLineRenderer2D;
import de.erichseifert.gral.plots.lines.LineRenderer;
import de.erichseifert.gral.plots.points.PointRenderer;
import de.erichseifert.gral.ui.InteractivePanel;
import de.erichseifert.gral.util.Orientation;

import static model.SystemValues.Players.*;

import view.GUI;
import view.UIUpdater;

public privileged aspect Graph {

    private static GUI gui;
    private static DataSeries[] playersGraphs = new DataSeries[4];
    private static InteractivePanel tabGraph = null;


    /**
     * catch constructor call, so that we have the correct gui, to refer to everywhere
     */
    after() returning(GUI gui): call(GUI.new(*)) {
        Graph.gui = gui;
        setPlayersGraphs();
        addGraphPane();
    }

    static void addGraphPane() {
        gui.tabbedPane.remove(tabGraph);
        tabGraph = new InteractivePanel(createPlot());
        gui.tabbedPane.add(tabGraph, "Grafik", 2);
    }

    static void setPlayersGraphs() {
        DataTable[] tmp = gui.model.getGameData().getTables();
        playersGraphs[0] = new DataSeries(PLAYER_1.toString(), tmp[0], 0, 1);
        playersGraphs[1] = new DataSeries(PLAYER_2.toString(), tmp[1], 0, 1);
        playersGraphs[2] = new DataSeries(PLAYER_3.toString(), tmp[2], 0, 1);
        playersGraphs[3] = new DataSeries(PLAYER_4.toString(), tmp[3], 0, 1);
    }

    after() : execution(* UIUpdater.run()) {
        playersGraphs[0].setName(PLAYER_1.toString());
        playersGraphs[1].setName(PLAYER_2.toString());
        playersGraphs[2].setName(PLAYER_3.toString());
        playersGraphs[3].setName(PLAYER_4.toString());
    }

    private static XYPlot createPlot() {
        XYPlot plot = new XYPlot(playersGraphs[0], playersGraphs[1], playersGraphs[2], playersGraphs[3]);
        plot.setSetting(Plot.LEGEND, true);
        plot.getLegend().setSetting(Legend.ORIENTATION, Orientation.HORIZONTAL);
        plot.getLegend().setSetting(Legend.ALIGNMENT_Y, 1.0);

        plot.getAxisRenderer(XYPlot.AXIS_X).setSetting(AxisRenderer.LABEL, "Geld");
        plot.getAxisRenderer(XYPlot.AXIS_Y).setSetting(AxisRenderer.LABEL, "Spielanazahl");

        plot.setLineRenderer(playersGraphs[0], new DefaultLineRenderer2D());
        plot.setLineRenderer(playersGraphs[1], new DefaultLineRenderer2D());
        plot.setLineRenderer(playersGraphs[2], new DefaultLineRenderer2D());
        plot.setLineRenderer(playersGraphs[3], new DefaultLineRenderer2D());

        plot.getPointRenderer(playersGraphs[0]).setSetting(PointRenderer.COLOR, Color.blue);
        plot.getLineRenderer(playersGraphs[0]).setSetting(LineRenderer.COLOR, Color.blue);
        plot.getPointRenderer(playersGraphs[1]).setSetting(PointRenderer.COLOR, Color.red);
        plot.getLineRenderer(playersGraphs[1]).setSetting(LineRenderer.COLOR, Color.red);
        plot.getPointRenderer(playersGraphs[2]).setSetting(PointRenderer.COLOR, Color.green);
        plot.getLineRenderer(playersGraphs[2]).setSetting(LineRenderer.COLOR, Color.green);
        plot.getPointRenderer(playersGraphs[3]).setSetting(PointRenderer.COLOR, Color.gray);
        plot.getLineRenderer(playersGraphs[3]).setSetting(LineRenderer.COLOR, Color.gray);

        return plot;
    }
}
