-ifndef(dmsl_payment_tool_provider_thrift_included__).
-define(dmsl_payment_tool_provider_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_domain_thrift.hrl").



%% struct 'WrappedPaymentTool'
-record('paytoolprv_WrappedPaymentTool', {
    'request' :: dmsl_payment_tool_provider_thrift:'PaymentRequest'()
}).

%% struct 'ApplePayRequest'
-record('paytoolprv_ApplePayRequest', {
    'merchant_id' :: binary(),
    'payment_token' :: dmsl_base_thrift:'Content'()
}).

%% struct 'SamsungPayRequest'
-record('paytoolprv_SamsungPayRequest', {
    'service_id' :: binary(),
    'reference_id' :: binary()
}).

%% struct 'GooglePayRequest'
-record('paytoolprv_GooglePayRequest', {
    'gateway_merchant_id' :: binary(),
    'payment_token' :: dmsl_base_thrift:'Content'()
}).

%% struct 'YandexPayRequest'
-record('paytoolprv_YandexPayRequest', {
    'gateway_merchant_id' :: binary(),
    'payment_token' :: dmsl_base_thrift:'Content'()
}).

%% struct 'UnwrappedPaymentTool'
-record('paytoolprv_UnwrappedPaymentTool', {
    'card_info' :: dmsl_payment_tool_provider_thrift:'CardInfo'(),
    'payment_data' :: dmsl_payment_tool_provider_thrift:'CardPaymentData'(),
    'details' :: dmsl_payment_tool_provider_thrift:'PaymentDetails'(),
    'valid_until' :: dmsl_base_thrift:'Timestamp'() | undefined
}).

%% struct 'ApplePayDetails'
-record('paytoolprv_ApplePayDetails', {
    'transaction_id' :: binary(),
    'amount' :: dmsl_domain_thrift:'Amount'(),
    'currency_numeric_code' :: integer(),
    'device_id' :: binary()
}).

%% struct 'SamsungPayDetails'
-record('paytoolprv_SamsungPayDetails', {
    'device_id' :: binary() | undefined
}).

%% struct 'GooglePayDetails'
-record('paytoolprv_GooglePayDetails', {
    'message_id' :: binary(),
    'message_expiration' :: dmsl_base_thrift:'Timestamp'()
}).

%% struct 'YandexPayDetails'
-record('paytoolprv_YandexPayDetails', {
    'message_id' :: binary(),
    'message_expiration' :: dmsl_base_thrift:'Timestamp'()
}).

%% struct 'CardInfo'
-record('paytoolprv_CardInfo', {
    'display_name' :: binary() | undefined,
    'cardholder_name' :: binary() | undefined,
    'last_4_digits' :: binary() | undefined,
    'card_class' :: dmsl_payment_tool_provider_thrift:'CardClass'() | undefined,
    'payment_system' :: atom() | undefined
}).

%% struct 'TokenizedCard'
-record('paytoolprv_TokenizedCard', {
    'dpan' :: binary(),
    'exp_date' :: dmsl_payment_tool_provider_thrift:'ExpDate'(),
    'auth_data' :: dmsl_payment_tool_provider_thrift:'AuthData'()
}).

%% struct 'Card'
-record('paytoolprv_Card', {
    'pan' :: binary(),
    'exp_date' :: dmsl_payment_tool_provider_thrift:'ExpDate'()
}).

%% struct 'ExpDate'
-record('paytoolprv_ExpDate', {
    'month' :: integer(),
    'year' :: integer()
}).

%% struct 'Auth3DS'
-record('paytoolprv_Auth3DS', {
    'cryptogram' :: binary(),
    'eci' :: binary() | undefined
}).

-endif.
