-module(webdata).

-export([get_title/1,
	 get_changes/1,
	 page_exists_curr_user/1,
	 get_page_curr_user/1,

	 get_user/1,
	 get_user_login/2,
	 logout/0,

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

fmt_last_changed([{Uid,DateTime}|_]) ->
    io_lib:format("Senast ändrad ~s av ~s", [fmt_date_time(DateTime),fmt_user(Uid)]).

fmt_date_time({Date,Time}) -> [fmt_date(Date)," ",fmt_time(Time)].

fmt_date({YYYY,M,D}) -> io_lib:format("~w-~.2.0w-~.2.0w",[YYYY,M,D]).
    
fmt_time({H,M,_S}) -> io_lib:format("~.2.0w:~.2.0w",[H,M]).

fmt_user(#user{given_name=G, family_name=F}) -> [G," ",F];
fmt_user(undefined) -> "??";
fmt_user(not_found) -> "???";
fmt_user(Uid) -> fmt_user(webdata:get_user(Uid)).


get_title(PageId) -> (webdata_db:get_page(PageId))#page.title.
	    
get_changes(PageId) -> (webdata_db:get_page(PageId))#page.changed.

page_exists_curr_user(PageId) ->
    case webdata_db:get_page(PageId) of
        P=#page{} -> case may_show(P) of
			 true -> true;
			 false -> not_authorized
		     end;
        _ -> not_found
    end.

%% -> not_found | not_authorized | no_user | #page{}

get_page_curr_user(PageId) ->
    case webdata_db:get_page(PageId) of
	P=#page{} ->
	    case may_show(P) of
		true  -> filter_page_contents(P);
		Other -> Other
	    end;
	_ ->
	    not_found
    end.
			    
get_user(UserId) ->
    webdata_db:get_user(UserId).

get_user_login(UserId, Pwd) -> % FIXME: Injection possible!!
    case get_user(UserId) of
	U=#user{} ->
	    wf:user(U),
	    wf:clear_roles(),
	    [wf:role(Role,true) || Role <- U#user.roles],
	    ok;
	R ->
	    R
    end.
	    
logout() ->
    wf:clear_roles(),
    wf:clear_user().

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
may_show(S=#page_section{}) -> may_show(S#page_section.show_between, S#page_section.role);
may_show([]) -> not_found.

may_show(DateRange, Role) ->
    case webdata_lib:date_in_range(DateRange) of
	true -> webdata_lib:curr_user_has_role(Role);
	false -> false
    end.

