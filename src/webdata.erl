-module(webdata).

-export([get_title/1,
	 get_changes/1,
	 get_page_curr_user/1,

	 fmt_title/1,
	 fmt_last_changed/1,
	 fmt_date_time/1,
	 fmt_date/1,
	 fmt_time/1,
	 fmt_user/1
	]).

-include_lib("webdata/include/webdata.hrl").

fmt_title(PageId) ->
    get_title(PageId).

fmt_last_changed(PageId) ->
    [{Uid,DateTime}|_] = get_changes(PageId),
    io_lib:format("Senast ändrad ~p av ~p", [fmt_date_time(DateTime),fmt_user(Uid)]).

fmt_date_time({Date,Time}) -> [fmt_date(Date)," ",fmt_time(Time)].

fmt_date({YYYY,M,D}) -> io_lib:format("~w-~.2.0w-~.2.0w",[YYYY,M,D]).
    
fmt_time({H,M,_S}) -> io_lib:format("~.2.0w:~.2.0w",[H,M]).

fmt_user(Uid) -> io_lib:format('~p',[Uid]). % FIXME


get_title(PageId) -> (hd(webdata_db:get_page(PageId)))#page.title.
	    
get_changes(PageId) -> (hd(webdata_db:get_page(PageId)))#page.changed.

%% -> not_found | not_authorized | no_user | #page{}

get_page_curr_user(PageId) ->
    case webdata_db:get_page(PageId) of
	[P] ->
	    case may_show(P) of
		true  -> filter_page_contents(P);
		Other -> Other
	    end;
	_ ->
	    not_found
    end.
			    
filter_page_contents(P) ->
    P#page{sub_pages = [{SP,Psp#page.title} 
			|| SP <- P#page.sub_pages,
			   Psp <- webdata_db:get_page(SP),
			   may_show(Psp) == true],
	   contents = [C || C <- P#page.contents,
			    may_show(C) == true]
	  }.
			    
%% -> not_found | not_authorized | no_user | true
		    
may_show(P=#page{}) -> may_show(P#page.show_between, P#page.role);
may_show(S=#section{}) -> may_show(S#section.show_between, S#section.role);
may_show([]) -> not_found.

may_show(DateRange, Role) ->
    case webdata_lib:date_in_range(DateRange) of
	true -> webdata_lib:curr_user_has_role(Role);
	false -> false
    end.
