
-record(page, {
	  id,		   % key
	  role,		   % required role for viewing user
	  show_between = {undefined,undefined},	 % {FirstDate, LastDate}
	  title = "",
	  created_by,	   % user id
	  created,	   % DateTime
	  last_changed_by, % user id
	  last_changed,	   % DateTime
	  sub_pages = [],  % {PageId, TitleString}
	  contents = []    % #section{}
	  }).

-record(#section, {
	   role,		   % required role for viewing user
	   show_between = {undefined,undefined},	 % {FirstDate, LastDate}
	   created_by,	   % user id
	   created,	   % DateTime
	   last_changed_by, % user id
	   last_changed,	   % DateTime
	   contents = ""
	  }).

-record(user, {
	  id,					% key
	  given_name = "",
	  family_name = "",
	  post_address = ""
	  phone_numbers = [],
	  email_addresses = [],
	  roles = [{hksf,medlem}],
	  fastighet				% id
	 }).

-record(fastighet, {
	  id,					% 'Säby 2:x'
	  address = ""
	 }).
