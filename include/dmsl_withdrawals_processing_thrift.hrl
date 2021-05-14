-ifndef(dmsl_withdrawals_processing_thrift_included__).
-define(dmsl_withdrawals_processing_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_msgpack_thrift.hrl").
-include("dmsl_domain_thrift.hrl").
-include("dmsl_withdrawals_domain_thrift.hrl").



%% struct 'WithdrawalState'
-record('wthproc_WithdrawalState', {
    'id' :: dmsl_withdrawals_processing_thrift:'WithdrawalID'(),
    'withdrawal' :: dmsl_withdrawals_processing_thrift:'Withdrawal'(),
    'created_at' :: dmsl_withdrawals_processing_thrift:'Timestamp'(),
    'updated_at' :: dmsl_withdrawals_processing_thrift:'Timestamp'() | undefined,
    'status' :: dmsl_withdrawals_processing_thrift:'WithdrawalStatus'()
}).

%% struct 'WithdrawalPending'
-record('wthproc_WithdrawalPending', {}).

%% struct 'WithdrawalSucceeded'
-record('wthproc_WithdrawalSucceeded', {}).

%% struct 'WithdrawalFailed'
-record('wthproc_WithdrawalFailed', {
    'failure' :: dmsl_withdrawals_processing_thrift:'Failure'()
}).

%% struct 'Event'
-record('wthproc_Event', {
    'id' :: dmsl_withdrawals_processing_thrift:'EventID'(),
    'occured_at' :: dmsl_withdrawals_processing_thrift:'Timestamp'(),
    'changes' :: [dmsl_withdrawals_processing_thrift:'Change'()]
}).

%% struct 'SessionChange'
-record('wthproc_SessionChange', {
    'id' :: dmsl_withdrawals_processing_thrift:'SessionID'(),
    'payload' :: dmsl_withdrawals_processing_thrift:'SessionChangePayload'()
}).

%% struct 'SessionStarted'
-record('wthproc_SessionStarted', {}).

%% struct 'SessionFinished'
-record('wthproc_SessionFinished', {
    'result' :: dmsl_withdrawals_processing_thrift:'SessionResult'()
}).

%% struct 'SessionSucceeded'
-record('wthproc_SessionSucceeded', {
    'trx_info' :: dmsl_domain_thrift:'TransactionInfo'()
}).

%% struct 'SessionFailed'
-record('wthproc_SessionFailed', {
    'failure' :: dmsl_withdrawals_processing_thrift:'Failure'()
}).

%% struct 'SessionAdapterStateChanged'
-record('wthproc_SessionAdapterStateChanged', {
    'state' :: dmsl_msgpack_thrift:'Value'()
}).

%% struct 'SinkEvent'
-record('wthproc_SinkEvent', {
    'id' :: dmsl_withdrawals_processing_thrift:'SinkEventID'(),
    'created_at' :: dmsl_withdrawals_processing_thrift:'Timestamp'(),
    'source' :: dmsl_withdrawals_processing_thrift:'WithdrawalID'(),
    'payload' :: dmsl_withdrawals_processing_thrift:'Event'()
}).

%% struct 'SinkEventRange'
-record('wthproc_SinkEventRange', {
    'after' :: dmsl_withdrawals_processing_thrift:'SinkEventID'() | undefined,
    'limit' :: integer()
}).

%% exception 'WithdrawalNotFound'
-record('wthproc_WithdrawalNotFound', {}).

%% exception 'SinkEventNotFound'
-record('wthproc_SinkEventNotFound', {}).

%% exception 'NoLastEvent'
-record('wthproc_NoLastEvent', {}).

-endif.
