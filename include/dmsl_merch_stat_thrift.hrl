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
    'payer' :: dmsl_merch_stat_thrift:'Payer'(),
    'context' :: dmsl_base_thrift:'Content'() | undefined,
    'location_info' :: dmsl_geo_ip_thrift:'LocationInfo'() | undefined,
    'flow' :: dmsl_merch_stat_thrift:'InvoicePaymentFlow'()
}).

%% struct 'PaymentResourcePayer'
-record('merchstat_PaymentResourcePayer', {
    'payment_tool' :: dmsl_merch_stat_thrift:'PaymentTool'(),
    'ip_address' :: dmsl_domain_thrift:'IPAddress'() | undefined,
    'fingerprint' :: dmsl_domain_thrift:'Fingerprint'() | undefined,
    'phone_number' :: binary() | undefined,
    'email' :: binary() | undefined,
    'session_id' :: dmsl_domain_thrift:'PaymentSessionID'()
}).

%% struct 'CustomerPayer'
-record('merchstat_CustomerPayer', {
    'customer_id' :: dmsl_domain_thrift:'CustomerID'()
}).

%% struct 'InvoicePaymentFlowInstant'
-record('merchstat_InvoicePaymentFlowInstant', {}).

%% struct 'InvoicePaymentFlowHold'
-record('merchstat_InvoicePaymentFlowHold', {
    'on_hold_expiration' :: dmsl_merch_stat_thrift:'OnHoldExpiration'(),
    'held_until' :: dmsl_base_thrift:'Timestamp'()
}).

%% struct 'OperationTimeout'
-record('merchstat_OperationTimeout', {}).

%% struct 'InvoicePaymentPending'
-record('merchstat_InvoicePaymentPending', {}).

%% struct 'InvoicePaymentProcessed'
-record('merchstat_InvoicePaymentProcessed', {}).

%% struct 'InvoicePaymentCaptured'
-record('merchstat_InvoicePaymentCaptured', {}).

%% struct 'InvoicePaymentCancelled'
-record('merchstat_InvoicePaymentCancelled', {}).

%% struct 'InvoicePaymentRefunded'
-record('merchstat_InvoicePaymentRefunded', {}).

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

%% struct 'PaymentTerminal'
-record('merchstat_PaymentTerminal', {
    'terminal_type' :: dmsl_merch_stat_thrift:'TerminalPaymentProvider'()
}).

%% struct 'DigitalWallet'
-record('merchstat_DigitalWallet', {
    'provider' :: dmsl_merch_stat_thrift:'DigitalWalletProvider'(),
    'id' :: dmsl_merch_stat_thrift:'DigitalWalletID'()
}).

%% struct 'RussianBankAccount'
-record('merchstat_RussianBankAccount', {
    'account' :: binary(),
    'bank_name' :: binary(),
    'bank_post_account' :: binary(),
    'bank_bik' :: binary()
}).

%% struct 'InternationalBankAccount'
-record('merchstat_InternationalBankAccount', {
    'account_holder' :: binary(),
    'bank_name' :: binary(),
    'bank_address' :: binary(),
    'iban' :: binary(),
    'bic' :: binary(),
    'local_bank_code' :: binary() | undefined
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

%% struct 'StatPayout'
-record('merchstat_StatPayout', {
    'id' :: dmsl_merch_stat_thrift:'PayoutID'(),
    'party_id' :: dmsl_domain_thrift:'PartyID'(),
    'shop_id' :: dmsl_domain_thrift:'ShopID'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'status' :: dmsl_merch_stat_thrift:'PayoutStatus'(),
    'amount' :: dmsl_domain_thrift:'Amount'(),
    'fee' :: dmsl_domain_thrift:'Amount'(),
    'currency_symbolic_code' :: binary(),
    'type' :: dmsl_merch_stat_thrift:'PayoutType'(),
    'summary' :: dmsl_merch_stat_thrift:'PayoutSummary'() | undefined
}).

%% struct 'PayoutSummaryItem'
-record('merchstat_PayoutSummaryItem', {
    'amount' :: dmsl_domain_thrift:'Amount'(),
    'fee' :: dmsl_domain_thrift:'Amount'(),
    'currency_symbolic_code' :: binary(),
    'from_time' :: dmsl_base_thrift:'Timestamp'(),
    'to_time' :: dmsl_base_thrift:'Timestamp'(),
    'operation_type' :: atom(),
    'count' :: integer()
}).

%% struct 'PayoutCard'
-record('merchstat_PayoutCard', {
    'card' :: dmsl_merch_stat_thrift:'BankCard'()
}).

%% struct 'RussianPayoutAccount'
-record('merchstat_RussianPayoutAccount', {
    'bank_account' :: dmsl_merch_stat_thrift:'RussianBankAccount'(),
    'inn' :: binary(),
    'purpose' :: binary()
}).

%% struct 'InternationalPayoutAccount'
-record('merchstat_InternationalPayoutAccount', {
    'bank_account' :: dmsl_merch_stat_thrift:'InternationalBankAccount'(),
    'purpose' :: binary()
}).

%% struct 'PayoutUnpaid'
-record('merchstat_PayoutUnpaid', {}).

%% struct 'PayoutPaid'
-record('merchstat_PayoutPaid', {}).

%% struct 'PayoutCancelled'
-record('merchstat_PayoutCancelled', {
    'details' :: binary()
}).

%% struct 'PayoutConfirmed'
-record('merchstat_PayoutConfirmed', {}).

%% struct 'StatRefund'
-record('merchstat_StatRefund', {
    'id' :: dmsl_domain_thrift:'InvoicePaymentRefundID'(),
    'payment_id' :: dmsl_domain_thrift:'InvoicePaymentID'(),
    'invoice_id' :: dmsl_domain_thrift:'InvoiceID'(),
    'owner_id' :: dmsl_domain_thrift:'PartyID'(),
    'shop_id' :: dmsl_domain_thrift:'ShopID'(),
    'status' :: dmsl_merch_stat_thrift:'InvoicePaymentRefundStatus'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'amount' :: dmsl_domain_thrift:'Amount'(),
    'fee' :: dmsl_domain_thrift:'Amount'(),
    'currency_symbolic_code' :: binary(),
    'reason' :: binary() | undefined
}).

%% struct 'InvoicePaymentRefundPending'
-record('merchstat_InvoicePaymentRefundPending', {}).

%% struct 'InvoicePaymentRefundSucceeded'
-record('merchstat_InvoicePaymentRefundSucceeded', {
    'at' :: dmsl_base_thrift:'Timestamp'()
}).

%% struct 'InvoicePaymentRefundFailed'
-record('merchstat_InvoicePaymentRefundFailed', {
    'failure' :: dmsl_merch_stat_thrift:'OperationFailure'(),
    'at' :: dmsl_base_thrift:'Timestamp'()
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
