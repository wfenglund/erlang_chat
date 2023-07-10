# erlang_chat
Experimenting with building a simple chat client in erlang.

Current usage:
start two terminals and do the following in the first one (chat server):
```bash
$ erl -sname server_session -setcookie chat
```
```erlang
1> c(server_module).
2> server_module:start_server().
```

And do the following in the other terminal (chat client):
```bash
$ erl -sname client_session -setcookie chat
```
```erlang
1> c(client_module).
2> net_adm:ping('server_session@manjw'). % Change manjw to the name of your computer
3> client_module:start_client("William"). % Enter chat with your name
4> client_module:send_message("Hello").
```

The server then receives the message and sends it back to the client where it is printed like this:
```
"William" : "Hello"
```
