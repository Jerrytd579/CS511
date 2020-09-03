-module(exercise).
%% -export([fact/1]).
-compile(export_all).
-author("Jerry").


%% fact(N) computes N!
%% Precondition: N is a number
fact(0) ->
    1;
fact(N) when N>0 and is_number(N)->
    N*fact(N-1);
fact(_) ->
    fact_invalid_arg.

% sum(N) adds up all the numbers from 0 to N
% Eg. sum(1) => 55
sum(0) ->
    0;
sum(N) when N>0 and is_number(N) ->
    N+sum(N-1);
sum(_) ->
    sum_invalid_arg.


%% Binary trees

%% Empty node: {empty}
%% None-empty node: {node,i,left_tree,right_tree}

leaf(N)->
    {node,N,{empty},{empty}}.

t1() ->
    {node,7,leaf(5),{node,12,leaf(10),leaf(14)}}.

size_t({empty})->
    0;
size_t({node,_I,LT,RT})->
    1+size_t(LT)+size_t(RT).

%% sum_t: adds up all the numbers in a tree of numbers
sum_t({empty})->
    0;
sum_t({node,_I,LT,RT})->
    _I + sum_t(LT)+sum_t(RT).
%% mirror_t: computes the mirror image of a tree
mirror_t({empty})->
    {empty};
mirror_t({node,_I,LT,RT})->
    {node,_I,mirror_t(RT),mirror_t(LT)}.
%% bump_t: returns a new tree of numbers where each number has been incremented by 1
bump_t({empty})->
    {empty};
bump_t({node,_I,LT,RT})->
    {node,_I+1,bump_t(LT),bump_t(RT)}.

%% Pre order traversal of a binary tree
pre({empty})->
    [];
pre({node,I,LT,RT})->
    [I|pre(LT)++pre(RT)].

%% Example of higher-order function (map takes another function as an argument).
map_t(_F,{empty})->
    {empty};
map_t(F,{node,I,LT,RT})->
    {node,F(I),map_t(F,LT),map_t(F,RT)}.

fold_t(_F,A,{empty})->
    A;
fold_t(F,A,{node, I,LT,RT})->
    F(I,fold_t(F,A,LT),fold_t(F,A,RT)).
