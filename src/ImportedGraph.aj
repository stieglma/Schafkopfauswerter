

public aspect ImportedGraph {

    declare precedence : ImportedGraph, Import;

    after() : execution(* LoadFileListener.actionPerformed(*)) {
        Graph.setPlayersGraphs();
        Graph.addGraphPane();
    }
}
