-module(client_module).
-author("William Englund").
-export([start_client/1, init/1]).

start_client(Name) ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [{name, Name}], []).

init([{name, Name}]) ->
	io:fwrite("~p~n", [Name]),
	case gen_server:call({global, server_module}, {msg, Name}) of % Send a message to server
		{confirmation, Message} ->
			io:fwrite("~p~n", [Message]); % Print the message that server sends back
		{error, Reason} ->
			io:fwrite("Stopping because of error, reason: ~p~n", [Reason]),
			{stop, normal}
	end.
