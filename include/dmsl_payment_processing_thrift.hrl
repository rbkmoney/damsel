-ifndef(dmsl_payment_processing_thrift_included__).
-define(dmsl_payment_processing_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_domain_thrift.hrl").
-include("dmsl_user_interaction_thrift.hrl").



%% struct 'UserInfo'
-record('payproc_UserInfo', {
    'id' :: dmsl_payment_processing_thrift:'UserID'(),
    'type' :: dmsl_payment_processing_thrift:'UserType'()
}).

%% struct 'InternalUser'
-record('payproc_InternalUser', {}).

%% struct 'ExternalUser'
-record('payproc_ExternalUser', {}).

%% struct 'ServiceUser'
-record('payproc_ServiceUser', {}).

%% struct 'Event'
-record('payproc_Event', {
    'id' :: dmsl_base_thrift:'EventID'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'source' :: dmsl_payment_processing_thrift:'EventSource'(),
    'payload' :: dmsl_payment_processing_thrift:'EventPayload'()
}).

%% struct 'InvoiceCreated'
-record('payproc_InvoiceCreated', {
    'invoice' :: dmsl_domain_thrift:'Invoice'()
}).

%% struct 'InvoiceStatusChanged'
-record('payproc_InvoiceStatusChanged', {
    'status' :: dmsl_domain_thrift:'InvoiceStatus'()
}).

%% struct 'InvoicePaymentChange'
-record('payproc_InvoicePaymentChange', {
    'id' :: dmsl_domain_thrift:'InvoicePaymentID'(),
    'payload' :: dmsl_payment_processing_thrift:'InvoicePaymentChangePayload'()
}).

%% struct 'InvoicePaymentStarted'
-record('payproc_InvoicePaymentStarted', {
    'payment' :: dmsl_domain_thrift:'InvoicePayment'(),
    'risk_score' :: atom(),
    'route' :: dmsl_domain_thrift:'PaymentRoute'(),
    'cash_flow' :: dmsl_domain_thrift:'FinalCashFlow'()
}).

%% struct 'InvoicePaymentStatusChanged'
-record('payproc_InvoicePaymentStatusChanged', {
    'status' :: dmsl_domain_thrift:'InvoicePaymentStatus'()
}).

%% struct 'InvoicePaymentSessionChange'
-record('payproc_InvoicePaymentSessionChange', {
    'target' :: dmsl_domain_thrift:'TargetInvoicePaymentStatus'(),
    'payload' :: dmsl_payment_processing_thrift:'SessionChangePayload'()
}).

%% struct 'SessionStarted'
-record('payproc_SessionStarted', {}).

%% struct 'SessionFinished'
-record('payproc_SessionFinished', {
    'result' :: dmsl_payment_processing_thrift:'SessionResult'()
}).

%% struct 'SessionSuspended'
-record('payproc_SessionSuspended', {
    'tag' :: dmsl_base_thrift:'Tag'() | undefined
}).

%% struct 'SessionActivated'
-record('payproc_SessionActivated', {}).

%% struct 'SessionSucceeded'
-record('payproc_SessionSucceeded', {}).

%% struct 'SessionFailed'
-record('payproc_SessionFailed', {
    'failure' :: dmsl_domain_thrift:'OperationFailure'()
}).

%% struct 'InvoiceTemplateCreated'
-record('payproc_InvoiceTemplateCreated', {
    'invoice_template' :: dmsl_domain_thrift:'InvoiceTemplate'()
}).

%% struct 'InvoiceTemplateUpdated'
-record('payproc_InvoiceTemplateUpdated', {
    'diff' :: dmsl_payment_processing_thrift:'InvoiceTemplateUpdateParams'()
}).

%% struct 'InvoiceTemplateDeleted'
-record('payproc_InvoiceTemplateDeleted', {}).

%% struct 'SessionTransactionBound'
-record('payproc_SessionTransactionBound', {
    'trx' :: dmsl_domain_thrift:'TransactionInfo'()
}).

%% struct 'SessionProxyStateChanged'
-record('payproc_SessionProxyStateChanged', {
    'proxy_state' :: dmsl_base_thrift:'Opaque'()
}).

%% struct 'SessionInteractionRequested'
-record('payproc_SessionInteractionRequested', {
    'interaction' :: dmsl_user_interaction_thrift:'UserInteraction'()
}).

%% struct 'InvoicePaymentRefundChange'
-record('payproc_InvoicePaymentRefundChange', {
    'id' :: dmsl_domain_thrift:'InvoicePaymentRefundID'(),
    'payload' :: dmsl_payment_processing_thrift:'InvoicePaymentRefundChangePayload'()
}).

%% struct 'InvoicePaymentRefundCreated'
-record('payproc_InvoicePaymentRefundCreated', {
    'refund' :: dmsl_domain_thrift:'InvoicePaymentRefund'(),
    'cash_flow' :: dmsl_domain_thrift:'FinalCashFlow'()
}).

%% struct 'InvoicePaymentRefundStatusChanged'
-record('payproc_InvoicePaymentRefundStatusChanged', {
    'status' :: dmsl_domain_thrift:'InvoicePaymentRefundStatus'()
}).

%% struct 'InvoicePaymentAdjustmentChange'
-record('payproc_InvoicePaymentAdjustmentChange', {
    'id' :: dmsl_domain_thrift:'InvoicePaymentAdjustmentID'(),
    'payload' :: dmsl_payment_processing_thrift:'InvoicePaymentAdjustmentChangePayload'()
}).

%% struct 'InvoicePaymentAdjustmentCreated'
-record('payproc_InvoicePaymentAdjustmentCreated', {
    'adjustment' :: dmsl_domain_thrift:'InvoicePaymentAdjustment'()
}).

%% struct 'InvoicePaymentAdjustmentStatusChanged'
-record('payproc_InvoicePaymentAdjustmentStatusChanged', {
    'status' :: dmsl_domain_thrift:'InvoicePaymentAdjustmentStatus'()
}).

%% struct 'InvoicePaymentReceiptChange'
-record('payproc_InvoicePaymentReceiptChange', {
    'id' :: dmsl_domain_thrift:'InvoicePaymentReceiptID'(),
    'payload' :: dmsl_payment_processing_thrift:'InvoicePaymentReceiptChangePayload'()
}).

%% struct 'InvoicePaymentReceiptCreated'
-record('payproc_InvoicePaymentReceiptCreated', {}).

%% struct 'InvoicePaymentReceiptRegistered'
-record('payproc_InvoicePaymentReceiptRegistered', {}).

%% struct 'InvoicePaymentReceiptFailed'
-record('payproc_InvoicePaymentReceiptFailed', {
    'failure' :: dmsl_domain_thrift:'OperationFailure'()
}).

%% struct 'EventRange'
-record('payproc_EventRange', {
    'after' :: dmsl_base_thrift:'EventID'() | undefined,
    'limit' :: integer()
}).

%% struct 'InvoiceParams'
-record('payproc_InvoiceParams', {
    'party_id' :: dmsl_payment_processing_thrift:'PartyID'(),
    'shop_id' :: dmsl_payment_processing_thrift:'ShopID'(),
    'details' :: dmsl_domain_thrift:'InvoiceDetails'(),
    'due' :: dmsl_base_thrift:'Timestamp'(),
    'cost' :: dmsl_domain_thrift:'Cash'(),
    'context' :: dmsl_domain_thrift:'InvoiceContext'()
}).

%% struct 'InvoiceWithTemplateParams'
-record('payproc_InvoiceWithTemplateParams', {
    'template_id' :: dmsl_domain_thrift:'InvoiceTemplateID'(),
    'cost' :: dmsl_domain_thrift:'Cash'() | undefined,
    'context' :: dmsl_domain_thrift:'InvoiceContext'() | undefined
}).

%% struct 'InvoiceTemplateCreateParams'
-record('payproc_InvoiceTemplateCreateParams', {
    'party_id' :: dmsl_payment_processing_thrift:'PartyID'(),
    'shop_id' :: dmsl_payment_processing_thrift:'ShopID'(),
    'invoice_lifetime' :: dmsl_domain_thrift:'LifetimeInterval'(),
    'product' :: binary(),
    'description' :: binary() | undefined,
    'details' :: dmsl_domain_thrift:'InvoiceTemplateDetails'(),
    'context' :: dmsl_domain_thrift:'InvoiceContext'()
}).

%% struct 'InvoiceTemplateUpdateParams'
-record('payproc_InvoiceTemplateUpdateParams', {
    'invoice_lifetime' :: dmsl_domain_thrift:'LifetimeInterval'() | undefined,
    'product' :: binary() | undefined,
    'description' :: binary() | undefined,
    'details' :: dmsl_domain_thrift:'InvoiceTemplateDetails'() | undefined,
    'context' :: dmsl_domain_thrift:'InvoiceContext'() | undefined
}).

%% struct 'InvoicePaymentParams'
-record('payproc_InvoicePaymentParams', {
    'payer' :: dmsl_payment_processing_thrift:'PayerParams'(),
    'flow' :: dmsl_payment_processing_thrift:'InvoicePaymentParamsFlow'()
}).

%% struct 'PaymentResourcePayerParams'
-record('payproc_PaymentResourcePayerParams', {
    'resource' :: dmsl_domain_thrift:'DisposablePaymentResource'(),
    'contact_info' :: dmsl_domain_thrift:'ContactInfo'()
}).

%% struct 'CustomerPayerParams'
-record('payproc_CustomerPayerParams', {
    'customer_id' :: dmsl_domain_thrift:'CustomerID'()
}).

%% struct 'InvoicePaymentParamsFlowInstant'
-record('payproc_InvoicePaymentParamsFlowInstant', {}).

%% struct 'InvoicePaymentParamsFlowHold'
-record('payproc_InvoicePaymentParamsFlowHold', {
    'on_hold_expiration' :: atom()
}).

%% struct 'Invoice'
-record('payproc_Invoice', {
    'invoice' :: dmsl_domain_thrift:'Invoice'(),
    'payments' :: [dmsl_payment_processing_thrift:'InvoicePayment'()]
}).

%% struct 'InvoicePayment'
-record('payproc_InvoicePayment', {
    'payment' :: dmsl_domain_thrift:'InvoicePayment'(),
    'refunds' :: [dmsl_payment_processing_thrift:'InvoicePaymentRefund'()],
    'adjustments' :: [dmsl_payment_processing_thrift:'InvoicePaymentAdjustment'()]
}).

%% struct 'InvoicePaymentRefundParams'
-record('payproc_InvoicePaymentRefundParams', {
    'reason' :: binary() | undefined
}).

%% struct 'InvoicePaymentAdjustmentParams'
-record('payproc_InvoicePaymentAdjustmentParams', {
    'domain_revision' :: dmsl_domain_thrift:'DataRevision'() | undefined,
    'reason' :: binary()
}).

%% struct 'CustomerParams'
-record('payproc_CustomerParams', {
    'party_id' :: dmsl_payment_processing_thrift:'PartyID'(),
    'shop_id' :: dmsl_payment_processing_thrift:'ShopID'(),
    'contact_info' :: dmsl_domain_thrift:'ContactInfo'(),
    'metadata' :: dmsl_payment_processing_thrift:'Metadata'()
}).

%% struct 'Customer'
-record('payproc_Customer', {
    'id' :: dmsl_payment_processing_thrift:'CustomerID'(),
    'owner_id' :: dmsl_payment_processing_thrift:'PartyID'(),
    'shop_id' :: dmsl_payment_processing_thrift:'ShopID'(),
    'status' :: dmsl_payment_processing_thrift:'CustomerStatus'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'bindings' :: [dmsl_payment_processing_thrift:'CustomerBinding'()],
    'contact_info' :: dmsl_domain_thrift:'ContactInfo'(),
    'metadata' :: dmsl_payment_processing_thrift:'Metadata'(),
    'active_binding_id' :: dmsl_payment_processing_thrift:'CustomerBindingID'() | undefined
}).

%% struct 'CustomerUnready'
-record('payproc_CustomerUnready', {}).

%% struct 'CustomerReady'
-record('payproc_CustomerReady', {}).

%% struct 'CustomerCreated'
-record('payproc_CustomerCreated', {
    'customer_id' :: dmsl_payment_processing_thrift:'CustomerID'(),
    'owner_id' :: dmsl_payment_processing_thrift:'PartyID'(),
    'shop_id' :: dmsl_payment_processing_thrift:'ShopID'(),
    'metadata' :: dmsl_payment_processing_thrift:'Metadata'(),
    'contact_info' :: dmsl_domain_thrift:'ContactInfo'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'()
}).

%% struct 'CustomerDeleted'
-record('payproc_CustomerDeleted', {}).

%% struct 'CustomerStatusChanged'
-record('payproc_CustomerStatusChanged', {
    'status' :: dmsl_payment_processing_thrift:'CustomerStatus'()
}).

%% struct 'CustomerBindingChanged'
-record('payproc_CustomerBindingChanged', {
    'id' :: dmsl_payment_processing_thrift:'CustomerBindingID'(),
    'payload' :: dmsl_payment_processing_thrift:'CustomerBindingChangePayload'()
}).

%% struct 'CustomerBindingParams'
-record('payproc_CustomerBindingParams', {
    'payment_resource' :: dmsl_payment_processing_thrift:'DisposablePaymentResource'()
}).

%% struct 'CustomerBinding'
-record('payproc_CustomerBinding', {
    'id' :: dmsl_payment_processing_thrift:'CustomerBindingID'(),
    'rec_payment_tool_id' :: dmsl_payment_processing_thrift:'RecurrentPaymentToolID'(),
    'payment_resource' :: dmsl_payment_processing_thrift:'DisposablePaymentResource'(),
    'status' :: dmsl_payment_processing_thrift:'CustomerBindingStatus'()
}).

%% struct 'CustomerBindingPending'
-record('payproc_CustomerBindingPending', {}).

%% struct 'CustomerBindingSucceeded'
-record('payproc_CustomerBindingSucceeded', {}).

%% struct 'CustomerBindingFailed'
-record('payproc_CustomerBindingFailed', {
    'failure' :: dmsl_domain_thrift:'OperationFailure'()
}).

%% struct 'CustomerBindingStarted'
-record('payproc_CustomerBindingStarted', {
    'binding' :: dmsl_payment_processing_thrift:'CustomerBinding'()
}).

%% struct 'CustomerBindingStatusChanged'
-record('payproc_CustomerBindingStatusChanged', {
    'status' :: dmsl_payment_processing_thrift:'CustomerBindingStatus'()
}).

%% struct 'CustomerBindingInteractionRequested'
-record('payproc_CustomerBindingInteractionRequested', {
    'interaction' :: dmsl_user_interaction_thrift:'UserInteraction'()
}).

%% struct 'RecurrentPaymentTool'
-record('payproc_RecurrentPaymentTool', {
    'id' :: dmsl_payment_processing_thrift:'RecurrentPaymentToolID'(),
    'shop_id' :: dmsl_payment_processing_thrift:'ShopID'(),
    'party_id' :: dmsl_payment_processing_thrift:'PartyID'(),
    'domain_revision' :: dmsl_domain_thrift:'DataRevision'(),
    'status' :: dmsl_payment_processing_thrift:'RecurrentPaymentToolStatus'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'payment_resource' :: dmsl_payment_processing_thrift:'DisposablePaymentResource'(),
    'rec_token' :: dmsl_domain_thrift:'Token'() | undefined,
    'route' :: dmsl_domain_thrift:'PaymentRoute'() | undefined
}).

%% struct 'RecurrentPaymentToolParams'
-record('payproc_RecurrentPaymentToolParams', {
    'party_id' :: dmsl_payment_processing_thrift:'PartyID'(),
    'shop_id' :: dmsl_payment_processing_thrift:'ShopID'(),
    'payment_resource' :: dmsl_payment_processing_thrift:'DisposablePaymentResource'()
}).

%% struct 'RecurrentPaymentToolCreated'
-record('payproc_RecurrentPaymentToolCreated', {}).

%% struct 'RecurrentPaymentToolAcquired'
-record('payproc_RecurrentPaymentToolAcquired', {}).

%% struct 'RecurrentPaymentToolAbandoned'
-record('payproc_RecurrentPaymentToolAbandoned', {}).

%% struct 'RecurrentPaymentToolFailed'
-record('payproc_RecurrentPaymentToolFailed', {
    'failure' :: dmsl_domain_thrift:'OperationFailure'()
}).

%% struct 'RecurrentPaymentToolEvent'
-record('payproc_RecurrentPaymentToolEvent', {
    'id' :: dmsl_base_thrift:'EventID'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'source' :: dmsl_payment_processing_thrift:'RecurrentPaymentToolID'(),
    'payload' :: [dmsl_payment_processing_thrift:'RecurrentPaymentToolChange'()]
}).

%% struct 'RecurrentPaymentToolSessionChange'
-record('payproc_RecurrentPaymentToolSessionChange', {
    'payload' :: dmsl_payment_processing_thrift:'SessionChangePayload'()
}).

%% struct 'RecurrentPaymentToolHasCreated'
-record('payproc_RecurrentPaymentToolHasCreated', {
    'rec_payment_tool' :: dmsl_payment_processing_thrift:'RecurrentPaymentTool'(),
    'risk_score' :: atom(),
    'route' :: dmsl_domain_thrift:'PaymentRoute'()
}).

%% struct 'RecurrentPaymentToolHasAcquired'
-record('payproc_RecurrentPaymentToolHasAcquired', {
    'token' :: dmsl_domain_thrift:'Token'()
}).

%% struct 'RecurrentPaymentToolHasAbandoned'
-record('payproc_RecurrentPaymentToolHasAbandoned', {}).

%% struct 'RecurrentPaymentToolHasFailed'
-record('payproc_RecurrentPaymentToolHasFailed', {
    'failure' :: dmsl_domain_thrift:'OperationFailure'()
}).

%% struct 'PartyParams'
-record('payproc_PartyParams', {
    'contact_info' :: dmsl_domain_thrift:'PartyContactInfo'()
}).

%% struct 'PayoutToolParams'
-record('payproc_PayoutToolParams', {
    'currency' :: dmsl_domain_thrift:'CurrencyRef'(),
    'tool_info' :: dmsl_domain_thrift:'PayoutToolInfo'()
}).

%% struct 'ShopParams'
-record('payproc_ShopParams', {
    'category' :: dmsl_domain_thrift:'CategoryRef'() | undefined,
    'location' :: dmsl_domain_thrift:'ShopLocation'(),
    'details' :: dmsl_domain_thrift:'ShopDetails'(),
    'contract_id' :: dmsl_payment_processing_thrift:'ContractID'(),
    'payout_tool_id' :: dmsl_domain_thrift:'PayoutToolID'()
}).

%% struct 'ShopAccountParams'
-record('payproc_ShopAccountParams', {
    'currency' :: dmsl_domain_thrift:'CurrencyRef'()
}).

%% struct 'ContractParams'
-record('payproc_ContractParams', {
    'contractor' :: dmsl_domain_thrift:'Contractor'(),
    'template' :: dmsl_domain_thrift:'ContractTemplateRef'() | undefined
}).

%% struct 'ContractAdjustmentParams'
-record('payproc_ContractAdjustmentParams', {
    'template' :: dmsl_domain_thrift:'ContractTemplateRef'()
}).

%% struct 'ContractModificationUnit'
-record('payproc_ContractModificationUnit', {
    'id' :: dmsl_payment_processing_thrift:'ContractID'(),
    'modification' :: dmsl_payment_processing_thrift:'ContractModification'()
}).

%% struct 'ContractTermination'
-record('payproc_ContractTermination', {
    'reason' :: binary() | undefined
}).

%% struct 'ContractAdjustmentModificationUnit'
-record('payproc_ContractAdjustmentModificationUnit', {
    'adjustment_id' :: dmsl_domain_thrift:'ContractAdjustmentID'(),
    'modification' :: dmsl_payment_processing_thrift:'ContractAdjustmentModification'()
}).

%% struct 'PayoutToolModificationUnit'
-record('payproc_PayoutToolModificationUnit', {
    'payout_tool_id' :: dmsl_domain_thrift:'PayoutToolID'(),
    'modification' :: dmsl_payment_processing_thrift:'PayoutToolModification'()
}).

%% struct 'ShopModificationUnit'
-record('payproc_ShopModificationUnit', {
    'id' :: dmsl_payment_processing_thrift:'ShopID'(),
    'modification' :: dmsl_payment_processing_thrift:'ShopModification'()
}).

%% struct 'ShopContractModification'
-record('payproc_ShopContractModification', {
    'contract_id' :: dmsl_payment_processing_thrift:'ContractID'(),
    'payout_tool_id' :: dmsl_domain_thrift:'PayoutToolID'()
}).

%% struct 'ProxyModification'
-record('payproc_ProxyModification', {
    'proxy' :: dmsl_domain_thrift:'Proxy'() | undefined
}).

%% struct 'CashRegModification'
-record('payproc_CashRegModification', {
    'cash_register' :: dmsl_domain_thrift:'ShopCashRegister'() | undefined
}).

%% struct 'Claim'
-record('payproc_Claim', {
    'id' :: dmsl_payment_processing_thrift:'ClaimID'(),
    'status' :: dmsl_payment_processing_thrift:'ClaimStatus'(),
    'changeset' :: dmsl_payment_processing_thrift:'PartyChangeset'(),
    'revision' :: dmsl_payment_processing_thrift:'ClaimRevision'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'updated_at' :: dmsl_base_thrift:'Timestamp'() | undefined
}).

%% struct 'ClaimPending'
-record('payproc_ClaimPending', {}).

%% struct 'ClaimAccepted'
-record('payproc_ClaimAccepted', {
    'effects' :: dmsl_payment_processing_thrift:'ClaimEffects'() | undefined
}).

%% struct 'ClaimDenied'
-record('payproc_ClaimDenied', {
    'reason' :: binary() | undefined
}).

%% struct 'ClaimRevoked'
-record('payproc_ClaimRevoked', {
    'reason' :: binary() | undefined
}).

%% struct 'ContractEffectUnit'
-record('payproc_ContractEffectUnit', {
    'contract_id' :: dmsl_payment_processing_thrift:'ContractID'(),
    'effect' :: dmsl_payment_processing_thrift:'ContractEffect'()
}).

%% struct 'ShopEffectUnit'
-record('payproc_ShopEffectUnit', {
    'shop_id' :: dmsl_payment_processing_thrift:'ShopID'(),
    'effect' :: dmsl_payment_processing_thrift:'ShopEffect'()
}).

%% struct 'ShopContractChanged'
-record('payproc_ShopContractChanged', {
    'contract_id' :: dmsl_payment_processing_thrift:'ContractID'(),
    'payout_tool_id' :: dmsl_domain_thrift:'PayoutToolID'()
}).

%% struct 'ShopProxyChanged'
-record('payproc_ShopProxyChanged', {
    'proxy' :: dmsl_domain_thrift:'Proxy'() | undefined
}).

%% struct 'ShopCashRegisterChanged'
-record('payproc_ShopCashRegisterChanged', {
    'cash_register' :: dmsl_domain_thrift:'ShopCashRegister'() | undefined
}).

%% struct 'AccountState'
-record('payproc_AccountState', {
    'account_id' :: dmsl_domain_thrift:'AccountID'(),
    'own_amount' :: dmsl_domain_thrift:'Amount'(),
    'available_amount' :: dmsl_domain_thrift:'Amount'(),
    'currency' :: dmsl_domain_thrift:'Currency'()
}).

%% struct 'ShopBlocking'
-record('payproc_ShopBlocking', {
    'shop_id' :: dmsl_payment_processing_thrift:'ShopID'(),
    'blocking' :: dmsl_domain_thrift:'Blocking'()
}).

%% struct 'ShopSuspension'
-record('payproc_ShopSuspension', {
    'shop_id' :: dmsl_payment_processing_thrift:'ShopID'(),
    'suspension' :: dmsl_domain_thrift:'Suspension'()
}).

%% struct 'ClaimStatusChanged'
-record('payproc_ClaimStatusChanged', {
    'id' :: dmsl_payment_processing_thrift:'ClaimID'(),
    'status' :: dmsl_payment_processing_thrift:'ClaimStatus'(),
    'revision' :: dmsl_payment_processing_thrift:'ClaimRevision'(),
    'changed_at' :: dmsl_base_thrift:'Timestamp'()
}).

%% struct 'ClaimUpdated'
-record('payproc_ClaimUpdated', {
    'id' :: dmsl_payment_processing_thrift:'ClaimID'(),
    'changeset' :: dmsl_payment_processing_thrift:'PartyChangeset'(),
    'revision' :: dmsl_payment_processing_thrift:'ClaimRevision'(),
    'updated_at' :: dmsl_base_thrift:'Timestamp'()
}).

%% struct 'PartyMetaSet'
-record('payproc_PartyMetaSet', {
    'ns' :: dmsl_domain_thrift:'PartyMetaNamespace'(),
    'data' :: dmsl_domain_thrift:'PartyMetaData'()
}).

%% struct 'ContractStatusInvalid'
-record('payproc_ContractStatusInvalid', {
    'contract_id' :: dmsl_payment_processing_thrift:'ContractID'(),
    'status' :: dmsl_domain_thrift:'ContractStatus'()
}).

%% struct 'ShopStatusInvalid'
-record('payproc_ShopStatusInvalid', {
    'shop_id' :: dmsl_payment_processing_thrift:'ShopID'(),
    'status' :: dmsl_payment_processing_thrift:'InvalidStatus'()
}).

%% struct 'ContractTermsViolated'
-record('payproc_ContractTermsViolated', {
    'shop_id' :: dmsl_payment_processing_thrift:'ShopID'(),
    'contract_id' :: dmsl_payment_processing_thrift:'ContractID'(),
    'terms' :: dmsl_domain_thrift:'TermSet'()
}).

%% exception 'PartyNotFound'
-record('payproc_PartyNotFound', {}).

%% exception 'PartyNotExistsYet'
-record('payproc_PartyNotExistsYet', {}).

%% exception 'ShopNotFound'
-record('payproc_ShopNotFound', {}).

%% exception 'InvalidPartyStatus'
-record('payproc_InvalidPartyStatus', {
    'status' :: dmsl_payment_processing_thrift:'InvalidStatus'()
}).

%% exception 'InvalidShopStatus'
-record('payproc_InvalidShopStatus', {
    'status' :: dmsl_payment_processing_thrift:'InvalidStatus'()
}).

%% exception 'InvalidContractStatus'
-record('payproc_InvalidContractStatus', {
    'status' :: dmsl_domain_thrift:'ContractStatus'()
}).

%% exception 'InvalidUser'
-record('payproc_InvalidUser', {}).

%% exception 'InvoiceNotFound'
-record('payproc_InvoiceNotFound', {}).

%% exception 'InvoicePaymentNotFound'
-record('payproc_InvoicePaymentNotFound', {}).

%% exception 'InvoicePaymentRefundNotFound'
-record('payproc_InvoicePaymentRefundNotFound', {}).

%% exception 'InvoicePaymentAdjustmentNotFound'
-record('payproc_InvoicePaymentAdjustmentNotFound', {}).

%% exception 'EventNotFound'
-record('payproc_EventNotFound', {}).

%% exception 'OperationNotPermitted'
-record('payproc_OperationNotPermitted', {}).

%% exception 'InsufficientAccountBalance'
-record('payproc_InsufficientAccountBalance', {}).

%% exception 'InvoicePaymentPending'
-record('payproc_InvoicePaymentPending', {
    'id' :: dmsl_domain_thrift:'InvoicePaymentID'()
}).

%% exception 'InvoicePaymentRefundPending'
-record('payproc_InvoicePaymentRefundPending', {
    'id' :: dmsl_domain_thrift:'InvoicePaymentRefundID'()
}).

%% exception 'InvoicePaymentAdjustmentPending'
-record('payproc_InvoicePaymentAdjustmentPending', {
    'id' :: dmsl_domain_thrift:'InvoicePaymentAdjustmentID'()
}).

%% exception 'InvalidInvoiceStatus'
-record('payproc_InvalidInvoiceStatus', {
    'status' :: dmsl_domain_thrift:'InvoiceStatus'()
}).

%% exception 'InvalidPaymentStatus'
-record('payproc_InvalidPaymentStatus', {
    'status' :: dmsl_domain_thrift:'InvoicePaymentStatus'()
}).

%% exception 'InvalidPaymentAdjustmentStatus'
-record('payproc_InvalidPaymentAdjustmentStatus', {
    'status' :: dmsl_domain_thrift:'InvoicePaymentAdjustmentStatus'()
}).

%% exception 'InvoiceTemplateNotFound'
-record('payproc_InvoiceTemplateNotFound', {}).

%% exception 'InvoiceTemplateRemoved'
-record('payproc_InvoiceTemplateRemoved', {}).

%% exception 'InvalidCustomerStatus'
-record('payproc_InvalidCustomerStatus', {
    'status' :: dmsl_payment_processing_thrift:'CustomerStatus'()
}).

%% exception 'CustomerNotFound'
-record('payproc_CustomerNotFound', {}).

%% exception 'InvalidPaymentTool'
-record('payproc_InvalidPaymentTool', {}).

%% exception 'InvalidBinding'
-record('payproc_InvalidBinding', {}).

%% exception 'BindingNotFound'
-record('payproc_BindingNotFound', {}).

%% exception 'RecurrentPaymentToolNotFound'
-record('payproc_RecurrentPaymentToolNotFound', {}).

%% exception 'InvalidPaymentMethod'
-record('payproc_InvalidPaymentMethod', {}).

%% exception 'InvalidRecurrentPaymentToolStatus'
-record('payproc_InvalidRecurrentPaymentToolStatus', {
    'status' :: dmsl_payment_processing_thrift:'RecurrentPaymentToolStatus'()
}).

%% exception 'NoLastEvent'
-record('payproc_NoLastEvent', {}).

%% exception 'PartyExists'
-record('payproc_PartyExists', {}).

%% exception 'ContractNotFound'
-record('payproc_ContractNotFound', {}).

%% exception 'ClaimNotFound'
-record('payproc_ClaimNotFound', {}).

%% exception 'InvalidClaimRevision'
-record('payproc_InvalidClaimRevision', {}).

%% exception 'InvalidClaimStatus'
-record('payproc_InvalidClaimStatus', {
    'status' :: dmsl_payment_processing_thrift:'ClaimStatus'()
}).

%% exception 'ChangesetConflict'
-record('payproc_ChangesetConflict', {
    'conflicted_id' :: dmsl_payment_processing_thrift:'ClaimID'()
}).

%% exception 'InvalidChangeset'
-record('payproc_InvalidChangeset', {
    'reason' :: dmsl_payment_processing_thrift:'InvalidChangesetReason'()
}).

%% exception 'AccountNotFound'
-record('payproc_AccountNotFound', {}).

%% exception 'ShopAccountNotFound'
-record('payproc_ShopAccountNotFound', {}).

%% exception 'PartyMetaNamespaceNotFound'
-record('payproc_PartyMetaNamespaceNotFound', {}).

-endif.
