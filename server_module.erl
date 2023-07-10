-module(server_module).
-author("William Englund").
-behaviour(gen_server).
-export([member_handler/1, start_server/0, init/1]).
-export([handle_call/3, handle_cast/2]).
-define(STORAGE, storage).

member_handler(Members) ->
	receive
		{addMember, New_member} ->
			io:fwrite("Member ~p added.~n", [New_member]),
			%member_handler([New_member] ++ Members);
			member_handler(New_member);
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

handle_call({memberId, Name}, From, State) -> % Receive messages that are sent by call() in client
	io:fwrite("~p~n", [Name]),
	whereis(?STORAGE) ! {addMember, From},
	{reply, {confirmation, Name}, State}. % Reply back to client

handle_cast({out_msg, Message, Name}, _State) ->
	whereis(?STORAGE) ! {getMembers, self()},
	receive
		{allMembers, Member_list} ->
			ok
	end,
	io:fwrite("~p~n", [Member_list]),
	gen_server:cast(element(1, Member_list), {in_msg, Message, Name}),
	{noreply, 1}.
