-ifndef(dmsl_base_thrift_included__).
-define(dmsl_base_thrift_included__, yeah).



%% struct 'Content'
-record('Content', {
    'type' :: binary(),
    'data' :: binary()
}).

%% struct 'TimestampInterval'
-record('TimestampInterval', {
    'lower_bound' :: dmsl_base_thrift:'TimestampIntervalBound'() | undefined,
    'upper_bound' :: dmsl_base_thrift:'TimestampIntervalBound'() | undefined
}).

%% struct 'TimestampIntervalBound'
-record('TimestampIntervalBound', {
    'bound_type' :: dmsl_base_thrift:'BoundType'(),
    'bound_time' :: dmsl_base_thrift:'Timestamp'()
}).

%% struct 'Rational'
-record('Rational', {
    'p' :: integer(),
    'q' :: integer()
}).

%% exception 'InvalidRequest'
-record('InvalidRequest', {
    'errors' :: [binary()]
}).

-endif.
