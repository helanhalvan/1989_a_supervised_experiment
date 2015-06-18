%% @author David
%% @doc @todo Add description to 'KeyListner'.


-module(keyListner).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/1,register/2]).
start(WX)->
	Pid=spawn_link(fun()->loop([]) end),
	wxEvtHandler:connect(WX, key_down,[{callback, fun(A,B)->buttonDown(A,B,Pid)end}]),
	wxEvtHandler:connect(WX, key_up,[{callback, fun(A,B)->buttonUp(A,B,Pid)end}]),
	Pid.
register(Callback,Handler)->
	Handler ! {register,Callback}.
loop(Listners)->
	receive 
		{wx,_,_,_,{wxKey,key_down,_,_,_ASCII1,_,_,_,_,_,_ASCII2,ASCII3,_}}->
			notify(Listners,ASCII3),
			loop(Listners);
		{register,CallBack}->
			loop([CallBack|Listners]);
		Strange->io:write(Strange)
	end.
notify([],_)->
	ok;
notify([H|T],Value)->
	H(Value),
	notify(T,Value).
%EventRecord::wx(), EventObject::wxObject()
buttonDown(A,_,Pid)->
	Pid ! A.
%EventRecord::wx(), EventObject::wxObject()
buttonUp(A,_,Pid)->
	Pid ! A.
%% ====================================================================
%% Internal functions
%% ====================================================================


