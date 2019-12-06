-ifndef(dmsl_user_interaction_thrift_included__).
-define(dmsl_user_interaction_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").



%% struct 'QrCode'
-record('QrCode', {
    'payload' :: binary()
}).

%% struct 'CryptoCash'
-record('CryptoCash', {
    'crypto_amount' :: dmsl_base_thrift:'Rational'(),
    'crypto_symbolic_code' :: dmsl_user_interaction_thrift:'CryptoCurrencySymbolicCode'()
}).

%% struct 'BrowserGetRequest'
-record('BrowserGetRequest', {
    'uri' :: dmsl_user_interaction_thrift:'Template'()
}).

%% struct 'BrowserPostRequest'
-record('BrowserPostRequest', {
    'uri' :: dmsl_user_interaction_thrift:'Template'(),
    'form' :: dmsl_user_interaction_thrift:'Form'()
}).

%% struct 'PaymentTerminalReceipt'
-record('PaymentTerminalReceipt', {
    'short_payment_id' :: binary(),
    'due' :: dmsl_base_thrift:'Timestamp'()
}).

%% struct 'CryptoCurrencyTransferRequest'
-record('CryptoCurrencyTransferRequest', {
    'crypto_address' :: dmsl_user_interaction_thrift:'CryptoAddress'(),
    'crypto_cash' :: dmsl_user_interaction_thrift:'CryptoCash'()
}).

%% struct 'QrCodeDisplayRequest'
-record('QrCodeDisplayRequest', {
    'qr_code' :: dmsl_user_interaction_thrift:'QrCode'()
}).

-endif.
