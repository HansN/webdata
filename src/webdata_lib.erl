-module(webdata_lib).


date_in_range({undefined,undefined}) -> true;
date_in_range({undefined,To}) -> date() =< To;
date_in_range({From,undefined}) -> From =< date();
date_in_range({From,To}) -> From =< date() andalso date() =< To.

curr_user_has_role(none) -> true;
curr_user_has_role(Role) -> wf:role(Role).
    
