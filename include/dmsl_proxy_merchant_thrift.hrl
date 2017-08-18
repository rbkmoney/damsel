-ifndef(dmsl_proxy_merchant_thrift_included__).
-define(dmsl_proxy_merchant_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_proxy_thrift.hrl").
-include("dmsl_domain_thrift.hrl").



%% struct 'Context'
-record('prxmerch_Context', {
    'session' :: dmsl_proxy_merchant_thrift:'Session'(),
    'invoice' :: dmsl_proxy_merchant_thrift:'InvoiceInfo'(),
    'options' :: dmsl_domain_thrift:'ProxyOptions'()
}).

%% struct 'InvoiceInfo'
-record('prxmerch_InvoiceInfo', {
    'party' :: dmsl_proxy_merchant_thrift:'Party'(),
    'shop' :: dmsl_proxy_merchant_thrift:'Shop'(),
    'invoice' :: dmsl_proxy_merchant_thrift:'Invoice'()
}).

%% struct 'Party'
-record('prxmerch_Party', {
    'id' :: dmsl_domain_thrift:'PartyID'()
}).

%% struct 'Shop'
-record('prxmerch_Shop', {
    'id' :: dmsl_domain_thrift:'ShopID'(),
    'details' :: dmsl_domain_thrift:'ShopDetails'()
}).

%% struct 'Invoice'
-record('prxmerch_Invoice', {
    'id' :: dmsl_domain_thrift:'InvoiceID'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'due' :: dmsl_base_thrift:'Timestamp'(),
    'details' :: dmsl_domain_thrift:'InvoiceDetails'(),
    'cost' :: dmsl_proxy_merchant_thrift:'Cash'(),
    'context' :: dmsl_domain_thrift:'InvoiceContext'()
}).

%% struct 'Cash'
-record('prxmerch_Cash', {
    'amount' :: dmsl_domain_thrift:'Amount'(),
    'currency' :: dmsl_domain_thrift:'Currency'()
}).

%% struct 'Session'
-record('prxmerch_Session', {
    'event' :: dmsl_proxy_merchant_thrift:'InvoiceEvent'(),
    'state' :: dmsl_proxy_thrift:'ProxyState'() | undefined
}).

%% struct 'InvoiceStatusChanged'
-record('prxmerch_InvoiceStatusChanged', {
    'status' :: dmsl_proxy_merchant_thrift:'InvoiceStatus'()
}).

%% struct 'InvoicePaid'
-record('prxmerch_InvoicePaid', {}).

%% struct 'ProxyResult'
-record('prxmerch_ProxyResult', {
    'intent' :: dmsl_proxy_merchant_thrift:'Intent'(),
    'next_state' :: dmsl_proxy_thrift:'ProxyState'() | undefined
}).

%% struct 'FinishIntent'
-record('prxmerch_FinishIntent', {}).

%% struct 'SleepIntent'
-record('prxmerch_SleepIntent', {
    'timer' :: dmsl_base_thrift:'Timer'()
}).

-endif.
