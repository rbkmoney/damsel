-ifndef(dmsl_test_thrift_included__).
-define(dmsl_test_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").



%% struct 'Shout'
-record('Shout', {
    'contents' :: binary()
}).

%% exception 'Failure'
-record('Failure', {
    'reason' :: binary()
}).

-endif.
