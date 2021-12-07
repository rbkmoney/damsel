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
    'flow' :: dmsl_merch_stat_thrift:'InvoicePaymentFlow'(),
    'short_id' :: binary() | undefined,
    'make_recurrent' :: boolean() | undefined,
    'domain_revision' :: dmsl_domain_thrift:'DataRevision'(),
    'cart' :: dmsl_domain_thrift:'InvoiceCart'() | undefined,
    'additional_transaction_info' :: dmsl_domain_thrift:'AdditionalTransactionInfo'() | undefined,
    'external_id' :: binary() | undefined,
    'provider_id' :: dmsl_domain_thrift:'ProviderRef'() | undefined,
    'terminal_id' :: dmsl_domain_thrift:'TerminalRef'() | undefined,
    'allocation' :: dmsl_domain_thrift:'Allocation'() | undefined
}).

%% struct 'RecurrentParentPayment'
-record('merchstat_RecurrentParentPayment', {
    'invoice_id' :: dmsl_domain_thrift:'InvoiceID'(),
    'payment_id' :: dmsl_domain_thrift:'InvoicePaymentID'()
}).

%% struct 'RecurrentPayer'
-record('merchstat_RecurrentPayer', {
    'payment_tool' :: dmsl_merch_stat_thrift:'PaymentTool'(),
    'recurrent_parent' :: dmsl_merch_stat_thrift:'RecurrentParentPayment'(),
    'phone_number' :: binary() | undefined,
    'email' :: binary() | undefined
}).

%% struct 'PaymentResourcePayer'
-record('merchstat_PaymentResourcePayer', {
    'payment_tool' :: dmsl_merch_stat_thrift:'PaymentTool'(),
    'ip_address' :: dmsl_domain_thrift:'IPAddress'() | undefined,
    'fingerprint' :: dmsl_domain_thrift:'Fingerprint'() | undefined,
    'phone_number' :: binary() | undefined,
    'email' :: binary() | undefined,
    'session_id' :: dmsl_domain_thrift:'PaymentSessionID'() | undefined
}).

%% struct 'CustomerPayer'
-record('merchstat_CustomerPayer', {
    'customer_id' :: dmsl_domain_thrift:'CustomerID'(),
    'payment_tool' :: dmsl_merch_stat_thrift:'PaymentTool'(),
    'phone_number' :: binary() | undefined,
    'email' :: binary() | undefined
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
-record('merchstat_InvoicePaymentProcessed', {
    'at' :: dmsl_base_thrift:'Timestamp'() | undefined
}).

%% struct 'InvoicePaymentCaptured'
-record('merchstat_InvoicePaymentCaptured', {
    'at' :: dmsl_base_thrift:'Timestamp'() | undefined
}).

%% struct 'InvoicePaymentCancelled'
-record('merchstat_InvoicePaymentCancelled', {
    'at' :: dmsl_base_thrift:'Timestamp'() | undefined
}).

%% struct 'InvoicePaymentRefunded'
-record('merchstat_InvoicePaymentRefunded', {
    'at' :: dmsl_base_thrift:'Timestamp'() | undefined
}).

%% struct 'InvoicePaymentChargedBack'
-record('merchstat_InvoicePaymentChargedBack', {
    'at' :: dmsl_base_thrift:'Timestamp'() | undefined
}).

%% struct 'InvoicePaymentFailed'
-record('merchstat_InvoicePaymentFailed', {
    'failure' :: dmsl_merch_stat_thrift:'OperationFailure'(),
    'at' :: dmsl_base_thrift:'Timestamp'() | undefined
}).

%% struct 'MobileCommerce'
-record('merchstat_MobileCommerce', {
    'operator' :: dmsl_merch_stat_thrift:'MobileOperator'(),
    'phone' :: dmsl_merch_stat_thrift:'MobilePhone'()
}).

%% struct 'MobilePhone'
-record('merchstat_MobilePhone', {
    'cc' :: binary(),
    'ctn' :: binary()
}).

%% struct 'BankCard'
-record('merchstat_BankCard', {
    'token' :: dmsl_domain_thrift:'Token'(),
    'payment_system' :: dmsl_domain_thrift:'PaymentSystemRef'() | undefined,
    'bin' :: binary(),
    'masked_pan' :: binary(),
    'payment_token' :: dmsl_domain_thrift:'BankCardTokenServiceRef'() | undefined,
    'payment_system_deprecated' :: atom() | undefined,
    'token_provider_deprecated' :: atom() | undefined
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
    'cart' :: dmsl_domain_thrift:'InvoiceCart'() | undefined,
    'external_id' :: binary() | undefined,
    'allocation' :: dmsl_domain_thrift:'Allocation'() | undefined
}).

%% struct 'EnrichedStatInvoice'
-record('merchstat_EnrichedStatInvoice', {
    'invoice' :: dmsl_merch_stat_thrift:'StatInvoice'(),
    'payments' :: [dmsl_merch_stat_thrift:'StatPayment'()],
    'refunds' :: [dmsl_merch_stat_thrift:'StatRefund'()]
}).

%% struct 'InvoiceUnpaid'
-record('merchstat_InvoiceUnpaid', {}).

%% struct 'InvoicePaid'
-record('merchstat_InvoicePaid', {
    'at' :: dmsl_base_thrift:'Timestamp'() | undefined
}).

%% struct 'InvoiceCancelled'
-record('merchstat_InvoiceCancelled', {
    'details' :: binary(),
    'at' :: dmsl_base_thrift:'Timestamp'() | undefined
}).

%% struct 'InvoiceFulfilled'
-record('merchstat_InvoiceFulfilled', {
    'details' :: binary(),
    'at' :: dmsl_base_thrift:'Timestamp'() | undefined
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
    'payout_tool_info' :: dmsl_domain_thrift:'PayoutToolInfo'()
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
    'reason' :: binary() | undefined,
    'cart' :: dmsl_domain_thrift:'InvoiceCart'() | undefined,
    'external_id' :: binary() | undefined,
    'allocation' :: dmsl_domain_thrift:'Allocation'() | undefined
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

%% struct 'StatChargeback'
-record('merchstat_StatChargeback', {
    'invoice_id' :: dmsl_domain_thrift:'InvoiceID'(),
    'payment_id' :: dmsl_domain_thrift:'InvoicePaymentID'(),
    'chargeback_id' :: dmsl_domain_thrift:'InvoicePaymentChargebackID'(),
    'party_id' :: dmsl_domain_thrift:'PartyID'(),
    'shop_id' :: dmsl_domain_thrift:'ShopID'(),
    'chargeback_status' :: dmsl_domain_thrift:'InvoicePaymentChargebackStatus'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'chargeback_reason' :: dmsl_domain_thrift:'InvoicePaymentChargebackReason'() | undefined,
    'levy_amount' :: dmsl_domain_thrift:'Amount'(),
    'levy_currency_code' :: dmsl_domain_thrift:'Currency'(),
    'amount' :: dmsl_domain_thrift:'Amount'(),
    'currency_code' :: dmsl_domain_thrift:'Currency'(),
    'fee' :: dmsl_domain_thrift:'Amount'() | undefined,
    'provider_fee' :: dmsl_domain_thrift:'Amount'() | undefined,
    'external_fee' :: dmsl_domain_thrift:'Amount'() | undefined,
    'stage' :: dmsl_domain_thrift:'InvoicePaymentChargebackStage'() | undefined,
    'content' :: dmsl_base_thrift:'Content'() | undefined,
    'external_id' :: binary() | undefined
}).

%% struct 'StatRequest'
-record('merchstat_StatRequest', {
    'dsl' :: binary(),
    'continuation_token' :: binary() | undefined
}).

%% struct 'StatResponse'
-record('merchstat_StatResponse', {
    'data' :: dmsl_merch_stat_thrift:'StatResponseData'(),
    'total_count' :: integer() | undefined,
    'continuation_token' :: binary() | undefined
}).

%% exception 'BadToken'
-record('merchstat_BadToken', {
    'reason' :: binary()
}).

-endif.
