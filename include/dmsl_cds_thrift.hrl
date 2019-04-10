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
    'cardholder_name' :: binary() | undefined,
    'cvv' :: binary() | undefined
}).

%% struct 'PutCardDataResult'
-record('PutCardDataResult', {
    'bank_card' :: dmsl_domain_thrift:'BankCard'(),
    'session_id' :: dmsl_domain_thrift:'PaymentSessionID'()
}).

%% struct 'CardSecurityCode'
-record('CardSecurityCode', {
    'value' :: binary()
}).

%% struct 'Auth3DS'
-record('Auth3DS', {
    'cryptogram' :: binary(),
    'eci' :: binary() | undefined
}).

%% struct 'SessionData'
-record('SessionData', {
    'auth_data' :: dmsl_cds_thrift:'AuthData'()
}).

%% struct 'PutCardDataParams'
-record('PutCardDataParams', {
    'idempotency_key' :: binary() | undefined
}).

%% struct 'Unlocked'
-record('Unlocked', {}).

%% exception 'InvalidCardData'
-record('InvalidCardData', {
    'reason' :: binary() | undefined
}).

%% exception 'CardDataNotFound'
-record('CardDataNotFound', {}).

%% exception 'SessionDataNotFound'
-record('SessionDataNotFound', {}).

%% exception 'NoKeyring'
-record('NoKeyring', {}).

%% exception 'KeyringLocked'
-record('KeyringLocked', {}).

%% exception 'KeyringExists'
-record('KeyringExists', {}).

-endif.
