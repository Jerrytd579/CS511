-module(server).

-export([start_server/0]).

-include_lib("./defs.hrl").

-spec start_server() -> _.
-spec loop(_State) -> _.
-spec do_join(_ChatName, _ClientPID, _Ref, _State) -> _.
-spec do_leave(_ChatName, _ClientPID, _Ref, _State) -> _.
-spec do_new_nick(_State, _Ref, _ClientPID, _NewNick) -> _.
-spec do_client_quit(_State, _Ref, _ClientPID) -> _NewState.

start_server() ->
    catch(unregister(server)),
    register(server, self()),
    case whereis(testsuite) of
	undefined -> ok;
	TestSuitePID -> TestSuitePID!{server_up, self()}
    end,
    loop(
      #serv_st{
	 nicks = maps:new(), %% nickname map. client_pid => "nickname"
	 registrations = maps:new(), %% registration map. "chat_name" => [client_pids]
	 chatrooms = maps:new() %% chatroom map. "chat_name" => chat_pid
	}
     ).

loop(State) ->
    receive 
	%% initial connection
	{ClientPID, connect, ClientNick} ->
	    NewState =
		#serv_st{
		   nicks = maps:put(ClientPID, ClientNick, State#serv_st.nicks),
		   registrations = State#serv_st.registrations,
		   chatrooms = State#serv_st.chatrooms
		  },
	    loop(NewState);
	%% client requests to join a chat
	{ClientPID, Ref, join, ChatName} ->
	    NewState = do_join(ChatName, ClientPID, Ref, State),
	    loop(NewState);
	%% client requests to join a chat
	{ClientPID, Ref, leave, ChatName} ->
	    NewState = do_leave(ChatName, ClientPID, Ref, State),
	    loop(NewState);
	%% client requests to register a new nickname
	{ClientPID, Ref, nick, NewNick} ->
	    NewState = do_new_nick(State, Ref, ClientPID, NewNick),
	    loop(NewState);
	%% client requests to quit
	{ClientPID, Ref, quit} ->
	    NewState = do_client_quit(State, Ref, ClientPID),
	    loop(NewState);
	{TEST_PID, get_state} ->
	    TEST_PID!{get_state, State},
	    loop(State)
    end.

%% executes join protocol from server perspective
do_join(ChatName, ClientPID, Ref, State) ->
    RPID = case maps:find(ChatName, State#serv_st.chatrooms) of
		{ok,Room} -> Room;
		_ -> spawn(chatroom, start_chatroom, [ChatName])
	end,
	ClientNick = maps:get(ClientPID, State#serv_st.nicks),
	RPID!{self(),Ref,register,ClientPID,ClientNick},
	Registered = case maps:find(ChatName, State#serv_st.registrations) of
		{ok,R} -> R;
		_ -> []
	end,
	State#serv_st{
		nicks = State#serv_st.nicks,
		registrations = maps:put(ChatName, Registered ++ [ClientPID], State#serv_st.registrations),
		chatrooms = maps:put(ChatName, RPID, State#serv_st.chatrooms)
	}.

%% executes leave protocol from server perspective
do_leave(ChatName, ClientPID, Ref, State) ->
    RPID = case maps:find(ChatName, State#serv_st.chatrooms) of
		{ok,Room} -> Room
	end,
	RPID!{self(),Ref,unregister,ClientPID},
	ClientPID!{self(),Ref,ack_leave},
	Registered = case maps:find(ChatName, State#serv_st.registrations) of
		{ok,R} -> lists:delete(ClientPID, R)
	end,
	State#serv_st{
		nicks = State#serv_st.nicks,
		registrations = maps:put(ChatName, Registered, State#serv_st.registrations),
		chatrooms = State#serv_st.chatrooms
	}.

%% executes new nickname protocol from server perspective
do_new_nick(State, Ref, ClientPID, NewNick) ->
    case lists:member(NewNick, maps:values(State#serv_st.nicks)) of
		true -> 
			ClientPID!{self(),Ref,err_nick_used},
			State;
		false ->
			Rooms = maps:filter(fun(_,Clients) -> lists:member(ClientPID, Clients) end, State#serv_st.registrations),
			lists:foreach(fun(C) -> ChatroomPID = maps:get(C, State#serv_st.chatrooms),
				ChatroomPID!{self(),Ref,update_nick,ClientPID,NewNick}
			end, maps:keys(Rooms)),
			ClientPID!{self(),Ref,ok_nick},
			State#serv_st{
				nicks = maps:put(ClientPID, NewNick, State#serv_st.nicks),
				registrations = State#serv_st.registrations,
				chatrooms = State#serv_st.chatrooms
			}
	end.

%% executes client quit protocol from server perspective
do_client_quit(State, Ref, ClientPID) ->
    NewNickList = maps:remove(ClientPID, State#serv_st.nicks),
	Rooms = maps:filter(fun(_,Clients) -> lists:member(ClientPID, Clients) end, State#serv_st.registrations),
	lists:foreach(fun(C) -> ChatroomPID = maps:get(C, State#serv_st.chatrooms),
		ChatroomPID!{self(),Ref,unregister,ClientPID}
	end, maps:keys(Rooms)),
	ClientPID!{self(),Ref,ack_quit},
	State#serv_st{
		nicks = NewNickList,
		registrations = maps:map(fun(_,V) -> lists:delete(ClientPID,V) end, State#serv_st.registrations),
		chatrooms = State#serv_st.chatrooms
	}.