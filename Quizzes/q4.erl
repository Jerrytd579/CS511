-module(q4).
-compile(export_all).

%% Andrew Chuah, Jerry Cheng
%% I pledge my honor that I have abided by the Stevens Honor System.

example() ->
    {add,{const,3},{divi,{const,8},{const,2}}}.
example_d() ->
    [{"x",7},{"y",4}].

lookup([],_Key)->
    error;
lookup([{K,V}|T}],Key) when K==Key->
    V;
lookup([{K,V}|T],Key)->
    lookup(T,Key).

calc({const,N}, Env) ->
    {val,N};
calc({var,Var}, Env) ->
    {val, lookup(Env,Var)};
calc({add,E1,E2}, Env) ->
    {val,N1}=calc(E1,Env),
    {val,N2}=calc(E2,Env),
    {val, N1+N2};
calc({sub,E1,E2}, Env) ->
    {val,N1}=calc(E1,Env),
    {val,N2}=calc(E2,Env),
    {val, N1-N2};
calc({mul,E1,E2}, Env) ->
    {val,N1}=calc(E1,Env),
    {val,N2}=calc(E2,Env),
    {val, N1*N2};
calc({divi,E1,E2}, Env) ->
    {val,N1}=calc(E1,Env),
    {val,N2}=calc(E2,Env),
    {val, N1/N2}.