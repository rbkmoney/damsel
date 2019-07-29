-ifndef(dmsl_cds_thrift_included__).
-define(dmsl_cds_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_domain_thrift.hrl").



%% struct 'EncryptedMasterKeyShare'
-record('EncryptedMasterKeyShare', {
    'id' :: dmsl_cds_thrift:'ShareholderId'(),
    'owner' :: binary(),
    'encrypted_share' :: binary()
}).

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

%% struct 'PutCardResult'
-record('PutCardResult', {
    'bank_card' :: dmsl_domain_thrift:'BankCard'()
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

%% struct 'Success'
-record('Success', {}).

%% struct 'RotationState'
-record('RotationState', {
    'phase' :: atom(),
    'lifetime' :: dmsl_cds_thrift:'Seconds'() | undefined,
    'confirmation_shares' :: dmsl_cds_thrift:'ShareSubmitters'()
}).

%% struct 'InitializationState'
-record('InitializationState', {
    'phase' :: atom(),
    'lifetime' :: dmsl_cds_thrift:'Seconds'() | undefined,
    'validation_shares' :: dmsl_cds_thrift:'ShareSubmitters'()
}).

%% struct 'UnlockState'
-record('UnlockState', {
    'phase' :: atom(),
    'lifetime' :: dmsl_cds_thrift:'Seconds'() | undefined,
    'confirmation_shares' :: dmsl_cds_thrift:'ShareSubmitters'()
}).

%% struct 'RekeyingState'
-record('RekeyingState', {
    'phase' :: atom(),
    'lifetime' :: dmsl_cds_thrift:'Seconds'() | undefined,
    'confirmation_shares' :: dmsl_cds_thrift:'ShareSubmitters'(),
    'validation_shares' :: dmsl_cds_thrift:'ShareSubmitters'()
}).

%% struct 'ActivitiesState'
-record('ActivitiesState', {
    'initialization' :: dmsl_cds_thrift:'InitializationState'(),
    'rotation' :: dmsl_cds_thrift:'RotationState'(),
    'unlock' :: dmsl_cds_thrift:'UnlockState'(),
    'rekeying' :: dmsl_cds_thrift:'RekeyingState'()
}).

%% struct 'KeyringState'
-record('KeyringState', {
    'status' :: atom(),
    'activities' :: dmsl_cds_thrift:'ActivitiesState'()
}).

%% exception 'InvalidStatus'
-record('InvalidStatus', {
    'status' :: atom()
}).

%% exception 'InvalidActivity'
-record('InvalidActivity', {
    'activity' :: dmsl_cds_thrift:'Activity'()
}).

%% exception 'InvalidCardData'
-record('InvalidCardData', {
    'reason' :: binary() | undefined
}).

%% exception 'CardDataNotFound'
-record('CardDataNotFound', {}).

%% exception 'SessionDataNotFound'
-record('SessionDataNotFound', {}).

%% exception 'InvalidArguments'
-record('InvalidArguments', {
    'reason' :: binary() | undefined
}).

%% exception 'OperationAborted'
-record('OperationAborted', {
    'reason' :: binary() | undefined
}).

%% exception 'VerificationFailed'
-record('VerificationFailed', {}).

-endif.
