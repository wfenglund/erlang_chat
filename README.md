# erlang_chat
Experimenting with building a simple chat client in erlang.

Current usage (example):
Start three terminals and navigate to the folder containing the erlang scripts and do the following in the first one (chat server):
```bash
$ erl -sname server_session -setcookie chat
```
```erlang
1> c(server_module).
2> server_module:start_server().
```

And in the second terminal (chat client 1):
```bash
$ erl -sname client_session1 -setcookie chat
```
```erlang
1> c(client_module).
2> net_adm:ping('server_session@manjw'). % Change manjw to the name of your computer
3> client_module:start_client("William"). % Enter chat with your name
```

And and in the third terminal (chat client 2):
```bash
$ erl -sname client_session2 -setcookie chat
```
```erlang
2> net_adm:ping('server_session@manjw'). % Change manjw to the name of your computer
3> client_module:start_client("Elias"). % Enter chat with your name
4> client_module:send_message("Hello").
```

The output will then be the following in chat client 1:
```
Welcome to the chat "William".
"SERVER" : "William has joined the chat."
"SERVER" : "Elias has joined the chat."
"Elias" : "Hello" 
```
