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

%% struct 'TimeSpan'
-record('TimeSpan', {
    'years' :: integer() | undefined,
    'months' :: integer() | undefined,
    'days' :: integer() | undefined,
    'hours' :: integer() | undefined,
    'minutes' :: integer() | undefined,
    'seconds' :: integer() | undefined
}).

%% struct 'Schedule'
-record('Schedule', {
    'year' :: dmsl_base_thrift:'ScheduleYear'(),
    'month' :: dmsl_base_thrift:'ScheduleMonth'(),
    'day_of_month' :: dmsl_base_thrift:'ScheduleFragment'(),
    'day_of_week' :: dmsl_base_thrift:'ScheduleDayOfWeek'(),
    'hour' :: dmsl_base_thrift:'ScheduleFragment'(),
    'minute' :: dmsl_base_thrift:'ScheduleFragment'(),
    'second' :: dmsl_base_thrift:'ScheduleFragment'()
}).

%% struct 'ScheduleEvery'
-record('ScheduleEvery', {
    'nth' :: integer() | undefined
}).

%% struct 'Rational'
-record('Rational', {
    'p' :: integer(),
    'q' :: integer()
}).

%% struct 'IntegerRange'
-record('IntegerRange', {
    'lower' :: integer() | undefined,
    'upper' :: integer() | undefined
}).

%% exception 'InvalidRequest'
-record('InvalidRequest', {
    'errors' :: [binary()]
}).

-endif.
