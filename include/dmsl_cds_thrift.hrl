-ifndef(dmsl_cds_thrift_included__).
-define(dmsl_cds_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_domain_thrift.hrl").



%% struct 'ExpDate'
-record('ExpDate', {
    'month' :: integer(),
    'year' :: integer()
}).

%% struct 'CardData'
-record('CardData', {
    'pan' :: binary(),
    'exp_date' :: dmsl_cds_thrift:'ExpDate'(),
    'cardholder_name' :: binary(),
    'cvv' :: binary()
}).

%% struct 'PutCardDataResult'
-record('PutCardDataResult', {
    'bank_card' :: dmsl_domain_thrift:'BankCard'(),
    'session_id' :: dmsl_domain_thrift:'PaymentSessionID'()
}).

%% struct 'Unlocked'
-record('Unlocked', {}).

%% exception 'InvalidCardData'
-record('InvalidCardData', {}).

%% exception 'CardDataNotFound'
-record('CardDataNotFound', {}).

%% exception 'NoKeyring'
-record('NoKeyring', {}).

%% exception 'KeyringLocked'
-record('KeyringLocked', {}).

%% exception 'KeyringExists'
-record('KeyringExists', {}).

-endif.
