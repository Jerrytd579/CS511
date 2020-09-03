-module(ex8).
-compile(export_all).

start(N)->
    S = spawn(fun server/0),
    [spawn(?MODULE,client,[S]) || _ <- list:seq(1,N)].

server()->
    receive
        {From, Ref, start}->
            Servlet = spawn(?MODULE, servlet, [From, rand:uniform(10)]),
            From!{ok,Ref,Servlet},
            server()
    end.

servlet(From,N)->
    receive
        {move,N}->
            From!{gotIt};
        {move,_}->
            From!{tryAgain},
            servlet(From, N)
    end.

client(S)->
    R = make_ref(),
    S!{self(),R,start},
    receive    
        {ok,Servlet}->
            client_loop(S, 0, rand:uniform(10))
    end.

client_loop(S, It, Move)-> %% Guess until correct
    S!{move,Move},
    receive
        {gotIt}->
            io:format("CLient ~p guessed ~w in ~w attempts ~n",[self(),Move, It]);
        {tryAgain}->
            client_loop(S, It+1, rand:uniform(10))
    end.
