-ifndef(dmsl_domain_thrift_included__).
-define(dmsl_domain_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_msgpack_thrift.hrl").



%% struct 'ContactInfo'
-record('domain_ContactInfo', {
    'phone_number' :: binary() | undefined,
    'email' :: binary() | undefined
}).

%% struct 'OperationTimeout'
-record('domain_OperationTimeout', {}).

%% struct 'ExternalFailure'
-record('domain_ExternalFailure', {
    'code' :: binary(),
    'description' :: binary() | undefined
}).

%% struct 'Cash'
-record('domain_Cash', {
    'amount' :: dmsl_domain_thrift:'Amount'(),
    'currency' :: dmsl_domain_thrift:'CurrencyRef'()
}).

%% struct 'TransactionInfo'
-record('domain_TransactionInfo', {
    'id' :: binary(),
    'timestamp' :: dmsl_base_thrift:'Timestamp'() | undefined,
    'extra' :: dmsl_base_thrift:'StringMap'()
}).

%% struct 'Invoice'
-record('domain_Invoice', {
    'id' :: dmsl_domain_thrift:'InvoiceID'(),
    'owner_id' :: dmsl_domain_thrift:'PartyID'(),
    'shop_id' :: dmsl_domain_thrift:'ShopID'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'status' :: dmsl_domain_thrift:'InvoiceStatus'(),
    'details' :: dmsl_domain_thrift:'InvoiceDetails'(),
    'due' :: dmsl_base_thrift:'Timestamp'(),
    'cost' :: dmsl_domain_thrift:'Cash'(),
    'context' :: dmsl_domain_thrift:'InvoiceContext'() | undefined,
    'template_id' :: dmsl_domain_thrift:'InvoiceTemplateID'() | undefined
}).

%% struct 'InvoiceDetails'
-record('domain_InvoiceDetails', {
    'product' :: binary(),
    'description' :: binary() | undefined,
    'cart' :: dmsl_domain_thrift:'InvoiceCart'() | undefined
}).

%% struct 'InvoiceCart'
-record('domain_InvoiceCart', {
    'lines' :: [dmsl_domain_thrift:'InvoiceLine'()]
}).

%% struct 'InvoiceLine'
-record('domain_InvoiceLine', {
    'product' :: binary(),
    'quantity' :: integer(),
    'price' :: dmsl_domain_thrift:'Cash'(),
    'metadata' :: #{binary() => dmsl_msgpack_thrift:'Value'()}
}).

%% struct 'InvoiceUnpaid'
-record('domain_InvoiceUnpaid', {}).

%% struct 'InvoicePaid'
-record('domain_InvoicePaid', {}).

%% struct 'InvoiceCancelled'
-record('domain_InvoiceCancelled', {
    'details' :: binary()
}).

%% struct 'InvoiceFulfilled'
-record('domain_InvoiceFulfilled', {
    'details' :: binary()
}).

%% struct 'InvoicePayment'
-record('domain_InvoicePayment', {
    'id' :: dmsl_domain_thrift:'InvoicePaymentID'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'domain_revision' :: dmsl_domain_thrift:'DataRevision'(),
    'status' :: dmsl_domain_thrift:'InvoicePaymentStatus'(),
    'payer' :: dmsl_domain_thrift:'Payer'(),
    'cost' :: dmsl_domain_thrift:'Cash'(),
    'context' :: dmsl_domain_thrift:'InvoicePaymentContext'() | undefined
}).

%% struct 'InvoicePaymentPending'
-record('domain_InvoicePaymentPending', {}).

%% struct 'InvoicePaymentProcessed'
-record('domain_InvoicePaymentProcessed', {}).

%% struct 'InvoicePaymentCaptured'
-record('domain_InvoicePaymentCaptured', {}).

%% struct 'InvoicePaymentCancelled'
-record('domain_InvoicePaymentCancelled', {}).

%% struct 'InvoicePaymentFailed'
-record('domain_InvoicePaymentFailed', {
    'failure' :: dmsl_domain_thrift:'OperationFailure'()
}).

%% struct 'InvoiceTemplate'
-record('domain_InvoiceTemplate', {
    'id' :: dmsl_domain_thrift:'InvoiceTemplateID'(),
    'owner_id' :: dmsl_domain_thrift:'PartyID'(),
    'shop_id' :: dmsl_domain_thrift:'ShopID'(),
    'details' :: dmsl_domain_thrift:'InvoiceDetails'(),
    'invoice_lifetime' :: dmsl_domain_thrift:'LifetimeInterval'(),
    'cost' :: dmsl_domain_thrift:'InvoiceTemplateCost'(),
    'context' :: dmsl_domain_thrift:'InvoiceContext'() | undefined
}).

%% struct 'InvoiceTemplateCostUnlimited'
-record('domain_InvoiceTemplateCostUnlimited', {}).

%% struct 'Payer'
-record('domain_Payer', {
    'payment_tool' :: dmsl_domain_thrift:'PaymentTool'(),
    'session_id' :: dmsl_domain_thrift:'PaymentSessionID'(),
    'client_info' :: dmsl_domain_thrift:'ClientInfo'(),
    'contact_info' :: dmsl_domain_thrift:'ContactInfo'()
}).

%% struct 'ClientInfo'
-record('domain_ClientInfo', {
    'ip_address' :: dmsl_domain_thrift:'IPAddress'() | undefined,
    'fingerprint' :: dmsl_domain_thrift:'Fingerprint'() | undefined
}).

%% struct 'InvoicePaymentRoute'
-record('domain_InvoicePaymentRoute', {
    'provider' :: dmsl_domain_thrift:'ProviderRef'(),
    'terminal' :: dmsl_domain_thrift:'TerminalRef'()
}).

%% struct 'InvoicePaymentAdjustment'
-record('domain_InvoicePaymentAdjustment', {
    'id' :: dmsl_domain_thrift:'InvoicePaymentAdjustmentID'(),
    'status' :: dmsl_domain_thrift:'InvoicePaymentAdjustmentStatus'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'domain_revision' :: dmsl_domain_thrift:'DataRevision'(),
    'reason' :: binary(),
    'new_cash_flow' :: dmsl_domain_thrift:'FinalCashFlow'(),
    'old_cash_flow_inverse' :: dmsl_domain_thrift:'FinalCashFlow'()
}).

%% struct 'InvoicePaymentAdjustmentPending'
-record('domain_InvoicePaymentAdjustmentPending', {}).

%% struct 'InvoicePaymentAdjustmentCaptured'
-record('domain_InvoicePaymentAdjustmentCaptured', {
    'at' :: dmsl_base_thrift:'Timestamp'()
}).

%% struct 'InvoicePaymentAdjustmentCancelled'
-record('domain_InvoicePaymentAdjustmentCancelled', {
    'at' :: dmsl_base_thrift:'Timestamp'()
}).

%% struct 'Unblocked'
-record('domain_Unblocked', {
    'reason' :: binary(),
    'since' :: dmsl_base_thrift:'Timestamp'()
}).

%% struct 'Blocked'
-record('domain_Blocked', {
    'reason' :: binary(),
    'since' :: dmsl_base_thrift:'Timestamp'()
}).

%% struct 'Active'
-record('domain_Active', {
    'since' :: dmsl_base_thrift:'Timestamp'()
}).

%% struct 'Suspended'
-record('domain_Suspended', {
    'since' :: dmsl_base_thrift:'Timestamp'()
}).

%% struct 'Party'
-record('domain_Party', {
    'id' :: dmsl_domain_thrift:'PartyID'(),
    'contact_info' :: dmsl_domain_thrift:'PartyContactInfo'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'blocking' :: dmsl_domain_thrift:'Blocking'(),
    'suspension' :: dmsl_domain_thrift:'Suspension'(),
    'contracts' :: #{dmsl_domain_thrift:'ContractID'() => dmsl_domain_thrift:'Contract'()},
    'shops' :: #{dmsl_domain_thrift:'ShopID'() => dmsl_domain_thrift:'Shop'()}
}).

%% struct 'PartyContactInfo'
-record('domain_PartyContactInfo', {
    'email' :: binary()
}).

%% struct 'Shop'
-record('domain_Shop', {
    'id' :: dmsl_domain_thrift:'ShopID'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'blocking' :: dmsl_domain_thrift:'Blocking'(),
    'suspension' :: dmsl_domain_thrift:'Suspension'(),
    'details' :: dmsl_domain_thrift:'ShopDetails'(),
    'location' :: dmsl_domain_thrift:'ShopLocation'(),
    'category' :: dmsl_domain_thrift:'CategoryRef'(),
    'account' :: dmsl_domain_thrift:'ShopAccount'() | undefined,
    'contract_id' :: dmsl_domain_thrift:'ContractID'(),
    'payout_tool_id' :: dmsl_domain_thrift:'PayoutToolID'() | undefined,
    'proxy' :: dmsl_domain_thrift:'Proxy'() | undefined
}).

%% struct 'ShopAccount'
-record('domain_ShopAccount', {
    'currency' :: dmsl_domain_thrift:'CurrencyRef'(),
    'settlement' :: dmsl_domain_thrift:'AccountID'(),
    'guarantee' :: dmsl_domain_thrift:'AccountID'(),
    'payout' :: dmsl_domain_thrift:'AccountID'()
}).

%% struct 'ShopDetails'
-record('domain_ShopDetails', {
    'name' :: binary(),
    'description' :: binary() | undefined
}).

%% struct 'ContractorRef'
-record('domain_ContractorRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'()
}).

%% struct 'RegisteredUser'
-record('domain_RegisteredUser', {
    'email' :: binary()
}).

%% struct 'RussianLegalEntity'
-record('domain_RussianLegalEntity', {
    'registered_name' :: binary(),
    'registered_number' :: binary(),
    'inn' :: binary(),
    'actual_address' :: binary(),
    'post_address' :: binary(),
    'representative_position' :: binary(),
    'representative_full_name' :: binary(),
    'representative_document' :: binary(),
    'bank_account' :: dmsl_domain_thrift:'BankAccount'()
}).

%% struct 'BankAccount'
-record('domain_BankAccount', {
    'account' :: binary(),
    'bank_name' :: binary(),
    'bank_post_account' :: binary(),
    'bank_bik' :: binary()
}).

%% struct 'PayoutTool'
-record('domain_PayoutTool', {
    'id' :: dmsl_domain_thrift:'PayoutToolID'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'currency' :: dmsl_domain_thrift:'CurrencyRef'(),
    'payout_tool_info' :: dmsl_domain_thrift:'PayoutToolInfo'()
}).

%% struct 'Contract'
-record('domain_Contract', {
    'id' :: dmsl_domain_thrift:'ContractID'(),
    'contractor' :: dmsl_domain_thrift:'Contractor'() | undefined,
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'valid_since' :: dmsl_base_thrift:'Timestamp'() | undefined,
    'valid_until' :: dmsl_base_thrift:'Timestamp'() | undefined,
    'status' :: dmsl_domain_thrift:'ContractStatus'(),
    'terms' :: dmsl_domain_thrift:'TermSetHierarchyRef'(),
    'adjustments' :: [dmsl_domain_thrift:'ContractAdjustment'()],
    'payout_tools' :: [dmsl_domain_thrift:'PayoutTool'()],
    'legal_agreement' :: dmsl_domain_thrift:'LegalAgreement'() | undefined
}).

%% struct 'LegalAgreement'
-record('domain_LegalAgreement', {
    'signed_at' :: dmsl_base_thrift:'Timestamp'(),
    'legal_agreement_id' :: binary()
}).

%% struct 'ContractActive'
-record('domain_ContractActive', {}).

%% struct 'ContractTerminated'
-record('domain_ContractTerminated', {
    'terminated_at' :: dmsl_base_thrift:'Timestamp'()
}).

%% struct 'ContractExpired'
-record('domain_ContractExpired', {}).

%% struct 'CategoryRef'
-record('domain_CategoryRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'()
}).

%% struct 'Category'
-record('domain_Category', {
    'name' :: binary(),
    'description' :: binary(),
    'type' = 'test' :: atom() | undefined
}).

%% struct 'ContractTemplateRef'
-record('domain_ContractTemplateRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'()
}).

%% struct 'ContractTemplate'
-record('domain_ContractTemplate', {
    'name' :: binary() | undefined,
    'description' :: binary() | undefined,
    'valid_since' :: dmsl_domain_thrift:'Lifetime'() | undefined,
    'valid_until' :: dmsl_domain_thrift:'Lifetime'() | undefined,
    'terms' :: dmsl_domain_thrift:'TermSetHierarchyRef'()
}).

%% struct 'LifetimeInterval'
-record('domain_LifetimeInterval', {
    'years' :: integer() | undefined,
    'months' :: integer() | undefined,
    'days' :: integer() | undefined
}).

%% struct 'ContractAdjustment'
-record('domain_ContractAdjustment', {
    'id' :: dmsl_domain_thrift:'ContractAdjustmentID'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'valid_since' :: dmsl_base_thrift:'Timestamp'() | undefined,
    'valid_until' :: dmsl_base_thrift:'Timestamp'() | undefined,
    'terms' :: dmsl_domain_thrift:'TermSetHierarchyRef'()
}).

%% struct 'TermSet'
-record('domain_TermSet', {
    'payments' :: dmsl_domain_thrift:'PaymentsServiceTerms'() | undefined
}).

%% struct 'TimedTermSet'
-record('domain_TimedTermSet', {
    'action_time' :: dmsl_base_thrift:'TimestampInterval'(),
    'terms' :: dmsl_domain_thrift:'TermSet'()
}).

%% struct 'TermSetHierarchy'
-record('domain_TermSetHierarchy', {
    'name' :: binary() | undefined,
    'description' :: binary() | undefined,
    'parent_terms' :: dmsl_domain_thrift:'TermSetHierarchyRef'() | undefined,
    'term_sets' :: [dmsl_domain_thrift:'TimedTermSet'()]
}).

%% struct 'TermSetHierarchyRef'
-record('domain_TermSetHierarchyRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'()
}).

%% struct 'PaymentsServiceTerms'
-record('domain_PaymentsServiceTerms', {
    'currencies' :: dmsl_domain_thrift:'CurrencySelector'() | undefined,
    'categories' :: dmsl_domain_thrift:'CategorySelector'() | undefined,
    'payment_methods' :: dmsl_domain_thrift:'PaymentMethodSelector'() | undefined,
    'cash_limit' :: dmsl_domain_thrift:'CashLimitSelector'() | undefined,
    'fees' :: dmsl_domain_thrift:'CashFlowSelector'() | undefined,
    'guarantee_fund' :: dmsl_domain_thrift:'GuaranteeFundTerms'() | undefined
}).

%% struct 'GuaranteeFundTerms'
-record('domain_GuaranteeFundTerms', {
    'limits' :: dmsl_domain_thrift:'CashLimitSelector'() | undefined,
    'fees' :: dmsl_domain_thrift:'CashFlowSelector'() | undefined
}).

%% struct 'CurrencyRef'
-record('domain_CurrencyRef', {
    'symbolic_code' :: dmsl_domain_thrift:'CurrencySymbolicCode'()
}).

%% struct 'Currency'
-record('domain_Currency', {
    'name' :: binary(),
    'symbolic_code' :: dmsl_domain_thrift:'CurrencySymbolicCode'(),
    'numeric_code' :: integer(),
    'exponent' :: integer()
}).

%% struct 'CurrencyDecision'
-record('domain_CurrencyDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'CurrencySelector'()
}).

%% struct 'CategoryDecision'
-record('domain_CategoryDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'CategorySelector'()
}).

%% struct 'CashRange'
-record('domain_CashRange', {
    'upper' :: dmsl_domain_thrift:'CashBound'(),
    'lower' :: dmsl_domain_thrift:'CashBound'()
}).

%% struct 'CashLimitDecision'
-record('domain_CashLimitDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'CashLimitSelector'()
}).

%% struct 'BankCard'
-record('domain_BankCard', {
    'token' :: dmsl_domain_thrift:'Token'(),
    'payment_system' :: atom(),
    'bin' :: binary(),
    'masked_pan' :: binary()
}).

%% struct 'PaymentTerminal'
-record('domain_PaymentTerminal', {
    'terminal_type' :: dmsl_domain_thrift:'TerminalPaymentProvider'()
}).

%% struct 'BankCardBINRangeRef'
-record('domain_BankCardBINRangeRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'()
}).

%% struct 'BankCardBINRange'
-record('domain_BankCardBINRange', {
    'name' :: binary(),
    'description' :: binary(),
    'bins' :: ordsets:ordset(binary())
}).

%% struct 'PaymentMethodRef'
-record('domain_PaymentMethodRef', {
    'id' :: dmsl_domain_thrift:'PaymentMethod'()
}).

%% struct 'PaymentMethodDefinition'
-record('domain_PaymentMethodDefinition', {
    'name' :: binary(),
    'description' :: binary()
}).

%% struct 'PaymentMethodDecision'
-record('domain_PaymentMethodDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'PaymentMethodSelector'()
}).

%% struct 'CashFlowPosting'
-record('domain_CashFlowPosting', {
    'source' :: dmsl_domain_thrift:'CashFlowAccount'(),
    'destination' :: dmsl_domain_thrift:'CashFlowAccount'(),
    'volume' :: dmsl_domain_thrift:'CashVolume'(),
    'details' :: binary() | undefined
}).

%% struct 'FinalCashFlowPosting'
-record('domain_FinalCashFlowPosting', {
    'source' :: dmsl_domain_thrift:'FinalCashFlowAccount'(),
    'destination' :: dmsl_domain_thrift:'FinalCashFlowAccount'(),
    'volume' :: dmsl_domain_thrift:'Cash'(),
    'details' :: binary() | undefined
}).

%% struct 'FinalCashFlowAccount'
-record('domain_FinalCashFlowAccount', {
    'account_type' :: dmsl_domain_thrift:'CashFlowAccount'(),
    'account_id' :: dmsl_domain_thrift:'AccountID'()
}).

%% struct 'CashVolumeFixed'
-record('domain_CashVolumeFixed', {
    'cash' :: dmsl_domain_thrift:'Cash'()
}).

%% struct 'CashVolumeShare'
-record('domain_CashVolumeShare', {
    'parts' :: dmsl_base_thrift:'Rational'(),
    'of' :: atom()
}).

%% struct 'CashFlowDecision'
-record('domain_CashFlowDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'CashFlowSelector'()
}).

%% struct 'ProviderRef'
-record('domain_ProviderRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'()
}).

%% struct 'Provider'
-record('domain_Provider', {
    'name' :: binary(),
    'description' :: binary(),
    'proxy' :: dmsl_domain_thrift:'Proxy'(),
    'terminal' :: dmsl_domain_thrift:'TerminalSelector'(),
    'abs_account' :: binary()
}).

%% struct 'ProviderDecision'
-record('domain_ProviderDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'ProviderSelector'()
}).

%% struct 'TerminalRef'
-record('domain_TerminalRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'()
}).

%% struct 'InspectorRef'
-record('domain_InspectorRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'()
}).

%% struct 'Inspector'
-record('domain_Inspector', {
    'name' :: binary(),
    'description' :: binary(),
    'proxy' :: dmsl_domain_thrift:'Proxy'()
}).

%% struct 'InspectorDecision'
-record('domain_InspectorDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'InspectorSelector'()
}).

%% struct 'Terminal'
-record('domain_Terminal', {
    'name' :: binary(),
    'description' :: binary(),
    'payment_method' :: dmsl_domain_thrift:'PaymentMethodRef'(),
    'category' :: dmsl_domain_thrift:'CategoryRef'(),
    'cash_flow' :: dmsl_domain_thrift:'CashFlow'(),
    'account' :: dmsl_domain_thrift:'TerminalAccount'(),
    'options' :: dmsl_domain_thrift:'ProxyOptions'() | undefined,
    'risk_coverage' :: atom()
}).

%% struct 'TerminalAccount'
-record('domain_TerminalAccount', {
    'currency' :: dmsl_domain_thrift:'CurrencyRef'(),
    'settlement' :: dmsl_domain_thrift:'AccountID'()
}).

%% struct 'TerminalDecision'
-record('domain_TerminalDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'TerminalSelector'()
}).

%% struct 'PartyCondition'
-record('domain_PartyCondition', {
    'id' :: dmsl_domain_thrift:'PartyID'(),
    'definition' :: dmsl_domain_thrift:'PartyConditionDefinition'() | undefined
}).

%% struct 'ProxyRef'
-record('domain_ProxyRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'()
}).

%% struct 'ProxyDefinition'
-record('domain_ProxyDefinition', {
    'name' :: binary(),
    'description' :: binary(),
    'url' :: binary(),
    'options' :: dmsl_domain_thrift:'ProxyOptions'()
}).

%% struct 'Proxy'
-record('domain_Proxy', {
    'ref' :: dmsl_domain_thrift:'ProxyRef'(),
    'additional' :: dmsl_domain_thrift:'ProxyOptions'()
}).

%% struct 'SystemAccountSetRef'
-record('domain_SystemAccountSetRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'()
}).

%% struct 'SystemAccountSet'
-record('domain_SystemAccountSet', {
    'name' :: binary(),
    'description' :: binary(),
    'accounts' :: #{dmsl_domain_thrift:'CurrencyRef'() => dmsl_domain_thrift:'SystemAccount'()}
}).

%% struct 'SystemAccount'
-record('domain_SystemAccount', {
    'settlement' :: dmsl_domain_thrift:'AccountID'()
}).

%% struct 'SystemAccountSetDecision'
-record('domain_SystemAccountSetDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'SystemAccountSetSelector'()
}).

%% struct 'ExternalAccountSetRef'
-record('domain_ExternalAccountSetRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'()
}).

%% struct 'ExternalAccountSet'
-record('domain_ExternalAccountSet', {
    'name' :: binary(),
    'description' :: binary(),
    'accounts' :: #{dmsl_domain_thrift:'CurrencyRef'() => dmsl_domain_thrift:'ExternalAccount'()}
}).

%% struct 'ExternalAccount'
-record('domain_ExternalAccount', {
    'income' :: dmsl_domain_thrift:'AccountID'(),
    'outcome' :: dmsl_domain_thrift:'AccountID'()
}).

%% struct 'ExternalAccountSetDecision'
-record('domain_ExternalAccountSetDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'ExternalAccountSetSelector'()
}).

%% struct 'PartyPrototypeRef'
-record('domain_PartyPrototypeRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'()
}).

%% struct 'PartyPrototype'
-record('domain_PartyPrototype', {
    'shop' :: dmsl_domain_thrift:'ShopPrototype'(),
    'contract' :: dmsl_domain_thrift:'ContractPrototype'()
}).

%% struct 'ShopPrototype'
-record('domain_ShopPrototype', {
    'shop_id' :: dmsl_domain_thrift:'ShopID'(),
    'category' :: dmsl_domain_thrift:'CategoryRef'(),
    'currency' :: dmsl_domain_thrift:'CurrencyRef'(),
    'details' :: dmsl_domain_thrift:'ShopDetails'(),
    'location' :: dmsl_domain_thrift:'ShopLocation'()
}).

%% struct 'ContractPrototype'
-record('domain_ContractPrototype', {
    'contract_id' :: dmsl_domain_thrift:'ContractID'(),
    'test_contract_template' :: dmsl_domain_thrift:'ContractTemplateRef'(),
    'payout_tool' :: dmsl_domain_thrift:'PayoutToolPrototype'()
}).

%% struct 'PayoutToolPrototype'
-record('domain_PayoutToolPrototype', {
    'payout_tool_id' :: dmsl_domain_thrift:'PayoutToolID'(),
    'payout_tool_info' :: dmsl_domain_thrift:'PayoutToolInfo'(),
    'payout_tool_currency' :: dmsl_domain_thrift:'CurrencyRef'()
}).

%% struct 'GlobalsRef'
-record('domain_GlobalsRef', {}).

%% struct 'Globals'
-record('domain_Globals', {
    'party_prototype' :: dmsl_domain_thrift:'PartyPrototypeRef'(),
    'providers' :: dmsl_domain_thrift:'ProviderSelector'(),
    'system_account_set' :: dmsl_domain_thrift:'SystemAccountSetSelector'(),
    'external_account_set' :: dmsl_domain_thrift:'ExternalAccountSetSelector'(),
    'inspector' :: dmsl_domain_thrift:'InspectorSelector'(),
    'default_contract_template' :: dmsl_domain_thrift:'ContractTemplateRef'(),
    'common_merchant_proxy' :: dmsl_domain_thrift:'ProxyRef'() | undefined
}).

%% struct 'Dummy'
-record('domain_Dummy', {}).

%% struct 'DummyRef'
-record('domain_DummyRef', {
    'id' :: dmsl_base_thrift:'ID'()
}).

%% struct 'DummyObject'
-record('domain_DummyObject', {
    'ref' :: dmsl_domain_thrift:'DummyRef'(),
    'data' :: dmsl_domain_thrift:'Dummy'()
}).

%% struct 'DummyLink'
-record('domain_DummyLink', {
    'link' :: dmsl_domain_thrift:'DummyRef'()
}).

%% struct 'DummyLinkRef'
-record('domain_DummyLinkRef', {
    'id' :: dmsl_base_thrift:'ID'()
}).

%% struct 'DummyLinkObject'
-record('domain_DummyLinkObject', {
    'ref' :: dmsl_domain_thrift:'DummyLinkRef'(),
    'data' :: dmsl_domain_thrift:'DummyLink'()
}).

%% struct 'ContractTemplateObject'
-record('domain_ContractTemplateObject', {
    'ref' :: dmsl_domain_thrift:'ContractTemplateRef'(),
    'data' :: dmsl_domain_thrift:'ContractTemplate'()
}).

%% struct 'TermSetHierarchyObject'
-record('domain_TermSetHierarchyObject', {
    'ref' :: dmsl_domain_thrift:'TermSetHierarchyRef'(),
    'data' :: dmsl_domain_thrift:'TermSetHierarchy'()
}).

%% struct 'CategoryObject'
-record('domain_CategoryObject', {
    'ref' :: dmsl_domain_thrift:'CategoryRef'(),
    'data' :: dmsl_domain_thrift:'Category'()
}).

%% struct 'CurrencyObject'
-record('domain_CurrencyObject', {
    'ref' :: dmsl_domain_thrift:'CurrencyRef'(),
    'data' :: dmsl_domain_thrift:'Currency'()
}).

%% struct 'PaymentMethodObject'
-record('domain_PaymentMethodObject', {
    'ref' :: dmsl_domain_thrift:'PaymentMethodRef'(),
    'data' :: dmsl_domain_thrift:'PaymentMethodDefinition'()
}).

%% struct 'BankCardBINRangeObject'
-record('domain_BankCardBINRangeObject', {
    'ref' :: dmsl_domain_thrift:'BankCardBINRangeRef'(),
    'data' :: dmsl_domain_thrift:'BankCardBINRange'()
}).

%% struct 'ContractorObject'
-record('domain_ContractorObject', {
    'ref' :: dmsl_domain_thrift:'ContractorRef'(),
    'data' :: dmsl_domain_thrift:'Contractor'()
}).

%% struct 'ProviderObject'
-record('domain_ProviderObject', {
    'ref' :: dmsl_domain_thrift:'ProviderRef'(),
    'data' :: dmsl_domain_thrift:'Provider'()
}).

%% struct 'TerminalObject'
-record('domain_TerminalObject', {
    'ref' :: dmsl_domain_thrift:'TerminalRef'(),
    'data' :: dmsl_domain_thrift:'Terminal'()
}).

%% struct 'InspectorObject'
-record('domain_InspectorObject', {
    'ref' :: dmsl_domain_thrift:'InspectorRef'(),
    'data' :: dmsl_domain_thrift:'Inspector'()
}).

%% struct 'SystemAccountSetObject'
-record('domain_SystemAccountSetObject', {
    'ref' :: dmsl_domain_thrift:'SystemAccountSetRef'(),
    'data' :: dmsl_domain_thrift:'SystemAccountSet'()
}).

%% struct 'ExternalAccountSetObject'
-record('domain_ExternalAccountSetObject', {
    'ref' :: dmsl_domain_thrift:'ExternalAccountSetRef'(),
    'data' :: dmsl_domain_thrift:'ExternalAccountSet'()
}).

%% struct 'ProxyObject'
-record('domain_ProxyObject', {
    'ref' :: dmsl_domain_thrift:'ProxyRef'(),
    'data' :: dmsl_domain_thrift:'ProxyDefinition'()
}).

%% struct 'PartyPrototypeObject'
-record('domain_PartyPrototypeObject', {
    'ref' :: dmsl_domain_thrift:'PartyPrototypeRef'(),
    'data' :: dmsl_domain_thrift:'PartyPrototype'()
}).

%% struct 'GlobalsObject'
-record('domain_GlobalsObject', {
    'ref' :: dmsl_domain_thrift:'GlobalsRef'(),
    'data' :: dmsl_domain_thrift:'Globals'()
}).

-endif.
