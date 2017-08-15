-ifndef(dmsl_pay2card_thrift_included__).
-define(dmsl_pay2card_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_domain_thrift.hrl").



%% struct 'Cash'
-record('pay2card_Cash', {
    'amount' :: dmsl_domain_thrift:'Amount'(),
    'currency' :: dmsl_domain_thrift:'Currency'()
}).

%% struct 'TransferRequest'
-record('pay2card_TransferRequest', {
    'request_id' :: binary(),
    'actor_id' :: binary(),
    'card_token' :: dmsl_domain_thrift:'Token'(),
    'cash' :: dmsl_pay2card_thrift:'Cash'()
}).

%% struct 'TransferResult'
-record('pay2card_TransferResult', {
    'provider' :: atom(),
    'transaction_id' :: binary(),
    'maskCard' :: binary(),
    'fee' :: dmsl_pay2card_thrift:'Cash'() | undefined
}).

%% exception 'ProviderFailure'
-record('pay2card_ProviderFailure', {
    'provider' :: atom(),
    'code' :: binary(),
    'description' :: binary() | undefined
}).

-endif.
