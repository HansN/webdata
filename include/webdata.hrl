
-record(page, {
	  id,		   % key
	  role,		   % required role for viewing user
	  show_between = {undefined,undefined},	 % {FirstDate, LastDate}
	  title = "",
	  changed = [],     % [ {user_id,DateTime} ]  (youngest first, creation last)
	  sub_pages = [],  % {PageId, TitleString}
	  contents = []    % #section{}
	 }).

-record(page_section, {
	  role,		   % required role for viewing user
	  show_between = {undefined,undefined},	 % {FirstDate, LastDate}
	  changed = [],     % [ {user_id,DateTime} ]  (youngest first, creation last)
	  contents = ""
	 }).

-record(user, {
	  id,					% key
	  given_name = "",
	  family_name = "",
	  post_address = "",
	  phone_numbers = [],
	  email_addresses = [],
	  roles = [{hksf,medlem}],
	  property				% property id
	 }).

-record(property, {
	  id,
	  address = ""
	 }).
