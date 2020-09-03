-module(ex).
%% -export([fact/1]).
-compile(export_all).   % exports all functions
-author("E.B").
-record(person,{name,age}).
-record(student,{name,cwid}).

%% fact(N) computes N!
%% Precondition: N is a number
fact(0) ->
    1;
fact(N) when N>0 ->
    N*fact(N-1);
fact(_) ->
    fact_negative_arg.

%% sum(N) adds up all the numbers from 0 to N
%% Eg. sum(10) => 55
sum(0) ->
    0;
sum(N) when N>0 and (is_number(N))->
    N+sum(N-1);
sum(_) ->
   sum_error.

%% Binary trees

%% Empty node: {empty}
%% None-empty node: {node,i,left_tree,right_tree}

leaf(N) ->
    {node,N,{empty},{empty}}.

t1() ->
    {node,7,leaf(5),{node,12,leaf(10),leaf(14)}}.

size_t({empty}) ->
    0;
size_t({node,_I,Lt,Rt}) ->
    1+size_t(Lt)+size_t(Rt).

%% sum_t: adds up all the numbers in a tree of numbers
%% Eg. sum_t(t1()) => 48

sum_t({empty}) ->
    0;
sum_t({node,I,LT,RT}) ->
    I + sum_t(LT) + sum_t(RT).

%% mirror_t: computes the mirror image of a tree
%% Eg. mirror_t(t1()) => 
%%     {node,7,
%%        {node,12,{node,14,empty,empty},{node,10,empty,empty}},
%%        {node,5,empty,empty}}.

mirror_t({empty}) ->
    {empty};
mirror_t({node,I,LT,RT}) ->
    {node,I,mirror_t(RT),mirror_t(LT)}.

%% bump_t: returns a new tree of numbers where each number has been incremented by one
%% Eg. bump_t(t1()) =>
%%  {node,8,
%%       {node,6,{empty},{empty}},
%%       {node,13,
%%          {node,11,{empty},{empty}},
%%          {node,15,{empty},{empty}}}}

bump_t({empty}) ->
    {empty};
bump_t({node,I,LT,RT}) ->
    {node,I+1,bump_t(LT),bump_t(RT)}.

%% Preorder traversal of a binary tree
pre({empty}) ->
    [];
pre({node,I,LT,RT}) ->
     [I|pre(LT)++pre(RT)].

%% Example of higher-order function (map takes another function as an argument).

map_t(_F,{empty}) ->
    {empty};
map_t(F,{node,I,LT,RT}) ->
    {node,F(I),map_t(F,LT),map_t(F,RT)}.


map_t2(_F,{empty}) ->
    {empty};
map_t2(F,{node,I,LT,RT}) ->
    L=map_t2(F,LT),
    R=map_t2(F,RT),
    {node,F(I),L,R}.

fold_t(_F,A,{empty}) ->
    A;
fold_t(F,A,{node,I,LT,RT}) ->
    F(I,fold_t(F,A,LT),fold_t(F,A,RT)).


p1() ->
    #person{name="Tom",age=20}.

is_adult(#person{age=Age}) when Age>=21 ->
    true;
is_adult(_) ->
    false.

is_adult2(P) when P#person.age>=21 ->
    true;
is_adult2(_) ->
    false.

bday(P) ->
    P#person{age=P#person.age+1}.

mem(_X,[]) ->
    false;
mem(X,[H|T]) ->
    (X==H) or mem(X,T).





