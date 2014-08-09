-module(webdata_db).

-define(DB, filedb).

-export([get_page/1]).

-include("webdata.hrl").

get_page(PageId) -> 
    case ?DB:read(page, PageId) of
	[P] -> P;
	_ -> not_found
    end.
	    




	    
