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
    'timer' :: dmsl_base_thrift:'Timer'()
}).

%% struct 'Withdrawal'
-record('wthadpt_Withdrawal', {
    'id' :: dmsl_base_thrift:'ID'(),
    'body' :: dmsl_withdrawals_provider_adapter_thrift:'Cash'(),
    'destination' :: dmsl_withdrawals_provider_adapter_thrift:'Destination'(),
    'sender' :: dmsl_withdrawals_provider_adapter_thrift:'Identity'() | undefined,
    'receiver' :: dmsl_withdrawals_provider_adapter_thrift:'Identity'() | undefined,
    'exchange_agree' :: dmsl_withdrawals_provider_adapter_thrift:'ExchangeAgree'() | undefined
}).

%% struct 'Cash'
-record('wthadpt_Cash', {
    'amount' :: dmsl_domain_thrift:'Amount'(),
    'currency' :: dmsl_domain_thrift:'Currency'()
}).

%% struct 'GetExchangeRatesParams'
-record('wthadpt_GetExchangeRatesParams', {
    'idempotency_id' :: dmsl_base_thrift:'ID'() | undefined,
    'currency_from' :: dmsl_domain_thrift:'Currency'(),
    'currency_to' :: dmsl_domain_thrift:'Currency'(),
    'exchange_cash' :: dmsl_withdrawals_provider_adapter_thrift:'ExchangeCash'()
}).

%% struct 'ProcessResult'
-record('wthadpt_ProcessResult', {
    'intent' :: dmsl_withdrawals_provider_adapter_thrift:'Intent'(),
    'next_state' :: dmsl_withdrawals_provider_adapter_thrift:'InternalState'() | undefined
}).

%% struct 'ExchangeAgree'
-record('wthadpt_ExchangeAgree', {
    'idempotency_id' :: dmsl_base_thrift:'ID'(),
    'rates' :: [dmsl_withdrawals_provider_adapter_thrift:'ExchangeRate'()],
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'expires_on' :: dmsl_base_thrift:'Timestamp'(),
    'rate_data' :: dmsl_withdrawals_provider_adapter_thrift:'RateData'() | undefined
}).

%% struct 'ExchangeRate'
-record('wthadpt_ExchangeRate', {
    'currency_from' :: dmsl_domain_thrift:'Currency'(),
    'currency_to' :: dmsl_domain_thrift:'Currency'(),
    'rate' :: dmsl_base_thrift:'Rational'(),
    'cash_range' :: dmsl_domain_thrift:'CashRange'(),
    'rounding_method' :: atom()
}).

-endif.
