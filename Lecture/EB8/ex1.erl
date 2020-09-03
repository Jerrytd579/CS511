-module(ex1).
-compile(export_all).

start()->
    C = spawn(?MODULE, counter_server, [0]),
    spawn(?MODULE, turnstile, [C,50]),
    spawn(?MODULE,turnstile,[C,50]),
    C!{print_counter}. %% should print 100

counter_server(State)-> %% counter server
    receive
        {bump}->
            counter_server(State+1); %% increments counter value
        {print_counter}-> %% prints value of counter
            io:format("Current value ~p~n",[State]),
            counter_server(State)
    end.

turnstile(C,N) when N>0-> %% a turnstile. c is the counter server and n is current iteration
    C!{bump},
    turnstile(C,N-1);
turnstile(_C,0)->
    ok.
