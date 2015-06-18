%% @author David
%% @doc @todo Add description to matrixUI.


-module(matrixUI).

%% ====================================================================
%% API functions
%% ====================================================================

%TODO something that makes all of it one window? maybe some of it one window
-export([start/1,setSquare/3]).
%takes {Hight,With} as an argument, 
%returns {Self,Listner}
start(A)->
	Maker=self(),
	Ref=make_ref(),
	Pid2=spawn_link(fun()->constructor(A,Maker,Ref) end),
	receive
		{Ref,Pid}->{Pid2,Pid}
	end.
setSquare(Pos,{Dude,Color},Pid)->
	TextDude=io_lib:format("~p", [Dude]),
	Pid ! {Pos,TextDude,Color}.
	
%% ====================================================================
%% Internal functions
%% ====================================================================
constructor({Hight,Length},ASD,Ref)->
	Server = wx:new(),
  	Frame = wxFrame:new(Server, -1, "matrixUI", [{size,{500, 500}}]),
	ASD ! {Ref,keyListner:start(Frame)},
	Grid =wxGrid:new(Frame,Hight,Length),
	wxGrid:createGrid(Grid, Hight, Length),
	wxGrid:enableEditing(Grid,false),
	wxFrame:show(Frame),
	loop(Grid).
loop(Grid)->
	receive 
		{{X,Y},Text,{_,_,_}=Color} when erlang:is_integer(X),erlang:is_integer(Y),X>0,Y>0->
			wxGrid:setCellValue(Grid, X-1,Y-1,  Text),
			wxGrid:setCellBackgroundColour(Grid,X-1,Y-1,Color),
			ok;
		Strange->io:write({matrixUI_got_weirdness,Strange})
	end,
	loop(Grid).

