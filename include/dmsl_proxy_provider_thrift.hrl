-ifndef(dmsl_proxy_provider_thrift_included__).
-define(dmsl_proxy_provider_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_domain_thrift.hrl").
-include("dmsl_user_interaction_thrift.hrl").



%% struct 'FinishIntent'
-record('prxprv_FinishIntent', {
    'status' :: dmsl_proxy_provider_thrift:'FinishStatus'()
}).

%% struct 'Success'
-record('prxprv_Success', {
    'token' :: dmsl_domain_thrift:'Token'() | undefined
}).

%% struct 'SleepIntent'
-record('prxprv_SleepIntent', {
    'timer' :: dmsl_base_thrift:'Timer'(),
    'user_interaction' :: dmsl_user_interaction_thrift:'UserInteraction'() | undefined
}).

%% struct 'SuspendIntent'
-record('prxprv_SuspendIntent', {
    'tag' :: dmsl_proxy_provider_thrift:'CallbackTag'(),
    'timeout' :: dmsl_base_thrift:'Timer'(),
    'user_interaction' :: dmsl_user_interaction_thrift:'UserInteraction'() | undefined
}).

%% struct 'RecurrentPaymentTool'
-record('prxprv_RecurrentPaymentTool', {
    'id' :: dmsl_base_thrift:'ID'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'payment_resource' :: dmsl_domain_thrift:'DisposablePaymentResource'(),
    'minimal_payment_cost' :: dmsl_proxy_provider_thrift:'Cash'()
}).

%% struct 'RecurrentTokenInfo'
-record('prxprv_RecurrentTokenInfo', {
    'payment_tool' :: dmsl_proxy_provider_thrift:'RecurrentPaymentTool'(),
    'trx' :: dmsl_domain_thrift:'TransactionInfo'() | undefined
}).

%% struct 'RecurrentTokenSession'
-record('prxprv_RecurrentTokenSession', {
    'state' :: dmsl_proxy_provider_thrift:'ProxyState'() | undefined
}).

%% struct 'RecurrentTokenContext'
-record('prxprv_RecurrentTokenContext', {
    'session' :: dmsl_proxy_provider_thrift:'RecurrentTokenSession'(),
    'token_info' :: dmsl_proxy_provider_thrift:'RecurrentTokenInfo'(),
    'options' = #{} :: dmsl_domain_thrift:'ProxyOptions'() | undefined
}).

%% struct 'RecurrentTokenProxyResult'
-record('prxprv_RecurrentTokenProxyResult', {
    'intent' :: dmsl_proxy_provider_thrift:'RecurrentTokenIntent'(),
    'next_state' :: dmsl_proxy_provider_thrift:'ProxyState'() | undefined,
    'trx' :: dmsl_domain_thrift:'TransactionInfo'() | undefined
}).

%% struct 'RecurrentTokenFinishIntent'
-record('prxprv_RecurrentTokenFinishIntent', {
    'status' :: dmsl_proxy_provider_thrift:'RecurrentTokenFinishStatus'()
}).

%% struct 'RecurrentTokenSuccess'
-record('prxprv_RecurrentTokenSuccess', {
    'token' :: dmsl_domain_thrift:'Token'()
}).

%% struct 'RecurrentTokenCallbackResult'
-record('prxprv_RecurrentTokenCallbackResult', {
    'response' :: dmsl_proxy_provider_thrift:'CallbackResponse'(),
    'result' :: dmsl_proxy_provider_thrift:'RecurrentTokenProxyResult'()
}).

%% struct 'PaymentInfo'
-record('prxprv_PaymentInfo', {
    'shop' :: dmsl_proxy_provider_thrift:'Shop'(),
    'invoice' :: dmsl_proxy_provider_thrift:'Invoice'(),
    'payment' :: dmsl_proxy_provider_thrift:'InvoicePayment'(),
    'refund' :: dmsl_proxy_provider_thrift:'InvoicePaymentRefund'() | undefined,
    'capture' :: dmsl_proxy_provider_thrift:'InvoicePaymentCapture'() | undefined
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

%% struct 'RecurrentPaymentResource'
-record('prxprv_RecurrentPaymentResource', {
    'payment_tool' :: dmsl_domain_thrift:'PaymentTool'(),
    'rec_token' :: dmsl_domain_thrift:'Token'()
}).

%% struct 'InvoicePayment'
-record('prxprv_InvoicePayment', {
    'id' :: dmsl_domain_thrift:'InvoicePaymentID'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'trx' :: dmsl_domain_thrift:'TransactionInfo'() | undefined,
    'payment_resource' :: dmsl_proxy_provider_thrift:'PaymentResource'(),
    'cost' :: dmsl_proxy_provider_thrift:'Cash'(),
    'contact_info' :: dmsl_domain_thrift:'ContactInfo'(),
    'make_recurrent' :: boolean() | undefined
}).

%% struct 'InvoicePaymentRefund'
-record('prxprv_InvoicePaymentRefund', {
    'id' :: dmsl_domain_thrift:'InvoicePaymentRefundID'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'cash' :: dmsl_proxy_provider_thrift:'Cash'(),
    'trx' :: dmsl_domain_thrift:'TransactionInfo'() | undefined
}).

%% struct 'InvoicePaymentCapture'
-record('prxprv_InvoicePaymentCapture', {
    'cost' :: dmsl_proxy_provider_thrift:'Cash'()
}).

%% struct 'Cash'
-record('prxprv_Cash', {
    'amount' :: dmsl_domain_thrift:'Amount'(),
    'currency' :: dmsl_domain_thrift:'Currency'()
}).

%% struct 'Session'
-record('prxprv_Session', {
    'target' :: dmsl_domain_thrift:'TargetInvoicePaymentStatus'(),
    'state' :: dmsl_proxy_provider_thrift:'ProxyState'() | undefined
}).

%% struct 'PaymentContext'
-record('prxprv_PaymentContext', {
    'session' :: dmsl_proxy_provider_thrift:'Session'(),
    'payment_info' :: dmsl_proxy_provider_thrift:'PaymentInfo'(),
    'options' = #{} :: dmsl_domain_thrift:'ProxyOptions'() | undefined
}).

%% struct 'PaymentProxyResult'
-record('prxprv_PaymentProxyResult', {
    'intent' :: dmsl_proxy_provider_thrift:'Intent'(),
    'next_state' :: dmsl_proxy_provider_thrift:'ProxyState'() | undefined,
    'trx' :: dmsl_domain_thrift:'TransactionInfo'() | undefined
}).

%% struct 'PaymentCallbackResult'
-record('prxprv_PaymentCallbackResult', {
    'response' :: dmsl_proxy_provider_thrift:'CallbackResponse'(),
    'result' :: dmsl_proxy_provider_thrift:'PaymentCallbackProxyResult'()
}).

%% struct 'PaymentCallbackProxyResult'
-record('prxprv_PaymentCallbackProxyResult', {
    'intent' :: dmsl_proxy_provider_thrift:'Intent'() | undefined,
    'next_state' :: dmsl_proxy_provider_thrift:'ProxyState'() | undefined,
    'trx' :: dmsl_domain_thrift:'TransactionInfo'() | undefined
}).

%% exception 'PaymentNotFound'
-record('prxprv_PaymentNotFound', {}).

-endif.
