-module(ex3).
-compile(export_all).

server(Count)->
    receive
        {counter}->
            io:format("Recieved 'continue' ~wtimes~n",[Count]),
            server(0);
        {continue}->
            server(Count+1)
end.