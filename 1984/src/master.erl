%% @author David
%% @doc @todo Add description to game.


-module(master).
-behaviour(supervisor).
%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0,init/1]).

%% ====================================================================
%% Internal functions
%% ====================================================================
init(_args)->
	RestartPlan={one_for_one, 30, 10},
	ChildSpec={ch1,{clock,start,[10,{255,0,0}]},permanent,brutal_kill,worker,dynamic},
	ChildSpec2={ch2,{clock,start,[15,{0,0,255}]},permanent,brutal_kill,worker,dynamic},
	ChildSpec3={ch3,{minion,start,[]},permanent,brutal_kill,supervisor,dynamic},
	Children=[ChildSpec,ChildSpec2,ChildSpec3],
	{ok,{RestartPlan,Children}}.
start()->
	{ok,Pid}=supervisor:start_link(master,asd),
	supervisor:start_child(Pid,{ch5,{clock,start,[15,{0,0,0}]},permanent,brutal_kill,worker,dynamic}).
