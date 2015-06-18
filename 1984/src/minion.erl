%% @author David
%% @doc @todo Add description to game.


-module(minion).
-behaviour(supervisor).
%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0,init/1]).

%% ====================================================================
%% Internal functions
%% ====================================================================
init(_args)->
	RestartPlan={one_for_all, 0, 30},
	ChildSpec={ch1,{clock,start,[10,{0,255,0}]},permanent,brutal_kill,worker,dynamic},
	ChildSpec2={ch2,{clock,start,[15,{0,255,0}]},permanent,brutal_kill,worker,dynamic},
	Children=[ChildSpec,ChildSpec2],
	{ok,{RestartPlan,Children}}.
start()->
	supervisor:start_link(minion,asd).
	%supervisor:start_child(PID,{ch1,{clock,start,[]},permanent,brutal_kill,worker,[ch1]}).
