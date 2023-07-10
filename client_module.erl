-module(client_module).
-author("William Englund").
-behaviour(gen_server).
-export([name_handler/1, start_client/1, init/1, send_message/1]).
-export([handle_cast/2, handle_call/3]).
-define(STORAGE, storage).

name_handler(Name) ->
	receive
		{getName, PID} ->
			PID ! {name, Name},
			name_handler(Name);
		_ ->
			name_handler(Name)
	end.

start_client(Name) ->
	PID = spawn(?MODULE, name_handler, [Name]),
	register(?STORAGE, PID),
	gen_server:start_link({local, ?MODULE}, ?MODULE, [{name, Name}], []).

init([{name, Name}]) -> % Make a synchronous call to server to join the chat
	case gen_server:call({global, server_module}, {memberId, Name}) of % Send a message to server
		{confirmation, Message} ->
			io:fwrite("~p has joined the chat~n", [Message]); % Print the message that server sends back
		{error, Reason} ->
			io:fwrite("Stopping because of error, reason: ~p~n", [Reason])
	end,
	{ok, 1}.

send_message(Message) ->
	whereis(?STORAGE) ! {getName, self()},
	receive
		{name, Name} ->
			ok
	end,
	gen_server:cast({global, server_module}, {out_msg, Message, Name}).

handle_cast({in_msg, Message, Name}, _State) ->
	io:fwrite("~p : ~p~n", [Name, Message]),
	{noreply, 1}.

handle_call(_, _, _) ->
	ok.
