-ifndef(dmsl_errors_thrift_included__).
-define(dmsl_errors_thrift_included__, yeah).



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

%% struct 'SingleOperationLimitExceeded'
-record('SingleOperationLimitExceeded', {}).

%% struct 'DailyLimitExceeded'
-record('DailyLimitExceeded', {}).

%% struct 'WeeklyLimitExceeded'
-record('WeeklyLimitExceeded', {}).

%% struct 'MonthlyLimitExceeded'
-record('MonthlyLimitExceeded', {}).

%% struct 'AttemptsNumberLimitExceeded'
-record('AttemptsNumberLimitExceeded', {}).

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
