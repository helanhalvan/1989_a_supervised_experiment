%% @author David
%% @doc @todo Add description to worker.


-module(clock).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/2]).

start(X,Color)->
	{UI,_}=matrixUI:start({1,1}),
	Fun=fun()-> loop(UI,X,Color) end,
	Pid=spawn_link(Fun),
	{ok,Pid}.
	

%% ====================================================================
%% Internal functions
%% ====================================================================

loop(UI,X,Color)->
	_=1/X, %cause regular crashes
	matrixUI:setSquare({1,1}, { {X},Color}, UI),
	timer:sleep(1000),
	loop(UI,X-1,Color).

