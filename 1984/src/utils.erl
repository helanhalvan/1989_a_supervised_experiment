%% @author David
%% @doc @todo Add description to util.


-module(utils).

%% ====================================================================
%% API functions
%% ====================================================================
-export([getPid/2,makeKeyCallback/2,pacemaker/2,stop/1,makeCaller/0,waitForAck/1,ack/1,sendMsg/2]).
%makes Caller object
makeCaller()->
	A=self(),
	B=make_ref(),
	{A,B}.
%waits for reply, returns the reply
waitForAck({_,Ref})->
	receive
		Ref -> ok;
		{Ref,A}-> A
	end.
%sends ack using Caller Obj
ack({Caller, Ref})->
	Caller ! Ref.
%sends Msg, using Caller Obj
sendMsg({Caller, Ref},Msg)->
	Caller ! {Ref,Msg}.

%gets if it exists, otherwise creates one and gives
getPid(Name,Start)->
	case erlang:whereis(Name) of 
		Pid when is_pid(Pid) ->Pid;
		_ ->Pid=spawn(Start),
			erlang:register(Name, Pid),
			Pid
	end.
%Keybinds is a list
%format [{Key,Msg},{Key,Msg}]
makeKeyCallback(Pid,KeyBinds)->
	fun(A)->call(A,Pid,KeyBinds)end.

call(_,_,[])->
	ok;
call(A,Pid,[{Msg,A}|_])->
	Pid ! Msg;
call(A,Pid,[_|T])->
	call(A,Pid,T).

%Callback will be called 
%with an interval of Time seconds
%===============================
%if Callback is not a function 
%Callback will be sent as a msg
%to current thread
%===============================
%stopped with utils:stop
pacemaker(Callback, Time) when is_function(Callback, 0)->
	T=trunc(Time*1000),
	spawn_link(fun()->paceLoop(Callback,T) end);
pacemaker(Msg,Time) ->
	A=self(),
	B=fun()->A ! Msg end,
	pacemaker(B,Time).

stop(Pid)->
	Pid ! die.

%% ====================================================================
%% Internal functions
%% ====================================================================
paceLoop(Callback,Time)->
	timer:sleep(Time),
	Callback(),
	receive
		die -> ok
		after 0 ->paceLoop(Callback,Time)
	end.

