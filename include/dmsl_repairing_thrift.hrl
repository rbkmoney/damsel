-ifndef(dmsl_repairing_thrift_included__).
-define(dmsl_repairing_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").



%% struct 'ComplexAction'
-record('repair_ComplexAction', {
    'timer' :: dmsl_repairing_thrift:'TimerAction'() | undefined,
    'remove' :: dmsl_repairing_thrift:'RemoveAction'() | undefined
}).

%% struct 'SetTimerAction'
-record('repair_SetTimerAction', {
    'timer' :: dmsl_base_thrift:'Timer'()
}).

%% struct 'UnsetTimerAction'
-record('repair_UnsetTimerAction', {}).

%% struct 'RemoveAction'
-record('repair_RemoveAction', {}).

-endif.
