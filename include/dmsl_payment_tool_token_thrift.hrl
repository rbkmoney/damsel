-ifndef(dmsl_payment_tool_token_thrift_included__).
-define(dmsl_payment_tool_token_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_domain_thrift.hrl").



%% struct 'PaymentToolToken'
-record('ptt_PaymentToolToken', {
    'payload' :: dmsl_payment_tool_token_thrift:'PaymentToolTokenPayload'(),
    'valid_until' :: dmsl_base_thrift:'Timestamp'() | undefined
}).

%% struct 'BankCardPayload'
-record('ptt_BankCardPayload', {
    'bank_card' :: dmsl_domain_thrift:'BankCard'()
}).

%% struct 'PaymentTerminalPayload'
-record('ptt_PaymentTerminalPayload', {
    'payment_terminal' :: dmsl_domain_thrift:'PaymentTerminal'()
}).

%% struct 'DigitalWalletPayload'
-record('ptt_DigitalWalletPayload', {
    'digital_wallet' :: dmsl_domain_thrift:'DigitalWallet'()
}).

%% struct 'CryptoCurrencyPayload'
-record('ptt_CryptoCurrencyPayload', {
    'crypto_currency' :: atom()
}).

%% struct 'MobileCommercePayload'
-record('ptt_MobileCommercePayload', {
    'mobile_commerce' :: dmsl_domain_thrift:'MobileCommerce'()
}).

-endif.
