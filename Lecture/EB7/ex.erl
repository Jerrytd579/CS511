-module(ex).
-compile(export_all).
-author("Jerry").

%% mult(x,y) computes x*y
mult(X,Y) when (is_number(X) and is_number(Y))->
    X*Y;
mult(_,_)->
    error_invalid_mult_arg.

%% double(X) computes X*2
double(X) when is_number(X)->
    X*2;
double(_)->
    error_invalid_double_arg.

%% distance((X1,Y1),(X2,Y2)) consumes two tuples representing coords
%% and returns the Euclidean distance between them.
distance({X1,Y1},{X2,Y2}) when is_number(X1) and is_number(Y1) and is_number(X2) and is_number(Y2)->
    math:sqrt(((((X1-X2)*(X1-X2))+((Y1-Y2)*(Y1-Y2)))));
distance({_,_},{_,_})->
    error_invalid_distance_arg.

%% my_and/2
my_and(A,B) when is_boolean(A) and is_boolean(B)->
    if
        A==B->
            true; 
        true->
            false
    end;
my_and(_,_)->
    error_invalid_my_and_arg.

%% my_or/2
my_or(A,B) when is_boolean(A) and is_boolean(B)->
    if
        (A==true) or (B==true)->
            true;
        true->
            false
    end;
my_or(_,_)->
    error_invalid_my_or_arg.

%% my_not/1
my_not(A) when is_boolean(A)->
    if
        A==true->
            false;
        true->
            true
    end;
my_not(_)->
    error_invalid_my_not_arg.

%% fibonacci(x) -> calculates fibonaaci of the nth sequence
fibonacci(0)->
    0;
fibonacci(1)->
    1;
fibonacci(X) when is_number(X)->
    fibonacci(X-1)+fibonacci(X-2);
fibonacci(_)->
    error_invalid_fibonacci_arg.

%% sum/1 -> sums up all the numbers in a list
sum([])->
    0;
sum([H|T]) when is_number(H)->
    H+sum(T);
sum(_)->
    error_invalid_sum_arg.

%% maximum/1 -> computes the maximum of a non-empty list of numbers

maximum([H]) when is_number(H)->
    H;
maximum([H|T]) when is_number(H)->
    maximum(H,T);