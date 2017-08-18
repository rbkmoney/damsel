-ifndef(dmsl_payout_processing_thrift_included__).
-define(dmsl_payout_processing_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_domain_thrift.hrl").



%% struct 'UserInfo'
-record('payout_processing_UserInfo', {
    'id' :: dmsl_payout_processing_thrift:'UserID'(),
    'type' :: dmsl_payout_processing_thrift:'UserType'()
}).

%% struct 'InternalUser'
-record('payout_processing_InternalUser', {}).

%% struct 'ExternalUser'
-record('payout_processing_ExternalUser', {}).

%% struct 'ServiceUser'
-record('payout_processing_ServiceUser', {}).

%% struct 'Event'
-record('payout_processing_Event', {
    'id' :: dmsl_base_thrift:'EventID'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'source' :: dmsl_payout_processing_thrift:'EventSource'(),
    'payload' :: dmsl_payout_processing_thrift:'EventPayload'()
}).

%% struct 'PayoutCreated'
-record('payout_processing_PayoutCreated', {
    'payout' :: dmsl_payout_processing_thrift:'Payout'(),
    'initiator' :: dmsl_payout_processing_thrift:'UserInfo'()
}).

%% struct 'Payout'
-record('payout_processing_Payout', {
    'id' :: dmsl_payout_processing_thrift:'PayoutID'(),
    'party_id' :: dmsl_domain_thrift:'PartyID'(),
    'shop_id' :: dmsl_domain_thrift:'ShopID'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'status' :: dmsl_payout_processing_thrift:'PayoutStatus'(),
    'payout_flow' :: dmsl_domain_thrift:'FinalCashFlow'(),
    'payout_type' :: dmsl_payout_processing_thrift:'PayoutType'()
}).

%% struct 'PayoutUnpaid'
-record('payout_processing_PayoutUnpaid', {}).

%% struct 'PayoutPaid'
-record('payout_processing_PayoutPaid', {
    'details' :: dmsl_payout_processing_thrift:'PaidDetails'()
}).

%% struct 'CardPaidDetails'
-record('payout_processing_CardPaidDetails', {
    'provider_details' :: dmsl_payout_processing_thrift:'ProviderDetails'()
}).

%% struct 'ProviderDetails'
-record('payout_processing_ProviderDetails', {
    'name' :: binary(),
    'transaction_id' :: binary()
}).

%% struct 'AccountPaidDetails'
-record('payout_processing_AccountPaidDetails', {}).

%% struct 'PayoutCancelled'
-record('payout_processing_PayoutCancelled', {
    'user_info' :: dmsl_payout_processing_thrift:'UserInfo'(),
    'details' :: binary()
}).

%% struct 'PayoutConfirmed'
-record('payout_processing_PayoutConfirmed', {
    'user_info' :: dmsl_payout_processing_thrift:'UserInfo'()
}).

%% struct 'PayoutCard'
-record('payout_processing_PayoutCard', {
    'request_id' :: binary(),
    'bank_card' :: dmsl_domain_thrift:'BankCard'()
}).

%% struct 'PayoutAccount'
-record('payout_processing_PayoutAccount', {
    'account' :: binary(),
    'bank_corr_account' :: binary(),
    'bank_bik' :: binary(),
    'inn' :: binary(),
    'purpose' :: binary()
}).

%% struct 'PayoutStatusChanged'
-record('payout_processing_PayoutStatusChanged', {
    'status' :: dmsl_payout_processing_thrift:'PayoutStatus'()
}).

%% struct 'EventRange'
-record('payout_processing_EventRange', {
    'after' :: dmsl_base_thrift:'EventID'() | undefined,
    'limit' :: integer()
}).

%% struct 'Pay2CardParams'
-record('payout_processing_Pay2CardParams', {
    'bank_card' :: dmsl_domain_thrift:'BankCard'(),
    'party_id' :: dmsl_domain_thrift:'PartyID'(),
    'shop_id' :: dmsl_domain_thrift:'ShopID'(),
    'sum' :: dmsl_domain_thrift:'Cash'()
}).

%% struct 'TimeRange'
-record('payout_processing_TimeRange', {
    'from_time' :: dmsl_base_thrift:'Timestamp'(),
    'to_time' :: dmsl_base_thrift:'Timestamp'() | undefined
}).

%% struct 'GeneratePayoutParams'
-record('payout_processing_GeneratePayoutParams', {
    'time_range' :: dmsl_payout_processing_thrift:'TimeRange'(),
    'party_id' :: dmsl_domain_thrift:'PartyID'(),
    'shop_id' :: dmsl_domain_thrift:'ShopID'()
}).

%% exception 'NoLastEvent'
-record('payout_processing_NoLastEvent', {}).

%% exception 'EventNotFound'
-record('payout_processing_EventNotFound', {}).

%% exception 'InsufficientFunds'
-record('payout_processing_InsufficientFunds', {}).

%% exception 'LimitExceeded'
-record('payout_processing_LimitExceeded', {}).

-endif.
