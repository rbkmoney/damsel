-ifndef(dmsl_domain_thrift_included__).
-define(dmsl_domain_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_msgpack_thrift.hrl").
-include("dmsl_json_thrift.hrl").



%% struct 'ContactInfo'
-record('domain_ContactInfo', {
    'phone_number' :: binary() | undefined,
    'email' :: binary() | undefined
}).

%% struct 'OperationTimeout'
-record('domain_OperationTimeout', {}).

%% struct 'Failure'
-record('domain_Failure', {
    'code' :: dmsl_domain_thrift:'FailureCode'(),
    'reason' :: dmsl_domain_thrift:'FailureReason'() | undefined,
    'sub' :: dmsl_domain_thrift:'SubFailure'() | undefined
}).

%% struct 'SubFailure'
-record('domain_SubFailure', {
    'code' :: dmsl_domain_thrift:'FailureCode'(),
    'sub' :: dmsl_domain_thrift:'SubFailure'() | undefined
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
    'extra' :: dmsl_base_thrift:'StringMap'(),
    'additional_info' :: dmsl_domain_thrift:'AdditionalTransactionInfo'() | undefined
}).

%% struct 'AdditionalTransactionInfo'
-record('domain_AdditionalTransactionInfo', {
    'rrn' :: binary() | undefined,
    'approval_code' :: binary() | undefined,
    'acs_url' :: binary() | undefined,
    'pareq' :: binary() | undefined,
    'md' :: binary() | undefined,
    'term_url' :: binary() | undefined,
    'pares' :: binary() | undefined,
    'eci' :: binary() | undefined,
    'cavv' :: binary() | undefined,
    'xid' :: binary() | undefined,
    'cavv_algorithm' :: binary() | undefined,
    'three_ds_verification' :: dmsl_domain_thrift:'ThreeDsVerification'() | undefined,
    'short_payment_id' :: binary() | undefined
}).

%% struct 'Invoice'
-record('domain_Invoice', {
    'id' :: dmsl_domain_thrift:'InvoiceID'(),
    'owner_id' :: dmsl_domain_thrift:'PartyID'(),
    'party_revision' :: dmsl_domain_thrift:'PartyRevision'() | undefined,
    'shop_id' :: dmsl_domain_thrift:'ShopID'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'status' :: dmsl_domain_thrift:'InvoiceStatus'(),
    'details' :: dmsl_domain_thrift:'InvoiceDetails'(),
    'due' :: dmsl_base_thrift:'Timestamp'(),
    'cost' :: dmsl_domain_thrift:'Cash'(),
    'context' :: dmsl_domain_thrift:'InvoiceContext'() | undefined,
    'template_id' :: dmsl_domain_thrift:'InvoiceTemplateID'() | undefined,
    'external_id' :: binary() | undefined,
    'client_info' :: dmsl_domain_thrift:'InvoiceClientInfo'() | undefined
}).

%% struct 'InvoiceDetails'
-record('domain_InvoiceDetails', {
    'product' :: binary(),
    'description' :: binary() | undefined,
    'cart' :: dmsl_domain_thrift:'InvoiceCart'() | undefined,
    'bank_account' :: dmsl_domain_thrift:'InvoiceBankAccount'() | undefined
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

%% struct 'InvoiceRussianBankAccount'
-record('domain_InvoiceRussianBankAccount', {
    'account' :: binary(),
    'bank_bik' :: binary()
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
    'status' :: dmsl_domain_thrift:'InvoicePaymentStatus'(),
    'context' :: dmsl_domain_thrift:'InvoicePaymentContext'() | undefined,
    'cost' :: dmsl_domain_thrift:'Cash'(),
    'domain_revision' :: dmsl_domain_thrift:'DataRevision'(),
    'flow' :: dmsl_domain_thrift:'InvoicePaymentFlow'(),
    'payer' :: dmsl_domain_thrift:'Payer'(),
    'party_revision' :: dmsl_domain_thrift:'PartyRevision'() | undefined,
    'owner_id' :: dmsl_domain_thrift:'PartyID'() | undefined,
    'shop_id' :: dmsl_domain_thrift:'ShopID'() | undefined,
    'make_recurrent' :: boolean() | undefined,
    'external_id' :: binary() | undefined,
    'processing_deadline' :: dmsl_base_thrift:'Timestamp'() | undefined
}).

%% struct 'InvoicePaymentPending'
-record('domain_InvoicePaymentPending', {}).

%% struct 'InvoicePaymentProcessed'
-record('domain_InvoicePaymentProcessed', {}).

%% struct 'InvoicePaymentCaptured'
-record('domain_InvoicePaymentCaptured', {
    'reason' :: binary() | undefined,
    'cost' :: dmsl_domain_thrift:'Cash'() | undefined,
    'cart' :: dmsl_domain_thrift:'InvoiceCart'() | undefined
}).

%% struct 'InvoicePaymentCancelled'
-record('domain_InvoicePaymentCancelled', {
    'reason' :: binary() | undefined
}).

%% struct 'InvoicePaymentRefunded'
-record('domain_InvoicePaymentRefunded', {}).

%% struct 'InvoicePaymentFailed'
-record('domain_InvoicePaymentFailed', {
    'failure' :: dmsl_domain_thrift:'OperationFailure'()
}).

%% struct 'InvoicePaymentChargedBack'
-record('domain_InvoicePaymentChargedBack', {}).

%% struct 'InvoiceTemplate'
-record('domain_InvoiceTemplate', {
    'id' :: dmsl_domain_thrift:'InvoiceTemplateID'(),
    'owner_id' :: dmsl_domain_thrift:'PartyID'(),
    'shop_id' :: dmsl_domain_thrift:'ShopID'(),
    'invoice_lifetime' :: dmsl_domain_thrift:'LifetimeInterval'(),
    'product' :: binary(),
    'description' :: binary() | undefined,
    'details' :: dmsl_domain_thrift:'InvoiceTemplateDetails'(),
    'context' :: dmsl_domain_thrift:'InvoiceContext'() | undefined
}).

%% struct 'InvoiceTemplateProduct'
-record('domain_InvoiceTemplateProduct', {
    'product' :: binary(),
    'price' :: dmsl_domain_thrift:'InvoiceTemplateProductPrice'(),
    'metadata' :: #{binary() => dmsl_msgpack_thrift:'Value'()}
}).

%% struct 'InvoiceTemplateCostUnlimited'
-record('domain_InvoiceTemplateCostUnlimited', {}).

%% struct 'InvoiceClientInfo'
-record('domain_InvoiceClientInfo', {
    'trust_level' :: dmsl_domain_thrift:'ClientTrustLevel'() | undefined
}).

%% struct 'PaymentResourcePayer'
-record('domain_PaymentResourcePayer', {
    'resource' :: dmsl_domain_thrift:'DisposablePaymentResource'(),
    'contact_info' :: dmsl_domain_thrift:'ContactInfo'()
}).

%% struct 'CustomerPayer'
-record('domain_CustomerPayer', {
    'customer_id' :: dmsl_domain_thrift:'CustomerID'(),
    'customer_binding_id' :: dmsl_domain_thrift:'CustomerBindingID'(),
    'rec_payment_tool_id' :: dmsl_domain_thrift:'RecurrentPaymentToolID'(),
    'payment_tool' :: dmsl_domain_thrift:'PaymentTool'(),
    'contact_info' :: dmsl_domain_thrift:'ContactInfo'()
}).

%% struct 'RecurrentPayer'
-record('domain_RecurrentPayer', {
    'payment_tool' :: dmsl_domain_thrift:'PaymentTool'(),
    'recurrent_parent' :: dmsl_domain_thrift:'RecurrentParentPayment'(),
    'contact_info' :: dmsl_domain_thrift:'ContactInfo'()
}).

%% struct 'ClientInfo'
-record('domain_ClientInfo', {
    'ip_address' :: dmsl_domain_thrift:'IPAddress'() | undefined,
    'fingerprint' :: dmsl_domain_thrift:'Fingerprint'() | undefined
}).

%% struct 'PaymentRoute'
-record('domain_PaymentRoute', {
    'provider' :: dmsl_domain_thrift:'ProviderRef'(),
    'terminal' :: dmsl_domain_thrift:'TerminalRef'()
}).

%% struct 'RecurrentParentPayment'
-record('domain_RecurrentParentPayment', {
    'invoice_id' :: dmsl_domain_thrift:'InvoiceID'(),
    'payment_id' :: dmsl_domain_thrift:'InvoicePaymentID'()
}).

%% struct 'InvoiceAdjustment'
-record('domain_InvoiceAdjustment', {
    'id' :: dmsl_domain_thrift:'InvoiceAdjustmentID'(),
    'reason' :: binary(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'status' :: dmsl_domain_thrift:'InvoiceAdjustmentStatus'(),
    'domain_revision' :: dmsl_domain_thrift:'DataRevision'(),
    'party_revision' :: dmsl_domain_thrift:'PartyRevision'() | undefined,
    'state' :: dmsl_domain_thrift:'InvoiceAdjustmentState'() | undefined
}).

%% struct 'InvoiceAdjustmentPending'
-record('domain_InvoiceAdjustmentPending', {}).

%% struct 'InvoiceAdjustmentProcessed'
-record('domain_InvoiceAdjustmentProcessed', {}).

%% struct 'InvoiceAdjustmentCaptured'
-record('domain_InvoiceAdjustmentCaptured', {
    'at' :: dmsl_base_thrift:'Timestamp'()
}).

%% struct 'InvoiceAdjustmentCancelled'
-record('domain_InvoiceAdjustmentCancelled', {
    'at' :: dmsl_base_thrift:'Timestamp'()
}).

%% struct 'InvoiceAdjustmentStatusChangeState'
-record('domain_InvoiceAdjustmentStatusChangeState', {
    'scenario' :: dmsl_domain_thrift:'InvoiceAdjustmentStatusChange'()
}).

%% struct 'InvoiceAdjustmentStatusChange'
-record('domain_InvoiceAdjustmentStatusChange', {
    'target_status' :: dmsl_domain_thrift:'InvoiceStatus'()
}).

%% struct 'InvoicePaymentAdjustment'
-record('domain_InvoicePaymentAdjustment', {
    'id' :: dmsl_domain_thrift:'InvoicePaymentAdjustmentID'(),
    'status' :: dmsl_domain_thrift:'InvoicePaymentAdjustmentStatus'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'domain_revision' :: dmsl_domain_thrift:'DataRevision'(),
    'reason' :: binary(),
    'new_cash_flow' :: dmsl_domain_thrift:'FinalCashFlow'(),
    'old_cash_flow_inverse' :: dmsl_domain_thrift:'FinalCashFlow'(),
    'party_revision' :: dmsl_domain_thrift:'PartyRevision'() | undefined,
    'state' :: dmsl_domain_thrift:'InvoicePaymentAdjustmentState'() | undefined
}).

%% struct 'InvoicePaymentAdjustmentPending'
-record('domain_InvoicePaymentAdjustmentPending', {}).

%% struct 'InvoicePaymentAdjustmentProcessed'
-record('domain_InvoicePaymentAdjustmentProcessed', {}).

%% struct 'InvoicePaymentAdjustmentCaptured'
-record('domain_InvoicePaymentAdjustmentCaptured', {
    'at' :: dmsl_base_thrift:'Timestamp'()
}).

%% struct 'InvoicePaymentAdjustmentCancelled'
-record('domain_InvoicePaymentAdjustmentCancelled', {
    'at' :: dmsl_base_thrift:'Timestamp'()
}).

%% struct 'InvoicePaymentAdjustmentCashFlowState'
-record('domain_InvoicePaymentAdjustmentCashFlowState', {
    'scenario' :: dmsl_domain_thrift:'InvoicePaymentAdjustmentCashFlow'()
}).

%% struct 'InvoicePaymentAdjustmentStatusChangeState'
-record('domain_InvoicePaymentAdjustmentStatusChangeState', {
    'scenario' :: dmsl_domain_thrift:'InvoicePaymentAdjustmentStatusChange'()
}).

%% struct 'InvoicePaymentAdjustmentCashFlow'
-record('domain_InvoicePaymentAdjustmentCashFlow', {
    'domain_revision' :: dmsl_domain_thrift:'DataRevision'() | undefined
}).

%% struct 'InvoicePaymentAdjustmentStatusChange'
-record('domain_InvoicePaymentAdjustmentStatusChange', {
    'target_status' :: dmsl_domain_thrift:'InvoicePaymentStatus'()
}).

%% struct 'InvoicePaymentFlowInstant'
-record('domain_InvoicePaymentFlowInstant', {}).

%% struct 'InvoicePaymentFlowHold'
-record('domain_InvoicePaymentFlowHold', {
    'on_hold_expiration' :: dmsl_domain_thrift:'OnHoldExpiration'(),
    'held_until' :: dmsl_base_thrift:'Timestamp'()
}).

%% struct 'InvoicePaymentChargeback'
-record('domain_InvoicePaymentChargeback', {
    'id' :: dmsl_domain_thrift:'InvoicePaymentChargebackID'(),
    'status' :: dmsl_domain_thrift:'InvoicePaymentChargebackStatus'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'reason' :: dmsl_domain_thrift:'InvoicePaymentChargebackReason'(),
    'levy' :: dmsl_domain_thrift:'Cash'(),
    'body' :: dmsl_domain_thrift:'Cash'(),
    'stage' :: dmsl_domain_thrift:'InvoicePaymentChargebackStage'(),
    'domain_revision' :: dmsl_domain_thrift:'DataRevision'(),
    'party_revision' :: dmsl_domain_thrift:'PartyRevision'() | undefined,
    'context' :: dmsl_domain_thrift:'InvoicePaymentChargebackContext'() | undefined,
    'external_id' :: binary() | undefined
}).

%% struct 'InvoicePaymentChargebackReason'
-record('domain_InvoicePaymentChargebackReason', {
    'code' :: dmsl_domain_thrift:'ChargebackCode'() | undefined,
    'category' :: dmsl_domain_thrift:'InvoicePaymentChargebackCategory'()
}).

%% struct 'InvoicePaymentChargebackCategoryFraud'
-record('domain_InvoicePaymentChargebackCategoryFraud', {}).

%% struct 'InvoicePaymentChargebackCategoryDispute'
-record('domain_InvoicePaymentChargebackCategoryDispute', {}).

%% struct 'InvoicePaymentChargebackCategoryAuthorisation'
-record('domain_InvoicePaymentChargebackCategoryAuthorisation', {}).

%% struct 'InvoicePaymentChargebackCategoryProcessingError'
-record('domain_InvoicePaymentChargebackCategoryProcessingError', {}).

%% struct 'InvoicePaymentChargebackStageChargeback'
-record('domain_InvoicePaymentChargebackStageChargeback', {}).

%% struct 'InvoicePaymentChargebackStagePreArbitration'
-record('domain_InvoicePaymentChargebackStagePreArbitration', {}).

%% struct 'InvoicePaymentChargebackStageArbitration'
-record('domain_InvoicePaymentChargebackStageArbitration', {}).

%% struct 'InvoicePaymentChargebackPending'
-record('domain_InvoicePaymentChargebackPending', {}).

%% struct 'InvoicePaymentChargebackAccepted'
-record('domain_InvoicePaymentChargebackAccepted', {}).

%% struct 'InvoicePaymentChargebackRejected'
-record('domain_InvoicePaymentChargebackRejected', {}).

%% struct 'InvoicePaymentChargebackCancelled'
-record('domain_InvoicePaymentChargebackCancelled', {}).

%% struct 'InvoicePaymentRefund'
-record('domain_InvoicePaymentRefund', {
    'id' :: dmsl_domain_thrift:'InvoicePaymentRefundID'(),
    'status' :: dmsl_domain_thrift:'InvoicePaymentRefundStatus'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'domain_revision' :: dmsl_domain_thrift:'DataRevision'(),
    'party_revision' :: dmsl_domain_thrift:'PartyRevision'() | undefined,
    'cash' :: dmsl_domain_thrift:'Cash'() | undefined,
    'reason' :: binary() | undefined,
    'cart' :: dmsl_domain_thrift:'InvoiceCart'() | undefined,
    'external_id' :: binary() | undefined
}).

%% struct 'InvoicePaymentRefundPending'
-record('domain_InvoicePaymentRefundPending', {}).

%% struct 'InvoicePaymentRefundSucceeded'
-record('domain_InvoicePaymentRefundSucceeded', {}).

%% struct 'InvoicePaymentRefundFailed'
-record('domain_InvoicePaymentRefundFailed', {
    'failure' :: dmsl_domain_thrift:'OperationFailure'()
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
    'contractors' :: #{dmsl_domain_thrift:'ContractorID'() => dmsl_domain_thrift:'PartyContractor'()},
    'contracts' :: #{dmsl_domain_thrift:'ContractID'() => dmsl_domain_thrift:'Contract'()},
    'shops' :: #{dmsl_domain_thrift:'ShopID'() => dmsl_domain_thrift:'Shop'()},
    'wallets' :: #{dmsl_domain_thrift:'WalletID'() => dmsl_domain_thrift:'Wallet'()},
    'revision' :: dmsl_domain_thrift:'PartyRevision'()
}).

%% struct 'PartyStatus'
-record('domain_PartyStatus', {
    'id' :: dmsl_domain_thrift:'PartyID'(),
    'blocking' :: dmsl_domain_thrift:'Blocking'(),
    'suspension' :: dmsl_domain_thrift:'Suspension'(),
    'revision' :: dmsl_domain_thrift:'PartyRevision'()
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
    'payout_schedule' :: dmsl_domain_thrift:'BusinessScheduleRef'() | undefined
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

%% struct 'Wallet'
-record('domain_Wallet', {
    'id' :: dmsl_domain_thrift:'WalletID'(),
    'name' :: binary() | undefined,
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'blocking' :: dmsl_domain_thrift:'Blocking'(),
    'suspension' :: dmsl_domain_thrift:'Suspension'(),
    'contract' :: dmsl_domain_thrift:'ContractID'(),
    'account' :: dmsl_domain_thrift:'WalletAccount'() | undefined
}).

%% struct 'WalletAccount'
-record('domain_WalletAccount', {
    'currency' :: dmsl_domain_thrift:'CurrencyRef'(),
    'settlement' :: dmsl_domain_thrift:'AccountID'(),
    'payout' :: dmsl_domain_thrift:'AccountID'()
}).

%% struct 'PartyContractor'
-record('domain_PartyContractor', {
    'id' :: dmsl_domain_thrift:'ContractorID'(),
    'contractor' :: dmsl_domain_thrift:'Contractor'(),
    'status' :: dmsl_domain_thrift:'ContractorIdentificationLevel'(),
    'identity_documents' :: [dmsl_domain_thrift:'IdentityDocumentToken'()]
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
    'russian_bank_account' :: dmsl_domain_thrift:'RussianBankAccount'()
}).

%% struct 'InternationalLegalEntity'
-record('domain_InternationalLegalEntity', {
    'legal_name' :: binary(),
    'trading_name' :: binary() | undefined,
    'registered_address' :: binary(),
    'actual_address' :: binary() | undefined,
    'registered_number' :: binary() | undefined
}).

%% struct 'RussianBankAccount'
-record('domain_RussianBankAccount', {
    'account' :: binary(),
    'bank_name' :: binary(),
    'bank_post_account' :: binary(),
    'bank_bik' :: binary()
}).

%% struct 'InternationalBankAccount'
-record('domain_InternationalBankAccount', {
    'number' :: binary() | undefined,
    'bank' :: dmsl_domain_thrift:'InternationalBankDetails'() | undefined,
    'correspondent_account' :: dmsl_domain_thrift:'InternationalBankAccount'() | undefined,
    'iban' :: binary() | undefined,
    'account_holder' :: binary() | undefined
}).

%% struct 'InternationalBankDetails'
-record('domain_InternationalBankDetails', {
    'bic' :: binary() | undefined,
    'country' :: dmsl_domain_thrift:'Residence'() | undefined,
    'name' :: binary() | undefined,
    'address' :: binary() | undefined,
    'aba_rtn' :: binary() | undefined
}).

%% struct 'WalletInfo'
-record('domain_WalletInfo', {
    'wallet_id' :: dmsl_domain_thrift:'WalletID'()
}).

%% struct 'RussianPrivateEntity'
-record('domain_RussianPrivateEntity', {
    'first_name' :: binary(),
    'second_name' :: binary(),
    'middle_name' :: binary(),
    'contact_info' :: dmsl_domain_thrift:'ContactInfo'()
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
    'contractor_id' :: dmsl_domain_thrift:'ContractorID'() | undefined,
    'payment_institution' :: dmsl_domain_thrift:'PaymentInstitutionRef'() | undefined,
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'valid_since' :: dmsl_base_thrift:'Timestamp'() | undefined,
    'valid_until' :: dmsl_base_thrift:'Timestamp'() | undefined,
    'status' :: dmsl_domain_thrift:'ContractStatus'(),
    'terms' :: dmsl_domain_thrift:'TermSetHierarchyRef'(),
    'adjustments' :: [dmsl_domain_thrift:'ContractAdjustment'()],
    'payout_tools' :: [dmsl_domain_thrift:'PayoutTool'()],
    'legal_agreement' :: dmsl_domain_thrift:'LegalAgreement'() | undefined,
    'report_preferences' :: dmsl_domain_thrift:'ReportPreferences'() | undefined,
    'contractor' :: dmsl_domain_thrift:'Contractor'() | undefined
}).

%% struct 'LegalAgreement'
-record('domain_LegalAgreement', {
    'signed_at' :: dmsl_base_thrift:'Timestamp'(),
    'legal_agreement_id' :: binary(),
    'valid_until' :: dmsl_base_thrift:'Timestamp'() | undefined
}).

%% struct 'ReportPreferences'
-record('domain_ReportPreferences', {
    'service_acceptance_act_preferences' :: dmsl_domain_thrift:'ServiceAcceptanceActPreferences'() | undefined
}).

%% struct 'ServiceAcceptanceActPreferences'
-record('domain_ServiceAcceptanceActPreferences', {
    'schedule' :: dmsl_domain_thrift:'BusinessScheduleRef'(),
    'signer' :: dmsl_domain_thrift:'Representative'()
}).

%% struct 'Representative'
-record('domain_Representative', {
    'position' :: binary(),
    'full_name' :: binary(),
    'document' :: dmsl_domain_thrift:'RepresentativeDocument'()
}).

%% struct 'ArticlesOfAssociation'
-record('domain_ArticlesOfAssociation', {}).

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
    'days' :: integer() | undefined,
    'hours' :: integer() | undefined,
    'minutes' :: integer() | undefined,
    'seconds' :: integer() | undefined
}).

%% struct 'ContractTemplateDecision'
-record('domain_ContractTemplateDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'ContractTemplateSelector'()
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
    'payments' :: dmsl_domain_thrift:'PaymentsServiceTerms'() | undefined,
    'recurrent_paytools' :: dmsl_domain_thrift:'RecurrentPaytoolsServiceTerms'() | undefined,
    'payouts' :: dmsl_domain_thrift:'PayoutsServiceTerms'() | undefined,
    'reports' :: dmsl_domain_thrift:'ReportsServiceTerms'() | undefined,
    'wallets' :: dmsl_domain_thrift:'WalletServiceTerms'() | undefined
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
    'holds' :: dmsl_domain_thrift:'PaymentHoldsServiceTerms'() | undefined,
    'refunds' :: dmsl_domain_thrift:'PaymentRefundsServiceTerms'() | undefined,
    'chargebacks' :: dmsl_domain_thrift:'PaymentChargebackServiceTerms'() | undefined
}).

%% struct 'PaymentHoldsServiceTerms'
-record('domain_PaymentHoldsServiceTerms', {
    'payment_methods' :: dmsl_domain_thrift:'PaymentMethodSelector'() | undefined,
    'lifetime' :: dmsl_domain_thrift:'HoldLifetimeSelector'() | undefined,
    'partial_captures' :: dmsl_domain_thrift:'PartialCaptureServiceTerms'() | undefined
}).

%% struct 'PartialCaptureServiceTerms'
-record('domain_PartialCaptureServiceTerms', {}).

%% struct 'PaymentChargebackServiceTerms'
-record('domain_PaymentChargebackServiceTerms', {
    'allow' :: dmsl_domain_thrift:'Predicate'() | undefined,
    'fees' :: dmsl_domain_thrift:'CashFlowSelector'() | undefined,
    'eligibility_time' :: dmsl_domain_thrift:'TimeSpanSelector'() | undefined
}).

%% struct 'PaymentRefundsServiceTerms'
-record('domain_PaymentRefundsServiceTerms', {
    'payment_methods' :: dmsl_domain_thrift:'PaymentMethodSelector'() | undefined,
    'fees' :: dmsl_domain_thrift:'CashFlowSelector'() | undefined,
    'eligibility_time' :: dmsl_domain_thrift:'TimeSpanSelector'() | undefined,
    'partial_refunds' :: dmsl_domain_thrift:'PartialRefundsServiceTerms'() | undefined
}).

%% struct 'PartialRefundsServiceTerms'
-record('domain_PartialRefundsServiceTerms', {
    'cash_limit' :: dmsl_domain_thrift:'CashLimitSelector'() | undefined
}).

%% struct 'RecurrentPaytoolsServiceTerms'
-record('domain_RecurrentPaytoolsServiceTerms', {
    'payment_methods' :: dmsl_domain_thrift:'PaymentMethodSelector'() | undefined
}).

%% struct 'PayoutsServiceTerms'
-record('domain_PayoutsServiceTerms', {
    'payout_schedules' :: dmsl_domain_thrift:'BusinessScheduleSelector'() | undefined,
    'payout_methods' :: dmsl_domain_thrift:'PayoutMethodSelector'() | undefined,
    'cash_limit' :: dmsl_domain_thrift:'CashLimitSelector'() | undefined,
    'fees' :: dmsl_domain_thrift:'CashFlowSelector'() | undefined
}).

%% struct 'PayoutCompilationPolicy'
-record('domain_PayoutCompilationPolicy', {
    'assets_freeze_for' :: dmsl_base_thrift:'TimeSpan'()
}).

%% struct 'WalletServiceTerms'
-record('domain_WalletServiceTerms', {
    'currencies' :: dmsl_domain_thrift:'CurrencySelector'() | undefined,
    'wallet_limit' :: dmsl_domain_thrift:'CashLimitSelector'() | undefined,
    'turnover_limit' :: dmsl_domain_thrift:'CumulativeLimitSelector'() | undefined,
    'withdrawals' :: dmsl_domain_thrift:'WithdrawalServiceTerms'() | undefined,
    'p2p' :: dmsl_domain_thrift:'P2PServiceTerms'() | undefined,
    'w2w' :: dmsl_domain_thrift:'W2WServiceTerms'() | undefined
}).

%% struct 'CumulativeLimitDecision'
-record('domain_CumulativeLimitDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'CumulativeLimitSelector'()
}).

%% struct 'CumulativeLimit'
-record('domain_CumulativeLimit', {
    'period' :: dmsl_domain_thrift:'CumulativeLimitPeriod'(),
    'cash' :: dmsl_domain_thrift:'CashRange'()
}).

%% struct 'WithdrawalServiceTerms'
-record('domain_WithdrawalServiceTerms', {
    'currencies' :: dmsl_domain_thrift:'CurrencySelector'() | undefined,
    'cash_limit' :: dmsl_domain_thrift:'CashLimitSelector'() | undefined,
    'cash_flow' :: dmsl_domain_thrift:'CashFlowSelector'() | undefined,
    'attempt_limit' :: dmsl_domain_thrift:'AttemptLimitSelector'() | undefined
}).

%% struct 'P2PServiceTerms'
-record('domain_P2PServiceTerms', {
    'allow' :: dmsl_domain_thrift:'Predicate'() | undefined,
    'currencies' :: dmsl_domain_thrift:'CurrencySelector'() | undefined,
    'cash_limit' :: dmsl_domain_thrift:'CashLimitSelector'() | undefined,
    'cash_flow' :: dmsl_domain_thrift:'CashFlowSelector'() | undefined,
    'fees' :: dmsl_domain_thrift:'FeeSelector'() | undefined,
    'quote_lifetime' :: dmsl_domain_thrift:'LifetimeSelector'() | undefined,
    'templates' :: dmsl_domain_thrift:'P2PTemplateServiceTerms'() | undefined
}).

%% struct 'P2PTemplateServiceTerms'
-record('domain_P2PTemplateServiceTerms', {
    'allow' :: dmsl_domain_thrift:'Predicate'() | undefined
}).

%% struct 'W2WServiceTerms'
-record('domain_W2WServiceTerms', {
    'allow' :: dmsl_domain_thrift:'Predicate'() | undefined,
    'currencies' :: dmsl_domain_thrift:'CurrencySelector'() | undefined,
    'cash_limit' :: dmsl_domain_thrift:'CashLimitSelector'() | undefined,
    'cash_flow' :: dmsl_domain_thrift:'CashFlowSelector'() | undefined,
    'fees' :: dmsl_domain_thrift:'FeeSelector'() | undefined
}).

%% struct 'PayoutMethodRef'
-record('domain_PayoutMethodRef', {
    'id' :: atom()
}).

%% struct 'PayoutMethodDefinition'
-record('domain_PayoutMethodDefinition', {
    'name' :: binary(),
    'description' :: binary()
}).

%% struct 'PayoutMethodDecision'
-record('domain_PayoutMethodDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'PayoutMethodSelector'()
}).

%% struct 'ReportsServiceTerms'
-record('domain_ReportsServiceTerms', {
    'acts' :: dmsl_domain_thrift:'ServiceAcceptanceActsTerms'() | undefined
}).

%% struct 'ServiceAcceptanceActsTerms'
-record('domain_ServiceAcceptanceActsTerms', {
    'schedules' :: dmsl_domain_thrift:'BusinessScheduleSelector'() | undefined
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

%% struct 'BusinessScheduleRef'
-record('domain_BusinessScheduleRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'()
}).

%% struct 'BusinessSchedule'
-record('domain_BusinessSchedule', {
    'name' :: binary(),
    'description' :: binary() | undefined,
    'schedule' :: dmsl_base_thrift:'Schedule'(),
    'delay' :: dmsl_base_thrift:'TimeSpan'() | undefined,
    'policy' :: dmsl_domain_thrift:'PayoutCompilationPolicy'() | undefined
}).

%% struct 'BusinessScheduleDecision'
-record('domain_BusinessScheduleDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'BusinessScheduleSelector'()
}).

%% struct 'CalendarRef'
-record('domain_CalendarRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'()
}).

%% struct 'Calendar'
-record('domain_Calendar', {
    'name' :: binary(),
    'description' :: binary() | undefined,
    'timezone' :: dmsl_base_thrift:'Timezone'(),
    'holidays' :: dmsl_domain_thrift:'CalendarHolidaySet'(),
    'first_day_of_week' :: atom() | undefined
}).

%% struct 'CalendarHoliday'
-record('domain_CalendarHoliday', {
    'name' :: binary(),
    'description' :: binary() | undefined,
    'day' :: dmsl_base_thrift:'DayOfMonth'(),
    'month' :: atom()
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

%% struct 'TurnoverLimit'
-record('domain_TurnoverLimit', {
    'id' :: dmsl_domain_thrift:'TurnoverLimitID'(),
    'upper_boundary' :: dmsl_domain_thrift:'Amount'()
}).

%% struct 'TurnoverLimitDecision'
-record('domain_TurnoverLimitDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'TurnoverLimitSelector'()
}).

%% struct 'BankCardPaymentMethod'
-record('domain_BankCardPaymentMethod', {
    'payment_system' :: dmsl_domain_thrift:'BankCardPaymentSystem'(),
    'is_cvv_empty' = false :: boolean() | undefined,
    'token_provider' :: dmsl_domain_thrift:'BankCardTokenProvider'() | undefined,
    'tokenization_method' :: dmsl_domain_thrift:'TokenizationMethod'() | undefined
}).

%% struct 'TokenizedBankCard'
-record('domain_TokenizedBankCard', {
    'payment_system' :: dmsl_domain_thrift:'BankCardPaymentSystem'(),
    'token_provider' :: dmsl_domain_thrift:'BankCardTokenProvider'(),
    'tokenization_method' :: dmsl_domain_thrift:'TokenizationMethod'() | undefined
}).

%% struct 'P2PTool'
-record('domain_P2PTool', {
    'sender' :: dmsl_domain_thrift:'PaymentTool'(),
    'receiver' :: dmsl_domain_thrift:'PaymentTool'()
}).

%% struct 'DisposablePaymentResource'
-record('domain_DisposablePaymentResource', {
    'payment_tool' :: dmsl_domain_thrift:'PaymentTool'(),
    'payment_session_id' :: dmsl_domain_thrift:'PaymentSessionID'() | undefined,
    'client_info' :: dmsl_domain_thrift:'ClientInfo'() | undefined
}).

%% struct 'BankCard'
-record('domain_BankCard', {
    'token' :: dmsl_domain_thrift:'Token'(),
    'payment_system' :: atom(),
    'bin' :: binary(),
    'last_digits' :: binary(),
    'token_provider' :: atom() | undefined,
    'tokenization_method' :: atom() | undefined,
    'issuer_country' :: atom() | undefined,
    'bank_name' :: binary() | undefined,
    'metadata' :: #{binary() => dmsl_msgpack_thrift:'Value'()} | undefined,
    'is_cvv_empty' :: boolean() | undefined,
    'exp_date' :: dmsl_domain_thrift:'BankCardExpDate'() | undefined,
    'cardholder_name' :: binary() | undefined,
    'category' :: binary() | undefined
}).

%% struct 'BankCardExpDate'
-record('domain_BankCardExpDate', {
    'month' :: integer(),
    'year' :: integer()
}).

%% struct 'BankCardCategoryRef'
-record('domain_BankCardCategoryRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'()
}).

%% struct 'BankCardCategory'
-record('domain_BankCardCategory', {
    'name' :: binary(),
    'description' :: binary(),
    'category_patterns' :: ordsets:ordset(binary())
}).

%% struct 'CryptoWallet'
-record('domain_CryptoWallet', {
    'id' :: binary(),
    'crypto_currency' :: dmsl_domain_thrift:'CryptoCurrency'(),
    'destination_tag' :: binary() | undefined
}).

%% struct 'MobileCommerce'
-record('domain_MobileCommerce', {
    'operator' :: dmsl_domain_thrift:'MobileOperator'(),
    'phone' :: dmsl_domain_thrift:'MobilePhone'()
}).

%% struct 'MobilePhone'
-record('domain_MobilePhone', {
    'cc' :: binary(),
    'ctn' :: binary()
}).

%% struct 'PaymentTerminal'
-record('domain_PaymentTerminal', {
    'terminal_type' :: dmsl_domain_thrift:'TerminalPaymentProvider'()
}).

%% struct 'DigitalWallet'
-record('domain_DigitalWallet', {
    'provider' :: dmsl_domain_thrift:'DigitalWalletProvider'(),
    'id' :: dmsl_domain_thrift:'DigitalWalletID'(),
    'token' :: dmsl_domain_thrift:'Token'() | undefined
}).

%% struct 'BankRef'
-record('domain_BankRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'()
}).

%% struct 'Bank'
-record('domain_Bank', {
    'name' :: binary(),
    'description' :: binary(),
    'binbase_id_patterns' :: ordsets:ordset(binary()) | undefined,
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

%% struct 'HoldLifetime'
-record('domain_HoldLifetime', {
    'seconds' :: integer()
}).

%% struct 'HoldLifetimeDecision'
-record('domain_HoldLifetimeDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'HoldLifetimeSelector'()
}).

%% struct 'TimeSpanDecision'
-record('domain_TimeSpanDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'TimeSpanSelector'()
}).

%% struct 'LifetimeDecision'
-record('domain_LifetimeDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'LifetimeSelector'()
}).

%% struct 'Fees'
-record('domain_Fees', {
    'fees' :: #{atom() => dmsl_domain_thrift:'CashVolume'()}
}).

%% struct 'VectorClock'
-record('domain_VectorClock', {
    'state' :: dmsl_base_thrift:'Opaque'()
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
    'of' :: atom(),
    'rounding_method' :: dmsl_domain_thrift:'RoundingMethod'() | undefined
}).

%% struct 'CashFlowDecision'
-record('domain_CashFlowDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'CashFlowSelector'()
}).

%% struct 'FeeDecision'
-record('domain_FeeDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'FeeSelector'()
}).

%% struct 'AttemptLimitDesision'
-record('domain_AttemptLimitDesision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'AttemptLimitSelector'()
}).

%% struct 'AttemptLimit'
-record('domain_AttemptLimit', {
    'attempts' :: integer()
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
    'identity' :: binary() | undefined,
    'accounts' = #{} :: dmsl_domain_thrift:'ProviderAccountSet'() | undefined,
    'terms' :: dmsl_domain_thrift:'ProvisionTermSet'() | undefined,
    'params_schema' :: [dmsl_domain_thrift:'ProviderParameter'()] | undefined,
    'abs_account' :: binary() | undefined,
    'payment_terms' :: dmsl_domain_thrift:'PaymentsProvisionTerms'() | undefined,
    'recurrent_paytool_terms' :: dmsl_domain_thrift:'RecurrentPaytoolsProvisionTerms'() | undefined,
    'terminal' :: dmsl_domain_thrift:'TerminalSelector'() | undefined
}).

%% struct 'CashRegisterProviderRef'
-record('domain_CashRegisterProviderRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'()
}).

%% struct 'CashRegisterProvider'
-record('domain_CashRegisterProvider', {
    'name' :: binary(),
    'description' :: binary() | undefined,
    'params_schema' :: [dmsl_domain_thrift:'ProviderParameter'()],
    'proxy' :: dmsl_domain_thrift:'Proxy'()
}).

%% struct 'ProviderParameter'
-record('domain_ProviderParameter', {
    'id' :: binary(),
    'description' :: binary() | undefined,
    'type' :: dmsl_domain_thrift:'ProviderParameterType'(),
    'is_required' :: boolean()
}).

%% struct 'ProviderParameterString'
-record('domain_ProviderParameterString', {}).

%% struct 'ProviderParameterInteger'
-record('domain_ProviderParameterInteger', {}).

%% struct 'ProviderParameterUrl'
-record('domain_ProviderParameterUrl', {}).

%% struct 'ProviderParameterPassword'
-record('domain_ProviderParameterPassword', {}).

%% struct 'WithdrawalProviderRef'
-record('domain_WithdrawalProviderRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'()
}).

%% struct 'WithdrawalProvider'
-record('domain_WithdrawalProvider', {
    'name' :: binary(),
    'description' :: binary() | undefined,
    'proxy' :: dmsl_domain_thrift:'Proxy'(),
    'identity' :: binary() | undefined,
    'withdrawal_terms' :: dmsl_domain_thrift:'WithdrawalProvisionTerms'() | undefined,
    'accounts' = #{} :: dmsl_domain_thrift:'ProviderAccountSet'() | undefined,
    'terminal' :: dmsl_domain_thrift:'WithdrawalTerminalSelector'() | undefined
}).

%% struct 'P2PProviderRef'
-record('domain_P2PProviderRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'()
}).

%% struct 'P2PProvider'
-record('domain_P2PProvider', {
    'name' :: binary(),
    'description' :: binary() | undefined,
    'proxy' :: dmsl_domain_thrift:'Proxy'(),
    'identity' :: binary() | undefined,
    'p2p_terms' :: dmsl_domain_thrift:'P2PProvisionTerms'() | undefined,
    'accounts' = #{} :: dmsl_domain_thrift:'ProviderAccountSet'() | undefined
}).

%% struct 'ProvisionTermSet'
-record('domain_ProvisionTermSet', {
    'payments' :: dmsl_domain_thrift:'PaymentsProvisionTerms'() | undefined,
    'recurrent_paytools' :: dmsl_domain_thrift:'RecurrentPaytoolsProvisionTerms'() | undefined,
    'wallet' :: dmsl_domain_thrift:'WalletProvisionTerms'() | undefined
}).

%% struct 'PaymentsProvisionTerms'
-record('domain_PaymentsProvisionTerms', {
    'allow' :: dmsl_domain_thrift:'Predicate'() | undefined,
    'currencies' :: dmsl_domain_thrift:'CurrencySelector'() | undefined,
    'categories' :: dmsl_domain_thrift:'CategorySelector'() | undefined,
    'payment_methods' :: dmsl_domain_thrift:'PaymentMethodSelector'() | undefined,
    'cash_limit' :: dmsl_domain_thrift:'CashLimitSelector'() | undefined,
    'cash_flow' :: dmsl_domain_thrift:'CashFlowSelector'() | undefined,
    'holds' :: dmsl_domain_thrift:'PaymentHoldsProvisionTerms'() | undefined,
    'refunds' :: dmsl_domain_thrift:'PaymentRefundsProvisionTerms'() | undefined,
    'chargebacks' :: dmsl_domain_thrift:'PaymentChargebackProvisionTerms'() | undefined,
    'risk_coverage' :: dmsl_domain_thrift:'RiskScoreSelector'() | undefined,
    'turnover_limits' :: dmsl_domain_thrift:'TurnoverLimitSelector'() | undefined
}).

%% struct 'RiskScoreDecision'
-record('domain_RiskScoreDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'RiskScoreSelector'()
}).

%% struct 'PaymentHoldsProvisionTerms'
-record('domain_PaymentHoldsProvisionTerms', {
    'lifetime' :: dmsl_domain_thrift:'HoldLifetimeSelector'(),
    'partial_captures' :: dmsl_domain_thrift:'PartialCaptureProvisionTerms'() | undefined
}).

%% struct 'PartialCaptureProvisionTerms'
-record('domain_PartialCaptureProvisionTerms', {}).

%% struct 'PaymentChargebackProvisionTerms'
-record('domain_PaymentChargebackProvisionTerms', {
    'cash_flow' :: dmsl_domain_thrift:'CashFlowSelector'(),
    'fees' :: dmsl_domain_thrift:'FeeSelector'() | undefined
}).

%% struct 'PaymentRefundsProvisionTerms'
-record('domain_PaymentRefundsProvisionTerms', {
    'cash_flow' :: dmsl_domain_thrift:'CashFlowSelector'(),
    'partial_refunds' :: dmsl_domain_thrift:'PartialRefundsProvisionTerms'() | undefined
}).

%% struct 'PartialRefundsProvisionTerms'
-record('domain_PartialRefundsProvisionTerms', {
    'cash_limit' :: dmsl_domain_thrift:'CashLimitSelector'()
}).

%% struct 'RecurrentPaytoolsProvisionTerms'
-record('domain_RecurrentPaytoolsProvisionTerms', {
    'cash_value' :: dmsl_domain_thrift:'CashValueSelector'(),
    'categories' :: dmsl_domain_thrift:'CategorySelector'(),
    'payment_methods' :: dmsl_domain_thrift:'PaymentMethodSelector'(),
    'risk_coverage' :: dmsl_domain_thrift:'RiskScoreSelector'() | undefined
}).

%% struct 'WalletProvisionTerms'
-record('domain_WalletProvisionTerms', {
    'turnover_limit' :: dmsl_domain_thrift:'CumulativeLimitSelector'() | undefined,
    'withdrawals' :: dmsl_domain_thrift:'WithdrawalProvisionTerms'() | undefined,
    'p2p' :: dmsl_domain_thrift:'P2PProvisionTerms'() | undefined
}).

%% struct 'WithdrawalProvisionTerms'
-record('domain_WithdrawalProvisionTerms', {
    'allow' :: dmsl_domain_thrift:'Predicate'() | undefined,
    'currencies' :: dmsl_domain_thrift:'CurrencySelector'() | undefined,
    'payout_methods' :: dmsl_domain_thrift:'PayoutMethodSelector'() | undefined,
    'cash_limit' :: dmsl_domain_thrift:'CashLimitSelector'() | undefined,
    'cash_flow' :: dmsl_domain_thrift:'CashFlowSelector'() | undefined
}).

%% struct 'P2PProvisionTerms'
-record('domain_P2PProvisionTerms', {
    'allow' :: dmsl_domain_thrift:'Predicate'() | undefined,
    'currencies' :: dmsl_domain_thrift:'CurrencySelector'() | undefined,
    'cash_limit' :: dmsl_domain_thrift:'CashLimitSelector'() | undefined,
    'cash_flow' :: dmsl_domain_thrift:'CashFlowSelector'() | undefined,
    'fees' :: dmsl_domain_thrift:'FeeSelector'() | undefined
}).

%% struct 'CashValueDecision'
-record('domain_CashValueDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'CashValueSelector'()
}).

%% struct 'ProviderAccount'
-record('domain_ProviderAccount', {
    'settlement' :: dmsl_domain_thrift:'AccountID'()
}).

%% struct 'ProviderDecision'
-record('domain_ProviderDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'ProviderSelector'()
}).

%% struct 'WithdrawalProviderDecision'
-record('domain_WithdrawalProviderDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'WithdrawalProviderSelector'()
}).

%% struct 'P2PProviderDecision'
-record('domain_P2PProviderDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'P2PProviderSelector'()
}).

%% struct 'InspectorRef'
-record('domain_InspectorRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'()
}).

%% struct 'Inspector'
-record('domain_Inspector', {
    'name' :: binary(),
    'description' :: binary(),
    'proxy' :: dmsl_domain_thrift:'Proxy'(),
    'fallback_risk_score' :: atom() | undefined
}).

%% struct 'InspectorDecision'
-record('domain_InspectorDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'InspectorSelector'()
}).

%% struct 'P2PInspectorRef'
-record('domain_P2PInspectorRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'()
}).

%% struct 'P2PInspector'
-record('domain_P2PInspector', {
    'name' :: binary(),
    'description' :: binary(),
    'proxy' :: dmsl_domain_thrift:'Proxy'(),
    'fallback_risk_score' :: #{dmsl_domain_thrift:'ScoreID'() => atom()} | undefined
}).

%% struct 'P2PInspectorDecision'
-record('domain_P2PInspectorDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'P2PInspectorSelector'()
}).

%% struct 'Terminal'
-record('domain_Terminal', {
    'name' :: binary(),
    'description' :: binary(),
    'options' :: dmsl_domain_thrift:'ProxyOptions'() | undefined,
    'risk_coverage' :: atom() | undefined,
    'provider_ref' :: dmsl_domain_thrift:'ProviderRef'() | undefined,
    'terms' :: dmsl_domain_thrift:'ProvisionTermSet'() | undefined,
    'external_terminal_id' :: dmsl_domain_thrift:'ExternalTerminalID'() | undefined,
    'external_merchant_id' :: dmsl_domain_thrift:'MerchantID'() | undefined,
    'mcc' :: dmsl_domain_thrift:'MerchantCategoryCode'() | undefined,
    'terms_legacy' :: dmsl_domain_thrift:'PaymentsProvisionTerms'() | undefined
}).

%% struct 'TerminalDecision'
-record('domain_TerminalDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'TerminalSelector'()
}).

%% struct 'ProviderTerminalRef'
-record('domain_ProviderTerminalRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'(),
    'priority' = 1000 :: integer() | undefined,
    'weight' :: integer() | undefined
}).

%% struct 'TerminalRef'
-record('domain_TerminalRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'()
}).

%% struct 'WithdrawalTerminalRef'
-record('domain_WithdrawalTerminalRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'(),
    'priority' = 1000 :: integer() | undefined
}).

%% struct 'WithdrawalTerminal'
-record('domain_WithdrawalTerminal', {
    'name' :: binary(),
    'description' :: binary() | undefined,
    'options' :: dmsl_domain_thrift:'ProxyOptions'() | undefined,
    'terms' :: dmsl_domain_thrift:'WithdrawalProvisionTerms'() | undefined,
    'provider_ref' :: dmsl_domain_thrift:'WithdrawalProviderRef'() | undefined
}).

%% struct 'WithdrawalTerminalDecision'
-record('domain_WithdrawalTerminalDecision', {
    'if_' :: dmsl_domain_thrift:'Predicate'(),
    'then_' :: dmsl_domain_thrift:'WithdrawalTerminalSelector'()
}).

%% struct 'P2PToolCondition'
-record('domain_P2PToolCondition', {
    'sender_is' :: dmsl_domain_thrift:'PaymentToolCondition'() | undefined,
    'receiver_is' :: dmsl_domain_thrift:'PaymentToolCondition'() | undefined
}).

%% struct 'BankCardCondition'
-record('domain_BankCardCondition', {
    'definition' :: dmsl_domain_thrift:'BankCardConditionDefinition'() | undefined
}).

%% struct 'PaymentSystemCondition'
-record('domain_PaymentSystemCondition', {
    'payment_system_is' :: atom(),
    'token_provider_is' :: atom() | undefined,
    'tokenization_method_is' :: atom() | undefined
}).

%% struct 'PaymentTerminalCondition'
-record('domain_PaymentTerminalCondition', {
    'definition' :: dmsl_domain_thrift:'PaymentTerminalConditionDefinition'() | undefined
}).

%% struct 'DigitalWalletCondition'
-record('domain_DigitalWalletCondition', {
    'definition' :: dmsl_domain_thrift:'DigitalWalletConditionDefinition'() | undefined
}).

%% struct 'CryptoCurrencyCondition'
-record('domain_CryptoCurrencyCondition', {
    'definition' :: dmsl_domain_thrift:'CryptoCurrencyConditionDefinition'() | undefined
}).

%% struct 'MobileCommerceCondition'
-record('domain_MobileCommerceCondition', {
    'definition' :: dmsl_domain_thrift:'MobileCommerceConditionDefinition'() | undefined
}).

%% struct 'PartyCondition'
-record('domain_PartyCondition', {
    'id' :: dmsl_domain_thrift:'PartyID'(),
    'definition' :: dmsl_domain_thrift:'PartyConditionDefinition'() | undefined
}).

%% struct 'CriterionRef'
-record('domain_CriterionRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'()
}).

%% struct 'Criterion'
-record('domain_Criterion', {
    'name' :: binary(),
    'description' :: binary() | undefined,
    'predicate' :: dmsl_domain_thrift:'Predicate'()
}).

%% struct 'DocumentTypeRef'
-record('domain_DocumentTypeRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'()
}).

%% struct 'DocumentType'
-record('domain_DocumentType', {
    'name' :: binary(),
    'description' :: binary() | undefined
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
    'settlement' :: dmsl_domain_thrift:'AccountID'(),
    'subagent' :: dmsl_domain_thrift:'AccountID'() | undefined
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

%% struct 'PaymentInstitutionRef'
-record('domain_PaymentInstitutionRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'()
}).

%% struct 'PaymentInstitution'
-record('domain_PaymentInstitution', {
    'name' :: binary(),
    'description' :: binary() | undefined,
    'calendar' :: dmsl_domain_thrift:'CalendarRef'() | undefined,
    'system_account_set' :: dmsl_domain_thrift:'SystemAccountSetSelector'(),
    'default_contract_template' :: dmsl_domain_thrift:'ContractTemplateSelector'(),
    'default_wallet_contract_template' :: dmsl_domain_thrift:'ContractTemplateSelector'() | undefined,
    'inspector' :: dmsl_domain_thrift:'InspectorSelector'(),
    'realm' :: dmsl_domain_thrift:'PaymentInstitutionRealm'(),
    'residences' :: ordsets:ordset(atom()),
    'wallet_system_account_set' :: dmsl_domain_thrift:'SystemAccountSetSelector'() | undefined,
    'identity' :: binary() | undefined,
    'p2p_inspector' :: dmsl_domain_thrift:'P2PInspectorSelector'() | undefined,
    'payment_routing_rules' :: dmsl_domain_thrift:'RoutingRules'() | undefined,
    'withdrawal_routing_rules' :: dmsl_domain_thrift:'RoutingRules'() | undefined,
    'p2p_transfer_routing_rules' :: dmsl_domain_thrift:'RoutingRules'() | undefined,
    'withdrawal_providers' :: dmsl_domain_thrift:'ProviderSelector'() | undefined,
    'p2p_providers' :: dmsl_domain_thrift:'ProviderSelector'() | undefined,
    'withdrawal_providers_legacy' :: dmsl_domain_thrift:'WithdrawalProviderSelector'() | undefined,
    'p2p_providers_legacy' :: dmsl_domain_thrift:'P2PProviderSelector'() | undefined,
    'providers' :: dmsl_domain_thrift:'ProviderSelector'() | undefined
}).

%% struct 'ContractPaymentInstitutionDefaults'
-record('domain_ContractPaymentInstitutionDefaults', {
    'test' :: dmsl_domain_thrift:'PaymentInstitutionRef'(),
    'live' :: dmsl_domain_thrift:'PaymentInstitutionRef'()
}).

%% struct 'RoutingRules'
-record('domain_RoutingRules', {
    'policies' :: dmsl_domain_thrift:'RoutingRulesetRef'(),
    'prohibitions' :: dmsl_domain_thrift:'RoutingRulesetRef'()
}).

%% struct 'RoutingRulesetRef'
-record('domain_RoutingRulesetRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'()
}).

%% struct 'RoutingRuleset'
-record('domain_RoutingRuleset', {
    'name' :: binary(),
    'description' :: binary() | undefined,
    'decisions' :: dmsl_domain_thrift:'RoutingDecisions'()
}).

%% struct 'RoutingDelegate'
-record('domain_RoutingDelegate', {
    'description' :: binary() | undefined,
    'allowed' :: dmsl_domain_thrift:'Predicate'(),
    'ruleset' :: dmsl_domain_thrift:'RoutingRulesetRef'()
}).

%% struct 'RoutingCandidate'
-record('domain_RoutingCandidate', {
    'description' :: binary() | undefined,
    'allowed' :: dmsl_domain_thrift:'Predicate'(),
    'terminal' :: dmsl_domain_thrift:'TerminalRef'(),
    'weight' :: integer() | undefined,
    'priority' = 1000 :: integer() | undefined
}).

%% struct 'PartyPrototypeRef'
-record('domain_PartyPrototypeRef', {
    'id' :: dmsl_domain_thrift:'ObjectID'()
}).

%% struct 'PartyPrototype'
-record('domain_PartyPrototype', {}).

%% struct 'PartyPrototypeObject'
-record('domain_PartyPrototypeObject', {
    'ref' :: dmsl_domain_thrift:'PartyPrototypeRef'(),
    'data' :: dmsl_domain_thrift:'PartyPrototype'()
}).

%% struct 'GlobalsRef'
-record('domain_GlobalsRef', {}).

%% struct 'Globals'
-record('domain_Globals', {
    'external_account_set' :: dmsl_domain_thrift:'ExternalAccountSetSelector'(),
    'payment_institutions' :: ordsets:ordset(dmsl_domain_thrift:'PaymentInstitutionRef'()) | undefined,
    'contract_payment_institution_defaults' :: dmsl_domain_thrift:'ContractPaymentInstitutionDefaults'() | undefined
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

%% struct 'BusinessScheduleObject'
-record('domain_BusinessScheduleObject', {
    'ref' :: dmsl_domain_thrift:'BusinessScheduleRef'(),
    'data' :: dmsl_domain_thrift:'BusinessSchedule'()
}).

%% struct 'CalendarObject'
-record('domain_CalendarObject', {
    'ref' :: dmsl_domain_thrift:'CalendarRef'(),
    'data' :: dmsl_domain_thrift:'Calendar'()
}).

%% struct 'PaymentMethodObject'
-record('domain_PaymentMethodObject', {
    'ref' :: dmsl_domain_thrift:'PaymentMethodRef'(),
    'data' :: dmsl_domain_thrift:'PaymentMethodDefinition'()
}).

%% struct 'PayoutMethodObject'
-record('domain_PayoutMethodObject', {
    'ref' :: dmsl_domain_thrift:'PayoutMethodRef'(),
    'data' :: dmsl_domain_thrift:'PayoutMethodDefinition'()
}).

%% struct 'BankObject'
-record('domain_BankObject', {
    'ref' :: dmsl_domain_thrift:'BankRef'(),
    'data' :: dmsl_domain_thrift:'Bank'()
}).

%% struct 'BankCardCategoryObject'
-record('domain_BankCardCategoryObject', {
    'ref' :: dmsl_domain_thrift:'BankCardCategoryRef'(),
    'data' :: dmsl_domain_thrift:'BankCardCategory'()
}).

%% struct 'ProviderObject'
-record('domain_ProviderObject', {
    'ref' :: dmsl_domain_thrift:'ProviderRef'(),
    'data' :: dmsl_domain_thrift:'Provider'()
}).

%% struct 'CashRegisterProviderObject'
-record('domain_CashRegisterProviderObject', {
    'ref' :: dmsl_domain_thrift:'CashRegisterProviderRef'(),
    'data' :: dmsl_domain_thrift:'CashRegisterProvider'()
}).

%% struct 'WithdrawalProviderObject'
-record('domain_WithdrawalProviderObject', {
    'ref' :: dmsl_domain_thrift:'WithdrawalProviderRef'(),
    'data' :: dmsl_domain_thrift:'WithdrawalProvider'()
}).

%% struct 'P2PProviderObject'
-record('domain_P2PProviderObject', {
    'ref' :: dmsl_domain_thrift:'P2PProviderRef'(),
    'data' :: dmsl_domain_thrift:'P2PProvider'()
}).

%% struct 'TerminalObject'
-record('domain_TerminalObject', {
    'ref' :: dmsl_domain_thrift:'TerminalRef'(),
    'data' :: dmsl_domain_thrift:'Terminal'()
}).

%% struct 'WithdrawalTerminalObject'
-record('domain_WithdrawalTerminalObject', {
    'ref' :: dmsl_domain_thrift:'WithdrawalTerminalRef'(),
    'data' :: dmsl_domain_thrift:'WithdrawalTerminal'()
}).

%% struct 'InspectorObject'
-record('domain_InspectorObject', {
    'ref' :: dmsl_domain_thrift:'InspectorRef'(),
    'data' :: dmsl_domain_thrift:'Inspector'()
}).

%% struct 'P2PInspectorObject'
-record('domain_P2PInspectorObject', {
    'ref' :: dmsl_domain_thrift:'P2PInspectorRef'(),
    'data' :: dmsl_domain_thrift:'P2PInspector'()
}).

%% struct 'PaymentInstitutionObject'
-record('domain_PaymentInstitutionObject', {
    'ref' :: dmsl_domain_thrift:'PaymentInstitutionRef'(),
    'data' :: dmsl_domain_thrift:'PaymentInstitution'()
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

%% struct 'GlobalsObject'
-record('domain_GlobalsObject', {
    'ref' :: dmsl_domain_thrift:'GlobalsRef'(),
    'data' :: dmsl_domain_thrift:'Globals'()
}).

%% struct 'RoutingRulesObject'
-record('domain_RoutingRulesObject', {
    'ref' :: dmsl_domain_thrift:'RoutingRulesetRef'(),
    'data' :: dmsl_domain_thrift:'RoutingRuleset'()
}).

%% struct 'CriterionObject'
-record('domain_CriterionObject', {
    'ref' :: dmsl_domain_thrift:'CriterionRef'(),
    'data' :: dmsl_domain_thrift:'Criterion'()
}).

%% struct 'DocumentTypeObject'
-record('domain_DocumentTypeObject', {
    'ref' :: dmsl_domain_thrift:'DocumentTypeRef'(),
    'data' :: dmsl_domain_thrift:'DocumentType'()
}).

-endif.
