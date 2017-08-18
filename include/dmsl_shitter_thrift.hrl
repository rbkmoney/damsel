-ifndef(dmsl_shitter_thrift_included__).
-define(dmsl_shitter_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_domain_thrift.hrl").



%% struct 'TimeRange'
-record('shitter_TimeRange', {
    'from_time' :: dmsl_base_thrift:'Timestamp'(),
    'to_time' :: dmsl_base_thrift:'Timestamp'() | undefined
}).

%% struct 'Payout'
-record('shitter_Payout', {
    'id' :: dmsl_shitter_thrift:'PayoutID'(),
    'status' :: atom(),
    'from_time' :: binary(),
    'to_time' :: binary(),
    'ones_status' :: binary(),
    'ones_report' :: binary() | undefined,
    'created_at' :: binary() | undefined
}).

%% struct 'PayoutPaymentInfo'
-record('shitter_PayoutPaymentInfo', {
    'id' :: binary(),
    'invoice_id' :: binary(),
    'payment_id' :: binary(),
    'party_id' :: binary(),
    'shop_id' :: binary(),
    'amount' :: binary(),
    'provider_comission' :: binary(),
    'rbk_comission' :: binary(),
    'payout_id' :: binary() | undefined,
    'created_at' :: binary() | undefined
}).

%% struct 'PayoutSearchCriteria'
-record('shitter_PayoutSearchCriteria', {
    'status' :: atom() | undefined,
    'timeRange' :: dmsl_shitter_thrift:'TimeRange'() | undefined,
    'payoutIDs' :: [dmsl_shitter_thrift:'PayoutID'()] | undefined
}).

-endif.
