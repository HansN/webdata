-module(webdata_db).

-export([get_page/1]).

-include("webdata.hrl").

get_page(PageId) -> 
    case mnesia:read(page, PageId) of
	[P] -> P;
	_ -> not_found
    end.
	    




	    
