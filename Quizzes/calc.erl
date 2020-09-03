-module(calc).
-compile(export_all).


%%% Stub provided by E.B.

%%% 3+(8/2)
%%% {add,{const,3},{divi,{const,8},{const,2}}}

example() ->
    {add,{const,3},{divi,{const,8},{const,2}}}.

%%% calc(example(),[])  => {val,7}
%%%

example2() ->   
    {add,{const,3},{var,"x"}}.

example_env() ->  %% List of "pairs"
    [{"x",7},{"y",4}].

%%% 3+x
%%% {add,{const,3},{var,"x"}}
%%% 
%%% calc(example2(),example_env()) => {val, 10}
%%%
lookup([],_Key) ->  %% Helper function to lookup a key/value pair in an Env
    error;
lookup([{K,V}|_T],Key) when K==Key ->
    V;
lookup([{_,_}|T],Key) ->
    lookup(T,Key).


calc({const,N},_Env) ->  %% Base case
    {val,N};
calc({var,Var},Env) ->  %% Base case
    {val,lookup(Env,Var)};   
calc({add,E1,E2},Env) ->
    {val,N1} = calc(E1,Env),
    {val,N2} = calc(E2,Env),
    {val,N1+N2};
calc({mul,E1,E2},Env) ->
    {val,N1} = calc(E1,Env),
    {val,N2} = calc(E2,Env),
    {val,N1*N2};
calc({divi,E1,E2},Env) ->
    {val,N1} = calc(E1,Env),
    {val,N2} = calc(E2,Env),
    {val,N1 div N2};
calc({sub,E1,E2},Env) ->
    {val,N1} = calc(E1,Env),
    {val,N2} = calc(E2,Env),
    {val,N1-N2}.
    
