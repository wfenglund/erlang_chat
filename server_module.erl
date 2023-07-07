-module(server_module).
-author("William Englund").
-behaviour(gen_server).
-export([start_server/0, init/1]).
-export([handle_call/3]).

start_server() ->
	gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

init([]) ->
	{ok, 1}.

handle_call({msg, Message}, _From, State) -> % Receive messages that are sent by call() in client
	io:fwrite("~p~n", [Message]),
	{reply, {confirmation, "Message received"}, State}. % Reply back to client
