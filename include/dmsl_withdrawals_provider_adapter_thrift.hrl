-ifndef(dmsl_withdrawals_provider_adapter_thrift_included__).
-define(dmsl_withdrawals_provider_adapter_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_msgpack_thrift.hrl").
-include("dmsl_domain_thrift.hrl").
-include("dmsl_withdrawals_domain_thrift.hrl").



%% struct 'FinishIntent'
-record('wthadpt_FinishIntent', {
    'status' :: dmsl_withdrawals_provider_adapter_thrift:'FinishStatus'()
}).

%% struct 'Success'
-record('wthadpt_Success', {
    'trx_info' :: dmsl_domain_thrift:'TransactionInfo'()
}).

%% struct 'SleepIntent'
-record('wthadpt_SleepIntent', {
    'timer' :: dmsl_base_thrift:'Timer'(),
    'callback_tag' :: dmsl_withdrawals_provider_adapter_thrift:'CallbackTag'() | undefined
}).

%% struct 'Withdrawal'
-record('wthadpt_Withdrawal', {
    'id' :: dmsl_base_thrift:'ID'(),
    'session_id' :: dmsl_base_thrift:'ID'() | undefined,
    'body' :: dmsl_withdrawals_provider_adapter_thrift:'Cash'(),
    'destination' :: dmsl_withdrawals_provider_adapter_thrift:'Destination'(),
    'sender' :: dmsl_withdrawals_provider_adapter_thrift:'Identity'() | undefined,
    'receiver' :: dmsl_withdrawals_provider_adapter_thrift:'Identity'() | undefined,
    'quote' :: dmsl_withdrawals_provider_adapter_thrift:'Quote'() | undefined
}).

%% struct 'Cash'
-record('wthadpt_Cash', {
    'amount' :: dmsl_domain_thrift:'Amount'(),
    'currency' :: dmsl_domain_thrift:'Currency'()
}).

%% struct 'GetQuoteParams'
-record('wthadpt_GetQuoteParams', {
    'idempotency_id' :: dmsl_base_thrift:'ID'() | undefined,
    'currency_from' :: dmsl_domain_thrift:'Currency'(),
    'currency_to' :: dmsl_domain_thrift:'Currency'(),
    'exchange_cash' :: dmsl_withdrawals_provider_adapter_thrift:'Cash'()
}).

%% struct 'GeneralFailure'
-record('wthadpt_GeneralFailure', {}).

%% struct 'ProcessResult'
-record('wthadpt_ProcessResult', {
    'intent' :: dmsl_withdrawals_provider_adapter_thrift:'Intent'(),
    'next_state' :: dmsl_withdrawals_provider_adapter_thrift:'InternalState'() | undefined
}).

%% struct 'Quote'
-record('wthadpt_Quote', {
    'cash_from' :: dmsl_withdrawals_provider_adapter_thrift:'Cash'(),
    'cash_to' :: dmsl_withdrawals_provider_adapter_thrift:'Cash'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'expires_on' :: dmsl_base_thrift:'Timestamp'(),
    'quote_data' :: dmsl_withdrawals_provider_adapter_thrift:'QuoteData'()
}).

%% struct 'Callback'
-record('wthadpt_Callback', {
    'tag' :: dmsl_withdrawals_provider_adapter_thrift:'CallbackTag'(),
    'payload' :: dmsl_withdrawals_provider_adapter_thrift:'CallbackPayload'()
}).

%% struct 'CallbackResponse'
-record('wthadpt_CallbackResponse', {
    'payload' :: dmsl_withdrawals_provider_adapter_thrift:'CallbackResponsePayload'()
}).

%% struct 'CallbackResult'
-record('wthadpt_CallbackResult', {
    'intent' :: dmsl_withdrawals_provider_adapter_thrift:'Intent'(),
    'next_state' :: dmsl_withdrawals_provider_adapter_thrift:'InternalState'() | undefined,
    'response' :: dmsl_withdrawals_provider_adapter_thrift:'CallbackResponse'()
}).

%% struct 'ProcessCallbackSucceeded'
-record('wthadpt_ProcessCallbackSucceeded', {
    'response' :: dmsl_withdrawals_provider_adapter_thrift:'CallbackResponse'()
}).

%% struct 'ProcessCallbackFinished'
-record('wthadpt_ProcessCallbackFinished', {
    'withdrawal' :: dmsl_withdrawals_provider_adapter_thrift:'Withdrawal'(),
    'state' :: dmsl_withdrawals_provider_adapter_thrift:'InternalState'(),
    'opts' :: dmsl_withdrawals_provider_adapter_thrift:'Options'()
}).

%% exception 'GetQuoteFailure'
-record('wthadpt_GetQuoteFailure', {
    'failure' :: dmsl_withdrawals_provider_adapter_thrift:'QuoteFailure'()
}).

%% exception 'SessionNotFound'
-record('wthadpt_SessionNotFound', {}).

-endif.
