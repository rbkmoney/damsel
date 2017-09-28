-ifndef(dmsl_proxy_provider_thrift_included__).
-define(dmsl_proxy_provider_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_proxy_thrift.hrl").
-include("dmsl_domain_thrift.hrl").



%% struct 'PaymentInfo'
-record('prxprv_PaymentInfo', {
    'shop' :: dmsl_proxy_provider_thrift:'Shop'(),
    'invoice' :: dmsl_proxy_provider_thrift:'Invoice'(),
    'payment' :: dmsl_proxy_provider_thrift:'InvoicePayment'(),
    'refund' :: dmsl_proxy_provider_thrift:'InvoicePaymentRefund'() | undefined
}).

%% struct 'Shop'
-record('prxprv_Shop', {
    'id' :: dmsl_domain_thrift:'ShopID'(),
    'category' :: dmsl_domain_thrift:'Category'(),
    'details' :: dmsl_domain_thrift:'ShopDetails'(),
    'location' :: dmsl_domain_thrift:'ShopLocation'()
}).

%% struct 'Invoice'
-record('prxprv_Invoice', {
    'id' :: dmsl_domain_thrift:'InvoiceID'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'due' :: dmsl_base_thrift:'Timestamp'(),
    'details' :: dmsl_domain_thrift:'InvoiceDetails'(),
    'cost' :: dmsl_proxy_provider_thrift:'Cash'()
}).

%% struct 'InvoicePayment'
-record('prxprv_InvoicePayment', {
    'id' :: dmsl_domain_thrift:'InvoicePaymentID'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'trx' :: dmsl_domain_thrift:'TransactionInfo'() | undefined,
    'payer' :: dmsl_domain_thrift:'Payer'(),
    'cost' :: dmsl_proxy_provider_thrift:'Cash'()
}).

%% struct 'InvoicePaymentRefund'
-record('prxprv_InvoicePaymentRefund', {
    'id' :: dmsl_domain_thrift:'InvoicePaymentRefundID'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'trx' :: dmsl_domain_thrift:'TransactionInfo'() | undefined
}).

%% struct 'Cash'
-record('prxprv_Cash', {
    'amount' :: dmsl_domain_thrift:'Amount'(),
    'currency' :: dmsl_domain_thrift:'Currency'()
}).

%% struct 'Session'
-record('prxprv_Session', {
    'target' :: dmsl_domain_thrift:'TargetInvoicePaymentStatus'(),
    'state' :: dmsl_proxy_thrift:'ProxyState'() | undefined
}).

%% struct 'Context'
-record('prxprv_Context', {
    'session' :: dmsl_proxy_provider_thrift:'Session'(),
    'payment_info' :: dmsl_proxy_provider_thrift:'PaymentInfo'(),
    'options' = #{} :: dmsl_domain_thrift:'ProxyOptions'() | undefined
}).

%% struct 'ProxyResult'
-record('prxprv_ProxyResult', {
    'intent' :: dmsl_proxy_thrift:'Intent'(),
    'next_state' :: dmsl_proxy_thrift:'ProxyState'() | undefined,
    'trx' :: dmsl_domain_thrift:'TransactionInfo'() | undefined
}).

%% struct 'CallbackResult'
-record('prxprv_CallbackResult', {
    'response' :: dmsl_proxy_thrift:'CallbackResponse'(),
    'result' :: dmsl_proxy_provider_thrift:'CallbackProxyResult'()
}).

%% struct 'CallbackProxyResult'
-record('prxprv_CallbackProxyResult', {
    'intent' :: dmsl_proxy_thrift:'Intent'() | undefined,
    'next_state' :: dmsl_proxy_thrift:'ProxyState'() | undefined,
    'trx' :: dmsl_domain_thrift:'TransactionInfo'() | undefined
}).

%% exception 'PaymentNotFound'
-record('prxprv_PaymentNotFound', {}).

-endif.
