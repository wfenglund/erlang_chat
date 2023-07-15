-module(server_module).
-author("William Englund").
-behaviour(gen_server).
-export([member_handler/1, start_server/0, init/1, broadcast_message/2]).
-export([handle_call/3, handle_cast/2]).
-define(STORAGE, storage).

member_handler(Members) ->
	receive
		{addMember, New_member} ->
			io:fwrite("Member ~p added.~n", [New_member]),
			member_handler([New_member] ++ Members);
		{getMembers, PID} ->
			PID ! {allMembers, Members},
			member_handler(Members);
		_ ->
			member_handler(Members)
	end.

start_server() ->
	PID = spawn(?MODULE, member_handler, [[]]),
	register(?STORAGE, PID),
	gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

init([]) ->
	{ok, 1}.

broadcast_message(Message, From) ->
	whereis(?STORAGE) ! {getMembers, self()},
	receive
		{allMembers, Member_list} ->
			ok
	end,
	io:fwrite("Current members: ~p~n", [Member_list]),
	lists:foreach(fun(X) -> gen_server:cast(X, {in_msg, Message, From}) end, Member_list).

handle_call({memberId, Name}, From, State) -> % Receive messages from call() in client
	io:fwrite("~p~n", [Name]),
	{Address, _} = From,
	whereis(?STORAGE) ! {addMember, Address},
	Message = Name ++ " has joined the chat.",
	broadcast_message(Message, "SERVER"), % Notify all members that member has joined
	{reply, {confirmation}, State}. % Reply with confirmation to client

handle_cast({out_msg, Message, Name}, _State) -> % Receive messages from cast() in client
	broadcast_message(Message, Name), % Send message to all members of the chat
	{noreply, 1}.
