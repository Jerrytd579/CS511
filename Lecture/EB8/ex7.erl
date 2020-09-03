-module(ex7).
-compile(export_all).

start(W,M) ->
    S=spawn(?MODULE, server, [0,0]),
    [spawn(?MODULE, woman, [S]) || _ <- lists:seq(1,W)],
    [spawn(?MODULE, man, [S]) || _ <- lists:seq(1,M)].

woman(S)->
    error(not_implemented).

man(S) ->
    error(not_implemented).

server(Women,Men)->
    error(not_implemented)