-ifndef(dmsl_webhooker_thrift_included__).
-define(dmsl_webhooker_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_domain_thrift.hrl").



%% struct 'Webhook'
-record('webhooker_Webhook', {
    'id' :: dmsl_webhooker_thrift:'WebhookID'(),
    'party_id' :: dmsl_domain_thrift:'PartyID'(),
    'event_filter' :: dmsl_webhooker_thrift:'EventFilter'(),
    'url' :: dmsl_webhooker_thrift:'Url'(),
    'pub_key' :: dmsl_webhooker_thrift:'Key'(),
    'enabled' :: boolean()
}).

%% struct 'WebhookParams'
-record('webhooker_WebhookParams', {
    'party_id' :: dmsl_domain_thrift:'PartyID'(),
    'event_filter' :: dmsl_webhooker_thrift:'EventFilter'(),
    'url' :: dmsl_webhooker_thrift:'Url'()
}).

%% struct 'PartyEventFilter'
-record('webhooker_PartyEventFilter', {
    'types' :: ordsets:ordset(dmsl_webhooker_thrift:'PartyEventType'())
}).

%% struct 'ClaimCreated'
-record('webhooker_ClaimCreated', {}).

%% struct 'ClaimDenied'
-record('webhooker_ClaimDenied', {}).

%% struct 'ClaimAccepted'
-record('webhooker_ClaimAccepted', {}).

%% struct 'InvoiceEventFilter'
-record('webhooker_InvoiceEventFilter', {
    'types' :: ordsets:ordset(dmsl_webhooker_thrift:'InvoiceEventType'()),
    'shop_id' :: dmsl_domain_thrift:'ShopID'() | undefined
}).

%% struct 'InvoiceCreated'
-record('webhooker_InvoiceCreated', {}).

%% struct 'InvoiceStatusChanged'
-record('webhooker_InvoiceStatusChanged', {
    'value' :: dmsl_webhooker_thrift:'InvoiceStatus'() | undefined
}).

%% struct 'InvoiceUnpaid'
-record('webhooker_InvoiceUnpaid', {}).

%% struct 'InvoicePaid'
-record('webhooker_InvoicePaid', {}).

%% struct 'InvoiceCancelled'
-record('webhooker_InvoiceCancelled', {}).

%% struct 'InvoiceFulfilled'
-record('webhooker_InvoiceFulfilled', {}).

%% struct 'InvoicePaymentCreated'
-record('webhooker_InvoicePaymentCreated', {}).

%% struct 'InvoicePaymentStatusChanged'
-record('webhooker_InvoicePaymentStatusChanged', {
    'value' :: dmsl_webhooker_thrift:'InvoicePaymentStatus'() | undefined
}).

%% struct 'InvoicePaymentRefundCreated'
-record('webhooker_InvoicePaymentRefundCreated', {}).

%% struct 'InvoicePaymentRefundStatusChanged'
-record('webhooker_InvoicePaymentRefundStatusChanged', {
    'value' :: dmsl_webhooker_thrift:'InvoicePaymentRefundStatus'()
}).

%% struct 'InvoicePaymentPending'
-record('webhooker_InvoicePaymentPending', {}).

%% struct 'InvoicePaymentProcessed'
-record('webhooker_InvoicePaymentProcessed', {}).

%% struct 'InvoicePaymentCaptured'
-record('webhooker_InvoicePaymentCaptured', {}).

%% struct 'InvoicePaymentCancelled'
-record('webhooker_InvoicePaymentCancelled', {}).

%% struct 'InvoicePaymentFailed'
-record('webhooker_InvoicePaymentFailed', {}).

%% struct 'InvoicePaymentRefunded'
-record('webhooker_InvoicePaymentRefunded', {}).

%% struct 'InvoicePaymentRefundPending'
-record('webhooker_InvoicePaymentRefundPending', {}).

%% struct 'InvoicePaymentRefundSucceeded'
-record('webhooker_InvoicePaymentRefundSucceeded', {}).

%% struct 'InvoicePaymentRefundFailed'
-record('webhooker_InvoicePaymentRefundFailed', {}).

%% struct 'CustomerEventFilter'
-record('webhooker_CustomerEventFilter', {
    'types' :: ordsets:ordset(dmsl_webhooker_thrift:'CustomerEventType'()),
    'shop_id' :: dmsl_domain_thrift:'ShopID'() | undefined
}).

%% struct 'CustomerCreated'
-record('webhooker_CustomerCreated', {}).

%% struct 'CustomerDeleted'
-record('webhooker_CustomerDeleted', {}).

%% struct 'CustomerStatusReady'
-record('webhooker_CustomerStatusReady', {}).

%% struct 'CustomerBindingStarted'
-record('webhooker_CustomerBindingStarted', {}).

%% struct 'CustomerBindingSucceeded'
-record('webhooker_CustomerBindingSucceeded', {}).

%% struct 'CustomerBindingFailed'
-record('webhooker_CustomerBindingFailed', {}).

%% struct 'WalletEventFilter'
-record('webhooker_WalletEventFilter', {
    'types' :: ordsets:ordset(dmsl_webhooker_thrift:'WalletEventType'())
}).

%% struct 'WalletWithdrawalStarted'
-record('webhooker_WalletWithdrawalStarted', {}).

%% struct 'WalletWithdrawalSucceeded'
-record('webhooker_WalletWithdrawalSucceeded', {}).

%% struct 'WalletWithdrawalFailed'
-record('webhooker_WalletWithdrawalFailed', {}).

%% exception 'WebhookNotFound'
-record('webhooker_WebhookNotFound', {}).

%% exception 'LimitExceeded'
-record('webhooker_LimitExceeded', {}).

-endif.
