-ifndef(dmsl_proxy_thrift_included__).
-define(dmsl_proxy_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_user_interaction_thrift.hrl").



%% struct 'FinishIntent'
-record('FinishIntent', {
    'status' :: dmsl_proxy_thrift:'FinishStatus'()
}).

%% struct 'Success'
-record('Success', {}).

%% struct 'Failure'
-record('Failure', {
    'code' :: binary(),
    'description' :: binary() | undefined
}).

%% struct 'SleepIntent'
-record('SleepIntent', {
    'timer' :: dmsl_base_thrift:'Timer'()
}).

%% struct 'SuspendIntent'
-record('SuspendIntent', {
    'tag' :: dmsl_proxy_thrift:'CallbackTag'(),
    'timeout' :: dmsl_base_thrift:'Timer'(),
    'user_interaction' :: dmsl_user_interaction_thrift:'UserInteraction'() | undefined
}).

-endif.
