-module(es).
-compile(export_all).

echo()->
    receive %% the echo server receieves...
        {From,Msg}-> %% From -> pid of who sent it, Msg being message itself
            From!{Msg},
            echo();
        stop->
            stop
    end.
