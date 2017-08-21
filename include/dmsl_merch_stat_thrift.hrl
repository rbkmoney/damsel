-ifndef(dmsl_merch_stat_thrift_included__).
-define(dmsl_merch_stat_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_domain_thrift.hrl").
-include("dmsl_geo_ip_thrift.hrl").



%% struct 'StatPayment'
-record('merchstat_StatPayment', {
    'id' :: dmsl_domain_thrift:'InvoicePaymentID'(),
    'invoice_id' :: dmsl_domain_thrift:'InvoiceID'(),
    'owner_id' :: dmsl_domain_thrift:'PartyID'(),
    'shop_id' :: dmsl_domain_thrift:'ShopID'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'status' :: dmsl_merch_stat_thrift:'InvoicePaymentStatus'(),
    'amount' :: dmsl_domain_thrift:'Amount'(),
    'fee' :: dmsl_domain_thrift:'Amount'(),
    'currency_symbolic_code' :: binary(),
    'payment_tool' :: dmsl_merch_stat_thrift:'PaymentTool'(),
    'ip_address' :: dmsl_domain_thrift:'IPAddress'() | undefined,
    'fingerprint' :: dmsl_domain_thrift:'Fingerprint'() | undefined,
    'phone_number' :: binary() | undefined,
    'email' :: binary() | undefined,
    'session_id' :: dmsl_domain_thrift:'PaymentSessionID'(),
    'context' :: dmsl_base_thrift:'Content'() | undefined,
    'location_info' :: dmsl_geo_ip_thrift:'LocationInfo'() | undefined
}).

%% struct 'OperationTimeout'
-record('merchstat_OperationTimeout', {}).

%% struct 'ExternalFailure'
-record('merchstat_ExternalFailure', {
    'code' :: binary(),
    'description' :: binary() | undefined
}).

%% struct 'InvoicePaymentPending'
-record('merchstat_InvoicePaymentPending', {}).

%% struct 'InvoicePaymentProcessed'
-record('merchstat_InvoicePaymentProcessed', {}).

%% struct 'InvoicePaymentCaptured'
-record('merchstat_InvoicePaymentCaptured', {}).

%% struct 'InvoicePaymentCancelled'
-record('merchstat_InvoicePaymentCancelled', {}).

%% struct 'InvoicePaymentFailed'
-record('merchstat_InvoicePaymentFailed', {
    'failure' :: dmsl_merch_stat_thrift:'OperationFailure'()
}).

%% struct 'BankCard'
-record('merchstat_BankCard', {
    'token' :: dmsl_domain_thrift:'Token'(),
    'payment_system' :: atom(),
    'bin' :: binary(),
    'masked_pan' :: binary()
}).

%% struct 'StatInvoice'
-record('merchstat_StatInvoice', {
    'id' :: dmsl_domain_thrift:'InvoiceID'(),
    'owner_id' :: dmsl_domain_thrift:'PartyID'(),
    'shop_id' :: dmsl_domain_thrift:'ShopID'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'status' :: dmsl_merch_stat_thrift:'InvoiceStatus'(),
    'product' :: binary(),
    'description' :: binary() | undefined,
    'due' :: dmsl_base_thrift:'Timestamp'(),
    'amount' :: dmsl_domain_thrift:'Amount'(),
    'currency_symbolic_code' :: binary(),
    'context' :: dmsl_base_thrift:'Content'() | undefined,
    'cart' :: dmsl_domain_thrift:'InvoiceCart'() | undefined
}).

%% struct 'InvoiceUnpaid'
-record('merchstat_InvoiceUnpaid', {}).

%% struct 'InvoicePaid'
-record('merchstat_InvoicePaid', {}).

%% struct 'InvoiceCancelled'
-record('merchstat_InvoiceCancelled', {
    'details' :: binary()
}).

%% struct 'InvoiceFulfilled'
-record('merchstat_InvoiceFulfilled', {
    'details' :: binary()
}).

%% struct 'StatCustomer'
-record('merchstat_StatCustomer', {
    'id' :: dmsl_domain_thrift:'Fingerprint'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'()
}).

%% struct 'StatRequest'
-record('merchstat_StatRequest', {
    'dsl' :: binary()
}).

%% struct 'StatResponse'
-record('merchstat_StatResponse', {
    'data' :: dmsl_merch_stat_thrift:'StatResponseData'(),
    'total_count' :: integer() | undefined
}).

%% exception 'DatasetTooBig'
-record('merchstat_DatasetTooBig', {
    'limit' :: integer()
}).

-endif.
