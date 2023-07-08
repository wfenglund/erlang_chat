-module(client_module).
-author("William Englund").
-behaviour(gen_server).
-export([start_client/1, init/1, send_message/2]).

start_client(Name) ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [{name, Name}], []).

init([{name, Name}]) -> % Make a synchronous call to server to join the chat
	case gen_server:call({global, server_module}, {memberId, Name}) of % Send a message to server
		{confirmation, Message} ->
			io:fwrite("~p has joined the chat~n", [Message]); % Print the message that server sends back
		{error, Reason} ->
			io:fwrite("Stopping because of error, reason: ~p~n", [Reason]),
			{stop, normal}
	end.

send_message(Message, Name) ->
	gen_server:cast({global, server_module}, {out_msg, Message, Name}).

handle_cast({in_msg, Message, Name}, _State) ->
	io:fwrite("~p : ~p~n", [Name, Message]).
