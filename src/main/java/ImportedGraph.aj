

public aspect ImportedGraph {

    /** Import has to happen before ImportedGraph can take the correct values */
    declare precedence : ImportedGraph, Import;

    after() : execution(* LoadFileListener.actionPerformed(*)) {
        Graph.setPlayersGraphs();
        Graph.addGraphPane();
    }
}
