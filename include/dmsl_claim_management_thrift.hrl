-ifndef(dmsl_claim_management_thrift_included__).
-define(dmsl_claim_management_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_domain_thrift.hrl").
-include("dmsl_msgpack_thrift.hrl").



%% struct 'ContractEffectUnit'
-record('claim_management_ContractEffectUnit', {
    'contract_id' :: dmsl_domain_thrift:'ContractID'(),
    'effect' :: dmsl_claim_management_thrift:'ContractEffect'()
}).

%% struct 'ContractorEffectUnit'
-record('claim_management_ContractorEffectUnit', {
    'id' :: dmsl_domain_thrift:'ContractorID'(),
    'effect' :: dmsl_claim_management_thrift:'ContractorEffect'()
}).

%% struct 'ScheduleChanged'
-record('claim_management_ScheduleChanged', {
    'schedule' :: dmsl_domain_thrift:'BusinessScheduleRef'() | undefined
}).

%% struct 'PayoutToolInfoChanged'
-record('claim_management_PayoutToolInfoChanged', {
    'payout_tool_id' :: dmsl_domain_thrift:'PayoutToolID'(),
    'info' :: dmsl_domain_thrift:'PayoutToolInfo'()
}).

%% struct 'ShopEffectUnit'
-record('claim_management_ShopEffectUnit', {
    'shop_id' :: dmsl_domain_thrift:'ShopID'(),
    'effect' :: dmsl_claim_management_thrift:'ShopEffect'()
}).

%% struct 'ShopContractChanged'
-record('claim_management_ShopContractChanged', {
    'contract_id' :: dmsl_domain_thrift:'ContractID'(),
    'payout_tool_id' :: dmsl_domain_thrift:'PayoutToolID'()
}).

%% struct 'PayoutToolParams'
-record('claim_management_PayoutToolParams', {
    'currency' :: dmsl_domain_thrift:'CurrencyRef'(),
    'tool_info' :: dmsl_domain_thrift:'PayoutToolInfo'()
}).

%% struct 'ContractParams'
-record('claim_management_ContractParams', {
    'contractor_id' :: dmsl_domain_thrift:'ContractorID'() | undefined,
    'template' :: dmsl_domain_thrift:'ContractTemplateRef'() | undefined,
    'payment_institution' :: dmsl_domain_thrift:'PaymentInstitutionRef'() | undefined
}).

%% struct 'ShopModificationUnit'
-record('claim_management_ShopModificationUnit', {
    'id' :: dmsl_domain_thrift:'ShopID'(),
    'modification' :: dmsl_claim_management_thrift:'ShopModification'()
}).

%% struct 'ShopContractModification'
-record('claim_management_ShopContractModification', {
    'contract_id' :: dmsl_domain_thrift:'ContractID'(),
    'payout_tool_id' :: dmsl_domain_thrift:'PayoutToolID'()
}).

%% struct 'ScheduleModification'
-record('claim_management_ScheduleModification', {
    'schedule' :: dmsl_domain_thrift:'BusinessScheduleRef'() | undefined
}).

%% struct 'ShopAccountParams'
-record('claim_management_ShopAccountParams', {
    'currency' :: dmsl_domain_thrift:'CurrencyRef'()
}).

%% struct 'ShopParams'
-record('claim_management_ShopParams', {
    'category' :: dmsl_domain_thrift:'CategoryRef'(),
    'location' :: dmsl_domain_thrift:'ShopLocation'(),
    'details' :: dmsl_domain_thrift:'ShopDetails'(),
    'contract_id' :: dmsl_domain_thrift:'ContractID'(),
    'payout_tool_id' :: dmsl_domain_thrift:'PayoutToolID'()
}).

%% struct 'ContractorModificationUnit'
-record('claim_management_ContractorModificationUnit', {
    'id' :: dmsl_domain_thrift:'ContractorID'(),
    'modification' :: dmsl_claim_management_thrift:'ContractorModification'()
}).

%% struct 'ContractorIdentityDocumentsModification'
-record('claim_management_ContractorIdentityDocumentsModification', {
    'identity_documents' :: [dmsl_domain_thrift:'IdentityDocumentToken'()]
}).

%% struct 'ContractModificationUnit'
-record('claim_management_ContractModificationUnit', {
    'id' :: dmsl_domain_thrift:'ContractID'(),
    'modification' :: dmsl_claim_management_thrift:'ContractModification'()
}).

%% struct 'ContractTermination'
-record('claim_management_ContractTermination', {
    'reason' :: binary() | undefined
}).

%% struct 'ContractAdjustmentModificationUnit'
-record('claim_management_ContractAdjustmentModificationUnit', {
    'adjustment_id' :: dmsl_domain_thrift:'ContractAdjustmentID'(),
    'modification' :: dmsl_claim_management_thrift:'ContractAdjustmentModification'()
}).

%% struct 'ContractAdjustmentParams'
-record('claim_management_ContractAdjustmentParams', {
    'template' :: dmsl_domain_thrift:'ContractTemplateRef'()
}).

%% struct 'PayoutToolModificationUnit'
-record('claim_management_PayoutToolModificationUnit', {
    'payout_tool_id' :: dmsl_domain_thrift:'PayoutToolID'(),
    'modification' :: dmsl_claim_management_thrift:'PayoutToolModification'()
}).

%% struct 'DocumentCreated'
-record('claim_management_DocumentCreated', {}).

%% struct 'DocumentModificationUnit'
-record('claim_management_DocumentModificationUnit', {
    'id' :: dmsl_claim_management_thrift:'DocumentID'(),
    'modification' :: dmsl_claim_management_thrift:'DocumentModification'()
}).

%% struct 'FileCreated'
-record('claim_management_FileCreated', {}).

%% struct 'FileModificationUnit'
-record('claim_management_FileModificationUnit', {
    'id' :: dmsl_claim_management_thrift:'FileID'(),
    'modification' :: dmsl_claim_management_thrift:'FileModification'()
}).

%% struct 'CommentCreated'
-record('claim_management_CommentCreated', {}).

%% struct 'CommentModificationUnit'
-record('claim_management_CommentModificationUnit', {
    'id' :: dmsl_claim_management_thrift:'CommentID'(),
    'modification' :: dmsl_claim_management_thrift:'CommentModification'()
}).

%% struct 'StatusChanged'
-record('claim_management_StatusChanged', {}).

%% struct 'StatusModificationUnit'
-record('claim_management_StatusModificationUnit', {
    'status' :: dmsl_claim_management_thrift:'ClaimStatus'(),
    'modification' :: dmsl_claim_management_thrift:'StatusModification'()
}).

%% struct 'ModificationUnit'
-record('claim_management_ModificationUnit', {
    'modification_id' :: dmsl_claim_management_thrift:'ModificationID'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'modification' :: dmsl_claim_management_thrift:'Modification'()
}).

%% struct 'Claim'
-record('claim_management_Claim', {
    'id' :: dmsl_claim_management_thrift:'ClaimID'(),
    'status' :: dmsl_claim_management_thrift:'ClaimStatus'(),
    'changeset' :: dmsl_claim_management_thrift:'ClaimChangeset'(),
    'revision' :: dmsl_claim_management_thrift:'ClaimRevision'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'updated_at' :: dmsl_base_thrift:'Timestamp'() | undefined,
    'metadata' :: dmsl_claim_management_thrift:'Metadata'() | undefined
}).

%% struct 'ClaimPending'
-record('claim_management_ClaimPending', {}).

%% struct 'ClaimReview'
-record('claim_management_ClaimReview', {}).

%% struct 'ClaimPendingAcceptance'
-record('claim_management_ClaimPendingAcceptance', {}).

%% struct 'ClaimAccepted'
-record('claim_management_ClaimAccepted', {}).

%% struct 'ClaimDenied'
-record('claim_management_ClaimDenied', {
    'reason' :: binary() | undefined
}).

%% struct 'ClaimRevoked'
-record('claim_management_ClaimRevoked', {
    'reason' :: binary() | undefined
}).

%% struct 'ClaimSearchQuery'
-record('claim_management_ClaimSearchQuery', {
    'party_id' :: dmsl_domain_thrift:'PartyID'(),
    'statuses' :: [dmsl_claim_management_thrift:'ClaimStatus'()] | undefined,
    'token' :: dmsl_claim_management_thrift:'ContinuationToken'() | undefined,
    'limit' :: integer()
}).

%% exception 'ClaimNotFound'
-record('claim_management_ClaimNotFound', {}).

%% exception 'PartyNotFound'
-record('claim_management_PartyNotFound', {}).

%% exception 'InvalidClaimRevision'
-record('claim_management_InvalidClaimRevision', {}).

%% exception 'ChangesetConflict'
-record('claim_management_ChangesetConflict', {
    'conflicted_id' :: dmsl_claim_management_thrift:'ClaimID'()
}).

%% exception 'BadContinuationToken'
-record('claim_management_BadContinuationToken', {
    'reason' :: binary()
}).

%% exception 'LimitExceeded'
-record('claim_management_LimitExceeded', {}).

%% exception 'InvalidChangeset'
-record('claim_management_InvalidChangeset', {
    'reason' :: binary(),
    'invalid_changeset' :: dmsl_claim_management_thrift:'ClaimChangeset'()
}).

%% exception 'InvalidClaimStatus'
-record('claim_management_InvalidClaimStatus', {
    'status' :: dmsl_claim_management_thrift:'ClaimStatus'()
}).

%% exception 'MetadataKeyNotFound'
-record('claim_management_MetadataKeyNotFound', {}).

-endif.
