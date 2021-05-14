-ifndef(dmsl_cash_flow_thrift_included__).
-define(dmsl_cash_flow_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_domain_thrift.hrl").



%% struct 'CashFlow'
-record('cash_flow_CashFlow', {
    'transactions' :: [dmsl_cash_flow_thrift:'CashFlowTransaction'()]
}).

%% struct 'CashFlowTransaction'
-record('cash_flow_CashFlowTransaction', {
    'source' :: dmsl_cash_flow_thrift:'CashFlowTransactionAccount'(),
    'destination' :: dmsl_cash_flow_thrift:'CashFlowTransactionAccount'(),
    'volume' :: dmsl_domain_thrift:'Cash'(),
    'details' :: binary() | undefined
}).

%% struct 'CashFlowTransactionAccount'
-record('cash_flow_CashFlowTransactionAccount', {
    'transaction_account' :: dmsl_cash_flow_thrift:'TransactionAccount'(),
    'account_id' :: dmsl_cash_flow_thrift:'AccountID'()
}).

%% struct 'MerchantTransactionAccount'
-record('cash_flow_MerchantTransactionAccount', {
    'account_type' :: dmsl_cash_flow_thrift:'MerchantCashFlowAccount'(),
    'account_owner' :: dmsl_cash_flow_thrift:'MerchantTransactionAccountOwner'()
}).

%% struct 'MerchantTransactionAccountOwner'
-record('cash_flow_MerchantTransactionAccountOwner', {
    'party_id' :: dmsl_domain_thrift:'PartyID'(),
    'shop_id' :: dmsl_domain_thrift:'ShopID'()
}).

%% struct 'ProviderTransactionAccount'
-record('cash_flow_ProviderTransactionAccount', {
    'account_type' :: dmsl_cash_flow_thrift:'ProviderCashFlowAccount'(),
    'account_owner' :: dmsl_cash_flow_thrift:'ProviderTransactionAccountOwner'()
}).

%% struct 'ProviderTransactionAccountOwner'
-record('cash_flow_ProviderTransactionAccountOwner', {
    'provider_ref' :: dmsl_domain_thrift:'ProviderRef'(),
    'terminal_ref' :: dmsl_domain_thrift:'ProviderTerminalRef'()
}).

%% struct 'SystemTransactionAccount'
-record('cash_flow_SystemTransactionAccount', {
    'account_type' :: dmsl_cash_flow_thrift:'SystemCashFlowAccount'()
}).

%% struct 'ExternalTransactionAccount'
-record('cash_flow_ExternalTransactionAccount', {
    'account_type' :: dmsl_cash_flow_thrift:'ExternalCashFlowAccount'()
}).

-endif.
