-ifndef(dmsl_proxy_inspector_thrift_included__).
-define(dmsl_proxy_inspector_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_domain_thrift.hrl").



%% struct 'Context'
-record('proxy_inspector_Context', {
    'payment' :: dmsl_proxy_inspector_thrift:'PaymentInfo'(),
    'options' = #{} :: dmsl_domain_thrift:'ProxyOptions'() | undefined
}).

%% struct 'PaymentInfo'
-record('proxy_inspector_PaymentInfo', {
    'shop' :: dmsl_proxy_inspector_thrift:'Shop'(),
    'payment' :: dmsl_proxy_inspector_thrift:'InvoicePayment'(),
    'invoice' :: dmsl_proxy_inspector_thrift:'Invoice'(),
    'party' :: dmsl_proxy_inspector_thrift:'Party'()
}).

%% struct 'Party'
-record('proxy_inspector_Party', {
    'party_id' :: dmsl_domain_thrift:'PartyID'()
}).

%% struct 'Shop'
-record('proxy_inspector_Shop', {
    'id' :: dmsl_domain_thrift:'ShopID'(),
    'category' :: dmsl_domain_thrift:'Category'(),
    'details' :: dmsl_domain_thrift:'ShopDetails'(),
    'location' :: dmsl_domain_thrift:'ShopLocation'()
}).

%% struct 'InvoicePayment'
-record('proxy_inspector_InvoicePayment', {
    'id' :: dmsl_domain_thrift:'InvoicePaymentID'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'payer' :: dmsl_domain_thrift:'Payer'(),
    'cost' :: dmsl_domain_thrift:'Cash'(),
    'make_recurrent' :: boolean() | undefined
}).

%% struct 'Invoice'
-record('proxy_inspector_Invoice', {
    'id' :: dmsl_domain_thrift:'InvoiceID'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'due' :: dmsl_base_thrift:'Timestamp'(),
    'details' :: dmsl_domain_thrift:'InvoiceDetails'(),
    'client_info' :: dmsl_domain_thrift:'InvoiceClientInfo'() | undefined
}).

-endif.
