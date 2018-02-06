-ifndef(dmsl_payment_processing_errors_thrift_included__).
-define(dmsl_payment_processing_errors_thrift_included__, yeah).



%% struct 'RejectedByInspector'
-record('RejectedByInspector', {}).

%% struct 'PreauthorizationFailed'
-record('PreauthorizationFailed', {}).

%% struct 'SilentReject'
-record('SilentReject', {}).

%% struct 'MerchantBlocked'
-record('MerchantBlocked', {}).

%% struct 'OperationDisabled'
-record('OperationDisabled', {}).

%% struct 'AccountNotFound'
-record('AccountNotFound', {}).

%% struct 'AccountBlocked'
-record('AccountBlocked', {}).

%% struct 'AccountStolen'
-record('AccountStolen', {}).

%% struct 'InsufficientFunds'
-record('InsufficientFunds', {}).

%% struct 'Onetime'
-record('Onetime', {}).

%% struct 'Daily'
-record('Daily', {}).

%% struct 'Weekly'
-record('Weekly', {}).

%% struct 'Monthly'
-record('Monthly', {}).

%% struct 'InvalidCardNumber'
-record('InvalidCardNumber', {}).

%% struct 'ExpiredCard'
-record('ExpiredCard', {}).

%% struct 'InvalidCardHolder'
-record('InvalidCardHolder', {}).

%% struct 'InvalidCVV'
-record('InvalidCVV', {}).

%% struct 'CardUnsupported'
-record('CardUnsupported', {}).

%% struct 'IssuerNotFound'
-record('IssuerNotFound', {}).

%% struct 'RestictedCard'
-record('RestictedCard', {}).

-endif.
