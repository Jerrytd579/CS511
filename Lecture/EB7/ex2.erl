-module(ex2).
-compile(export_all).

server()->
    receive
        {start, PID} ->
            S = spawn(?MODULE, serverconcat, [""]),
            PID!{S},
            server()
end.

serverconcat(String)->
    receive
        {add, S}->
            serverconcat(String ++ S);
        {done, PID}->
            PID!{String}
end.