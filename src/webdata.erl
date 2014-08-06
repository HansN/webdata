-module(webdata).

-include("webdate.hrl").

%% -> not_found | not_authorized | no_user | #page{}

get_page_curr_user(PageId) ->
    case may_show(P0=webdata_db:get_page(PageId)) of
	true ->  filter_page_contents(hd(P0));
	Other -> Other
    end.
			    
filter_page_contents(P) ->
    P#page{sub_pages = [{SP,(hd(Psp))#page.title} 
			|| SP <- P#page.sub_pages,
			   may_show(Psp=webdata_db:get_page(SP)) == true],
	   contents = [C || C <- P#page.contents,
			    may_show(C) == true]
	  }.
			    
%% -> not_found | not_authorized | no_user | true
		    
may_show([P=#page{}]) -> may_show(P#page.show_between, P#page.role);
may_show(S=#section{}) -> may_show(S#section.show_between, S#section.role);
may_show([]) -> not_found.

may_show(DateRange, Role) ->
    case webdata_lib:date_in_range(DateRange) of
	true -> webdata_lib:curr_user_has_role(Role);
	false -> false
    end.
