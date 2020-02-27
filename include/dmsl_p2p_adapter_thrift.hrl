-ifndef(dmsl_p2p_adapter_thrift_included__).
-define(dmsl_p2p_adapter_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_domain_thrift.hrl").
-include("dmsl_user_interaction_thrift.hrl").



%% struct 'FinishIntent'
-record('p2p_adapter_FinishIntent', {
    'status' :: dmsl_p2p_adapter_thrift:'FinishStatus'()
}).

%% struct 'Success'
-record('p2p_adapter_Success', {}).

%% struct 'SleepIntent'
-record('p2p_adapter_SleepIntent', {
    'timer' :: dmsl_base_thrift:'Timer'(),
    'user_interaction' :: dmsl_p2p_adapter_thrift:'UserInteraction'() | undefined,
    'callback_tag' :: dmsl_p2p_adapter_thrift:'CallbackTag'() | undefined
}).

%% struct 'UserInteraction'
-record('p2p_adapter_UserInteraction', {
    'id' :: dmsl_p2p_adapter_thrift:'UserInteractionID'(),
    'intent' :: dmsl_p2p_adapter_thrift:'UserInteractionIntent'()
}).

%% struct 'UserInteractionCreate'
-record('p2p_adapter_UserInteractionCreate', {
    'user_interaction' :: dmsl_user_interaction_thrift:'UserInteraction'()
}).

%% struct 'UserInteractionFinish'
-record('p2p_adapter_UserInteractionFinish', {}).

%% struct 'Cash'
-record('p2p_adapter_Cash', {
    'amount' :: dmsl_domain_thrift:'Amount'(),
    'currency' :: dmsl_domain_thrift:'Currency'()
}).

%% struct 'Fees'
-record('p2p_adapter_Fees', {
    'fees' :: #{atom() => dmsl_p2p_adapter_thrift:'Cash'()}
}).

%% struct 'ProcessOperationInfo'
-record('p2p_adapter_ProcessOperationInfo', {
    'body' :: dmsl_p2p_adapter_thrift:'Cash'(),
    'merchant_fees' :: dmsl_p2p_adapter_thrift:'Fees'() | undefined,
    'provider_fees' :: dmsl_p2p_adapter_thrift:'Fees'() | undefined,
    'sender' :: dmsl_p2p_adapter_thrift:'PaymentResource'(),
    'receiver' :: dmsl_p2p_adapter_thrift:'PaymentResource'(),
    'deadline' :: dmsl_base_thrift:'Timestamp'() | undefined,
    'id' :: dmsl_p2p_adapter_thrift:'OperationID'()
}).

%% struct 'Session'
-record('p2p_adapter_Session', {
    'state' :: dmsl_p2p_adapter_thrift:'AdapterState'() | undefined,
    'id' :: dmsl_p2p_adapter_thrift:'SessionID'()
}).

%% struct 'Context'
-record('p2p_adapter_Context', {
    'session' :: dmsl_p2p_adapter_thrift:'Session'(),
    'operation' :: dmsl_p2p_adapter_thrift:'OperationInfo'(),
    'options' = #{} :: dmsl_domain_thrift:'ProxyOptions'() | undefined
}).

%% struct 'ProcessResult'
-record('p2p_adapter_ProcessResult', {
    'intent' :: dmsl_p2p_adapter_thrift:'Intent'(),
    'next_state' :: dmsl_p2p_adapter_thrift:'AdapterState'() | undefined,
    'trx' :: dmsl_domain_thrift:'TransactionInfo'() | undefined
}).

%% struct 'Callback'
-record('p2p_adapter_Callback', {
    'tag' :: dmsl_p2p_adapter_thrift:'CallbackTag'(),
    'payload' :: dmsl_p2p_adapter_thrift:'CallbackPayload'()
}).

%% struct 'CallbackResponse'
-record('p2p_adapter_CallbackResponse', {
    'payload' :: dmsl_p2p_adapter_thrift:'CallbackResponsePayload'()
}).

%% struct 'CallbackResult'
-record('p2p_adapter_CallbackResult', {
    'intent' :: dmsl_p2p_adapter_thrift:'Intent'(),
    'next_state' :: dmsl_p2p_adapter_thrift:'AdapterState'() | undefined,
    'trx' :: dmsl_domain_thrift:'TransactionInfo'() | undefined,
    'response' :: dmsl_p2p_adapter_thrift:'CallbackResponse'()
}).

%% struct 'ProcessCallbackSucceeded'
-record('p2p_adapter_ProcessCallbackSucceeded', {
    'response' :: dmsl_p2p_adapter_thrift:'CallbackResponse'()
}).

%% struct 'ProcessCallbackFinished'
-record('p2p_adapter_ProcessCallbackFinished', {
    'response' :: dmsl_p2p_adapter_thrift:'Context'()
}).

%% exception 'SessionNotFound'
-record('p2p_adapter_SessionNotFound', {}).

-endif.
