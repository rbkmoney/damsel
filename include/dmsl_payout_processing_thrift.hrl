-ifndef(dmsl_payout_processing_thrift_included__).
-define(dmsl_payout_processing_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_domain_thrift.hrl").
-include("dmsl_msgpack_thrift.hrl").



%% struct 'Event'
-record('payout_processing_Event', {
    'id' :: dmsl_base_thrift:'EventID'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'source' :: dmsl_payout_processing_thrift:'EventSource'(),
    'payload' :: dmsl_payout_processing_thrift:'EventPayload'()
}).

%% struct 'PayoutCreated'
-record('payout_processing_PayoutCreated', {
    'payout' :: dmsl_payout_processing_thrift:'Payout'()
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
    'amount' :: dmsl_domain_thrift:'Cash'(),
    'fee' :: dmsl_domain_thrift:'Cash'(),
    'payout_flow' :: dmsl_domain_thrift:'FinalCashFlow'(),
    'type' :: dmsl_payout_processing_thrift:'PayoutType'(),
    'summary' :: dmsl_payout_processing_thrift:'PayoutSummary'() | undefined,
    'metadata' :: dmsl_payout_processing_thrift:'Metadata'() | undefined
}).

%% struct 'PayoutUnpaid'
-record('payout_processing_PayoutUnpaid', {}).

%% struct 'PayoutPaid'
-record('payout_processing_PayoutPaid', {}).

%% struct 'PayoutCancelled'
-record('payout_processing_PayoutCancelled', {
    'details' :: binary()
}).

%% struct 'PayoutConfirmed'
-record('payout_processing_PayoutConfirmed', {}).

%% struct 'Wallet'
-record('payout_processing_Wallet', {
    'wallet_id' :: dmsl_domain_thrift:'WalletID'()
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

%% struct 'PayoutParams'
-record('payout_processing_PayoutParams', {
    'payout_id' :: dmsl_payout_processing_thrift:'PayoutID'(),
    'shop' :: dmsl_payout_processing_thrift:'ShopParams'(),
    'payout_tool_id' :: dmsl_domain_thrift:'PayoutToolID'(),
    'amount' :: dmsl_domain_thrift:'Cash'(),
    'metadata' :: dmsl_payout_processing_thrift:'Metadata'() | undefined
}).

%% struct 'GeneratePayoutParams'
-record('payout_processing_GeneratePayoutParams', {
    'time_range' :: dmsl_payout_processing_thrift:'TimeRange'(),
    'shop_params' :: dmsl_payout_processing_thrift:'ShopParams'()
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
    'payouts' :: [dmsl_payout_processing_thrift:'Payout'()],
    'last_id' :: integer()
}).

%% exception 'NoLastEvent'
-record('payout_processing_NoLastEvent', {}).

%% exception 'EventNotFound'
-record('payout_processing_EventNotFound', {}).

%% exception 'InvalidPayoutTool'
-record('payout_processing_InvalidPayoutTool', {}).

%% exception 'PayoutNotFound'
-record('payout_processing_PayoutNotFound', {}).

%% exception 'InsufficientFunds'
-record('payout_processing_InsufficientFunds', {}).

%% exception 'LimitExceeded'
-record('payout_processing_LimitExceeded', {}).

-endif.
