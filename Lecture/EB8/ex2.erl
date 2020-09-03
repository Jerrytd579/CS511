-module(ex2).
-compile(export_all).

start()->
    S = spawn(?MODULE,server,[]),
    spawn(?MODULE,client,[S]).

client(S)->
    S!{start,self()},
    S!{add,"h",self()},
    S!{add,"e",self()},
    S!{add,"l",self()},
    S!{add,"l",self()},
    S!{add,"o",self()},
    S!{done, self()},
    receive
        {S, Str}->
            Str
    end.    


server()-> %% process a start message
    receive
        {start,From}->
            server_loop(From,"")
    end.


server_loop(Client,String) -> %% process all other messages, serves client Client
    receive
        {add, Str, Client}->
           server_loop(Client,String++Str);
        {done, Client}->
            Client!{self(),String},
            server()
    end.

    