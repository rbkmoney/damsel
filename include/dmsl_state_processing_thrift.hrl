-ifndef(dmsl_state_processing_thrift_included__).
-define(dmsl_state_processing_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_msgpack_thrift.hrl").



%% struct 'Event'
-record('Event', {
    'id' :: dmsl_base_thrift:'EventID'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'event_payload' :: dmsl_state_processing_thrift:'EventBody'()
}).

%% struct 'Machine'
-record('Machine', {
    'ns' :: dmsl_base_thrift:'Namespace'(),
    'id' :: dmsl_base_thrift:'ID'(),
    'history' :: dmsl_state_processing_thrift:'History'(),
    'history_range' :: dmsl_state_processing_thrift:'HistoryRange'(),
    'aux_state' :: dmsl_state_processing_thrift:'AuxState'() | undefined,
    'timer' :: dmsl_base_thrift:'Timestamp'() | undefined
}).

%% struct 'MachineDescriptor'
-record('MachineDescriptor', {
    'ns' :: dmsl_base_thrift:'Namespace'(),
    'ref' :: dmsl_state_processing_thrift:'Reference'(),
    'range' :: dmsl_state_processing_thrift:'HistoryRange'()
}).

%% struct 'ComplexAction'
-record('ComplexAction', {
    'set_timer' :: dmsl_state_processing_thrift:'SetTimerAction'() | undefined,
    'timer' :: dmsl_state_processing_thrift:'TimerAction'() | undefined,
    'tag' :: dmsl_state_processing_thrift:'TagAction'() | undefined
}).

%% struct 'SetTimerAction'
-record('SetTimerAction', {
    'timer' :: dmsl_base_thrift:'Timer'(),
    'range' :: dmsl_state_processing_thrift:'HistoryRange'() | undefined,
    'timeout' :: dmsl_base_thrift:'Timeout'() | undefined
}).

%% struct 'UnsetTimerAction'
-record('UnsetTimerAction', {}).

%% struct 'TagAction'
-record('TagAction', {
    'tag' :: dmsl_base_thrift:'Tag'()
}).

%% struct 'MachineStateChange'
-record('MachineStateChange', {
    'aux_state' :: dmsl_state_processing_thrift:'AuxState'(),
    'events' :: dmsl_state_processing_thrift:'EventBodies'()
}).

%% struct 'CallArgs'
-record('CallArgs', {
    'arg' :: dmsl_state_processing_thrift:'Args'(),
    'machine' :: dmsl_state_processing_thrift:'Machine'()
}).

%% struct 'CallResult'
-record('CallResult', {
    'response' :: dmsl_state_processing_thrift:'CallResponse'(),
    'change' :: dmsl_state_processing_thrift:'MachineStateChange'(),
    'action' :: dmsl_state_processing_thrift:'ComplexAction'()
}).

%% struct 'InitSignal'
-record('InitSignal', {
    'arg' :: dmsl_msgpack_thrift:'Value'()
}).

%% struct 'TimeoutSignal'
-record('TimeoutSignal', {}).

%% struct 'RepairSignal'
-record('RepairSignal', {
    'arg' :: dmsl_msgpack_thrift:'Value'() | undefined
}).

%% struct 'SignalArgs'
-record('SignalArgs', {
    'signal' :: dmsl_state_processing_thrift:'Signal'(),
    'machine' :: dmsl_state_processing_thrift:'Machine'()
}).

%% struct 'SignalResult'
-record('SignalResult', {
    'change' :: dmsl_state_processing_thrift:'MachineStateChange'(),
    'action' :: dmsl_state_processing_thrift:'ComplexAction'()
}).

%% struct 'HistoryRange'
-record('HistoryRange', {
    'after' :: dmsl_base_thrift:'EventID'() | undefined,
    'limit' :: integer() | undefined,
    'direction' = 'forward' :: atom() | undefined
}).

%% struct 'SinkEvent'
-record('SinkEvent', {
    'id' :: dmsl_base_thrift:'EventID'(),
    'source_id' :: dmsl_base_thrift:'ID'(),
    'source_ns' :: dmsl_base_thrift:'Namespace'(),
    'event' :: dmsl_state_processing_thrift:'Event'()
}).

%% exception 'EventNotFound'
-record('EventNotFound', {}).

%% exception 'MachineNotFound'
-record('MachineNotFound', {}).

%% exception 'NamespaceNotFound'
-record('NamespaceNotFound', {}).

%% exception 'MachineAlreadyExists'
-record('MachineAlreadyExists', {}).

%% exception 'MachineFailed'
-record('MachineFailed', {}).

%% exception 'EventSinkNotFound'
-record('EventSinkNotFound', {}).

-endif.
