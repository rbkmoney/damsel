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

%% struct 'PayoutSummaryItem'
-record('payout_processing_PayoutSummaryItem', {
    'amount' :: dmsl_domain_thrift:'Amount'(),
    'fee' :: dmsl_domain_thrift:'Amount'(),
    'currency_symbolic_code' :: binary(),
    'from_time' :: dmsl_base_thrift:'Timestamp'(),
    'to_time' :: dmsl_base_thrift:'Timestamp'(),
    'operation_type' :: atom(),
    'count' :: integer()
}).

%% struct 'Payout'
-record('payout_processing_Payout', {
    'id' :: dmsl_payout_processing_thrift:'PayoutID'(),
    'party_id' :: dmsl_domain_thrift:'PartyID'(),
    'shop_id' :: dmsl_domain_thrift:'ShopID'(),
    'contract_id' :: dmsl_domain_thrift:'ContractID'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'status' :: dmsl_payout_processing_thrift:'PayoutStatus'(),
    'payout_flow' :: dmsl_domain_thrift:'FinalCashFlow'(),
    'type' :: dmsl_payout_processing_thrift:'PayoutType'(),
    'summary' :: dmsl_payout_processing_thrift:'PayoutSummary'() | undefined
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
    'card' :: dmsl_domain_thrift:'BankCard'()
}).

%% struct 'RussianPayoutAccount'
-record('payout_processing_RussianPayoutAccount', {
    'bank_account' :: dmsl_domain_thrift:'RussianBankAccount'(),
    'inn' :: binary(),
    'purpose' :: binary(),
    'legal_agreement' :: dmsl_domain_thrift:'LegalAgreement'()
}).

%% struct 'InternationalPayoutAccount'
-record('payout_processing_InternationalPayoutAccount', {
    'bank_account' :: dmsl_domain_thrift:'InternationalBankAccount'(),
    'legal_entity' :: dmsl_domain_thrift:'InternationalLegalEntity'(),
    'purpose' :: binary(),
    'legal_agreement' :: dmsl_domain_thrift:'LegalAgreement'()
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
    'to_time' :: dmsl_base_thrift:'Timestamp'()
}).

%% struct 'AmountRange'
-record('payout_processing_AmountRange', {
    'min' :: dmsl_domain_thrift:'Amount'() | undefined,
    'max' :: dmsl_domain_thrift:'Amount'() | undefined
}).

%% struct 'ShopParams'
-record('payout_processing_ShopParams', {
    'party_id' :: dmsl_domain_thrift:'PartyID'(),
    'shop_id' :: dmsl_domain_thrift:'ShopID'()
}).

%% struct 'GeneratePayoutParams'
-record('payout_processing_GeneratePayoutParams', {
    'time_range' :: dmsl_payout_processing_thrift:'TimeRange'(),
    'shop' :: dmsl_payout_processing_thrift:'ShopParams'()
}).

%% struct 'PayoutSearchCriteria'
-record('payout_processing_PayoutSearchCriteria', {
    'status' :: dmsl_payout_processing_thrift:'PayoutSearchStatus'() | undefined,
    'time_range' :: dmsl_payout_processing_thrift:'TimeRange'() | undefined,
    'payout_ids' :: [dmsl_payout_processing_thrift:'PayoutID'()] | undefined,
    'amount_range' :: dmsl_payout_processing_thrift:'AmountRange'() | undefined,
    'currency' :: dmsl_domain_thrift:'CurrencyRef'() | undefined
}).

%% struct 'PayoutSearchRequest'
-record('payout_processing_PayoutSearchRequest', {
    'search_criteria' :: dmsl_payout_processing_thrift:'PayoutSearchCriteria'(),
    'from_id' :: integer() | undefined,
    'size' :: integer() | undefined
}).

%% struct 'PayoutSearchResponse'
-record('payout_processing_PayoutSearchResponse', {
    'payouts' :: [dmsl_payout_processing_thrift:'PayoutInfo'()],
    'last_id' :: integer()
}).

%% struct 'PayoutInfo'
-record('payout_processing_PayoutInfo', {
    'id' :: dmsl_payout_processing_thrift:'PayoutID'(),
    'party_id' :: dmsl_domain_thrift:'PartyID'(),
    'shop_id' :: dmsl_domain_thrift:'ShopID'(),
    'contract_id' :: dmsl_domain_thrift:'ContractID'(),
    'amount' :: dmsl_domain_thrift:'Cash'(),
    'type' :: dmsl_payout_processing_thrift:'PayoutType'(),
    'status' :: atom(),
    'from_time' :: dmsl_base_thrift:'Timestamp'(),
    'to_time' :: dmsl_base_thrift:'Timestamp'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'summary' :: dmsl_payout_processing_thrift:'PayoutSummary'() | undefined
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
