-ifndef(dmsl_user_interaction_thrift_included__).
-define(dmsl_user_interaction_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").



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

-endif.