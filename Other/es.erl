-module(es).
-compile(export_all).
-author("E.B").

%% Code that will run in an echo server
%% The server itself will be spawned in the shell as follows
%%
%% Eshell V8.3  (abort with ^G)
%% 1> S=spawn(fun es:echo/0).
%% <0.58.0>
%% 2> S!{self(),"hello"}.
%% {<0.56.0>,"hello"}
%% 3> flush().
%% Shell got {"hello"}
%% ok

echo() ->
    receive 
	{From,Msg} ->
	    From!{Msg},
	    echo();
	stop ->
	    stop
    end.

%% Code that will run in a factorial server
fact(0) ->
    1;
fact(N) when N>0 ->
     N*fact(N-1).

fs() ->
    receive
	{From,Ref,N} ->
	    From!{Ref,fact(N)},
	    fs();
	stop ->
	    stop
end.

	    
