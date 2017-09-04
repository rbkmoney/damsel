-ifndef(dmsl_proxy_preauth_thrift_included__).
-define(dmsl_proxy_preauth_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_proxy_thrift.hrl").
-include("dmsl_domain_thrift.hrl").
-include("dmsl_preauth_thrift.hrl").



%% struct 'Context'
-record('proxy_preauth_Context', {
    'session' :: dmsl_proxy_preauth_thrift:'Session'(),
    'payment' :: dmsl_proxy_preauth_thrift:'PaymentInfo'(),
    'options' = #{} :: dmsl_domain_thrift:'ProxyOptions'() | undefined
}).

%% struct 'Session'
-record('proxy_preauth_Session', {
    'state' :: dmsl_proxy_thrift:'ProxyState'() | undefined
}).

%% struct 'PaymentInfo'
-record('proxy_preauth_PaymentInfo', {
    'shop' :: dmsl_proxy_preauth_thrift:'Shop'(),
    'invoice' :: dmsl_proxy_preauth_thrift:'Invoice'(),
    'payment' :: dmsl_proxy_preauth_thrift:'InvoicePayment'()
}).

%% struct 'Shop'
-record('proxy_preauth_Shop', {
    'id' :: dmsl_domain_thrift:'ShopID'(),
    'category' :: dmsl_domain_thrift:'Category'(),
    'details' :: dmsl_domain_thrift:'ShopDetails'()
}).

%% struct 'Invoice'
-record('proxy_preauth_Invoice', {
    'id' :: dmsl_domain_thrift:'InvoiceID'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'product' :: binary(),
    'description' :: binary() | undefined,
    'cost' :: dmsl_domain_thrift:'Cash'()
}).

%% struct 'InvoicePayment'
-record('proxy_preauth_InvoicePayment', {
    'id' :: dmsl_domain_thrift:'InvoicePaymentID'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'payer' :: dmsl_domain_thrift:'Payer'(),
    'cost' :: dmsl_domain_thrift:'Cash'()
}).

%% struct 'Binding'
-record('proxy_preauth_Binding', {
    'id' :: binary(),
    'timestamp' :: dmsl_base_thrift:'Timestamp'() | undefined,
    'extra' = #{} :: dmsl_base_thrift:'StringMap'()
}).

%% struct 'FinishIntent'
-record('proxy_preauth_FinishIntent', {
    'status' :: dmsl_proxy_preauth_thrift:'FinishStatus'()
}).

%% struct 'ProxyResult'
-record('proxy_preauth_ProxyResult', {
    'intent' :: dmsl_proxy_preauth_thrift:'Intent'(),
    'next_state' :: dmsl_proxy_thrift:'ProxyState'() | undefined,
    'binding' :: dmsl_proxy_preauth_thrift:'Binding'() | undefined
}).

%% struct 'CallbackResult'
-record('proxy_preauth_CallbackResult', {
    'response' :: dmsl_proxy_thrift:'CallbackResponse'(),
    'result' :: dmsl_proxy_preauth_thrift:'ProxyResult'()
}).

-endif.
