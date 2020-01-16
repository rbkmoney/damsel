namespace java com.rbkmoney.damsel.claim_management
namespace erlang claim_management

include "base.thrift"
include "domain.thrift"
include "msgpack.thrift"

typedef i64 ClaimID
typedef i64 ModificationID
typedef i32 ClaimRevision
typedef string ContinuationToken

exception ClaimNotFound {}
exception PartyNotFound {}
exception InvalidClaimRevision {}
exception ChangesetConflict { 1: required ClaimID conflicted_id }
exception BadContinuationToken { 1: string reason }
exception LimitExceeded {}

exception InvalidChangeset {
    1: required string reason
    2: required ClaimChangeset invalid_changeset
}

exception InvalidClaimStatus {
    1: required ClaimStatus status
}


typedef base.ID FileID
typedef base.ID DocumentID
typedef base.ID CommentID

typedef string MetadataKey
typedef msgpack.Value MetadataValue
typedef map<MetadataKey, MetadataValue> Metadata
exception MetadataKeyNotFound {}

typedef list<ModificationUnit> ClaimChangeset

typedef base.ID UserID

struct UserInfo {
    1: required UserID id
    2: required string email
    3: required string username
    4: required UserType type
}

union UserType {
    1: InternalUser internal_user
    2: ExternalUser external_user
}

struct InternalUser {}

struct ExternalUser {}

struct ScheduleChanged {
    1: optional domain.BusinessScheduleRef schedule
}

struct PayoutToolInfoChanged {
    1: required domain.PayoutToolID payout_tool_id
    2: required domain.PayoutToolInfo info
}

struct ShopContractChanged {
    1: required domain.ContractID contract_id
    2: required domain.PayoutToolID payout_tool_id
}

struct PayoutToolParams {
    1: required domain.CurrencyRef currency
    2: required domain.PayoutToolInfo tool_info
}

struct ContractParams {
    1: optional domain.ContractorID contractor_id
    2: optional domain.ContractTemplateRef template
    3: optional domain.PaymentInstitutionRef payment_institution
}

struct ShopModificationUnit {
    1: required domain.ShopID id
    2: required ShopModification modification
}

struct ShopContractModification {
    1: required domain.ContractID contract_id
    2: required domain.PayoutToolID payout_tool_id
}

struct ScheduleModification {
    1: optional domain.BusinessScheduleRef schedule
}

struct ShopAccountParams {
    1: required domain.CurrencyRef currency
}

union ShopModification {
    1: ShopParams creation
    2: domain.CategoryRef category_modification
    3: domain.ShopDetails details_modification
    4: ShopContractModification contract_modification
    5: domain.PayoutToolID payout_tool_modification
    6: domain.ShopLocation location_modification
    7: ShopAccountParams shop_account_creation
    8: ScheduleModification payout_schedule_modification
}

struct ShopParams {
    1: required domain.CategoryRef category
    2: required domain.ShopLocation location
    3: required domain.ShopDetails details
    4: required domain.ContractID contract_id
    5: required domain.PayoutToolID payout_tool_id
}

struct ContractorModificationUnit {
    1: required domain.ContractorID id
    2: required ContractorModification modification
}

union ContractorModification {
    1: domain.Contractor creation
    2: domain.ContractorIdentificationLevel identification_level_modification
}

struct ContractModificationUnit {
    1: required domain.ContractID id
    2: required ContractModification modification
}

union ContractModification {
    1: ContractParams creation
    2: ContractTermination termination
    3: ContractAdjustmentModificationUnit adjustment_modification
    4: PayoutToolModificationUnit payout_tool_modification
    5: domain.LegalAgreement legal_agreement_binding
    6: domain.ReportPreferences report_preferences_modification
    7: domain.ContractorID contractor_modification
}

struct ContractTermination {
    1: optional string reason
}

struct ContractAdjustmentModificationUnit {
    1: required domain.ContractAdjustmentID adjustment_id
    2: required ContractAdjustmentModification modification
}

struct ContractAdjustmentParams {
    1: required domain.ContractTemplateRef template
}

union ContractAdjustmentModification {
    1: ContractAdjustmentParams creation
}

struct PayoutToolModificationUnit {
    1: required domain.PayoutToolID payout_tool_id
    2: required PayoutToolModification modification
}

union PayoutToolModification {
    1: PayoutToolParams creation
    2: domain.PayoutToolInfo info_modification
}

union DocumentModification {
    1: DocumentCreated creation
}

struct DocumentCreated {}

struct DocumentModificationUnit {
    1: required DocumentID id
    2: required DocumentModification modification
}

union FileModification {
    1: FileCreated creation
}

struct FileCreated {}

struct FileModificationUnit {
    1: required FileID id
    2: required FileModification modification
}

union CommentModification {
    1: CommentCreated creation
}

struct CommentCreated {}

struct CommentModificationUnit {
    1: required CommentID id
    2: required CommentModification modification
}

struct StatusChanged {}

union StatusModification {
    1: StatusChanged change
}

struct StatusModificationUnit {
    1: required ClaimStatus status
    2: required StatusModification modification
}

union ClaimModification {
    1: DocumentModificationUnit document_modification
    2: FileModificationUnit file_modification
    3: CommentModificationUnit comment_modification
    4: StatusModificationUnit status_modification
}

union PartyModification {
    1: ContractorModificationUnit contractor_modification
    2: ContractModificationUnit contract_modification
    3: ShopModificationUnit shop_modification
}

struct ModificationUnit {
    1: required ModificationID modification_id
    2: required base.Timestamp created_at
    3: required Modification modification
    4: required UserInfo user_info
}

union Modification {
    1: PartyModification party_modification
    2: ClaimModification claim_modification
}

struct Claim {
    1: required ClaimID id
    8: required domain.PartyID party_id
    2: required ClaimStatus status
    3: required ClaimChangeset changeset
    4: required ClaimRevision revision
    5: required base.Timestamp created_at
    6: optional base.Timestamp updated_at
    7: optional Metadata metadata
}

union ClaimStatus {
    1: ClaimPending pending
    2: ClaimReview review
    3: ClaimPendingAcceptance pending_acceptance
    4: ClaimAccepted accepted
    5: ClaimDenied denied
    6: ClaimRevoked revoked
}

struct ClaimPending {}

struct ClaimReview {}

struct ClaimPendingAcceptance {}

struct ClaimAccepted {}

struct ClaimDenied {
    1: optional string reason
}

struct ClaimRevoked {
    1: optional string reason
}

struct ClaimSearchQuery {
    1: optional domain.PartyID party_id
    5: optional ClaimID claim_id
    2: optional list<ClaimStatus> statuses
    3: optional ContinuationToken continuation_token
    4: required i32 limit
}

struct ClaimSearchResponse {
    1: required list<Claim> result
    2: optional ContinuationToken continuation_token
}

struct Event {
    1: required base.Timestamp occured_at
    2: required Change         change
}

union Change {
    1: ClaimCreated          created
    2: ClaimUpdated          updated
    3: ClaimStatusChanged    status_changed
}

struct ClaimCreated {
    1: required domain.PartyID     party_id
    2: required ClaimID            id
    3: required list<Modification> changeset
    4: required ClaimRevision      revision
    5: required base.Timestamp     created_at
}

struct ClaimUpdated {
    1: required domain.PartyID     party_id
    2: required ClaimID            id
    3: required list<Modification> changeset
    4: required ClaimRevision      revision
    5: required base.Timestamp     updated_at
}

struct ClaimStatusChanged {
    1: required domain.PartyID party_id
    2: required ClaimID        id
    3: required ClaimStatus    status
    4: required ClaimRevision  revision
    5: required base.Timestamp updated_at
}

service ClaimManagement {

        Claim CreateClaim (1: domain.PartyID party_id, 2: list<Modification> changeset)
            throws (
                1: ChangesetConflict ex1,
                2: InvalidChangeset ex2,
                3: base.InvalidRequest ex3
            )

        Claim GetClaim (1: domain.PartyID party_id, 2: ClaimID id)
            throws (1: ClaimNotFound ex1)

        ClaimSearchResponse SearchClaims (1: ClaimSearchQuery claim_request)
                throws (1: LimitExceeded ex1, 2: BadContinuationToken ex2)

        void AcceptClaim (1: domain.PartyID party_id, 2: ClaimID id, 3: ClaimRevision revision)
                throws (
                    1: ClaimNotFound ex1,
                    2: InvalidClaimStatus ex2,
                    3: InvalidClaimRevision ex3,
                    4: InvalidChangeset ex4
                )

        void UpdateClaim (1: domain.PartyID party_id, 2: ClaimID id, 3: ClaimRevision revision, 4: list<Modification> changeset)
                throws (
                    1: ClaimNotFound ex1,
                    2: InvalidClaimStatus ex2,
                    3: InvalidClaimRevision ex3,
                    4: ChangesetConflict ex4,
                    5: InvalidChangeset ex5
                )

        void RequestClaimReview(1: domain.PartyID party_id, 2: ClaimID id, 3: ClaimRevision revision)
                throws (
                    1: ClaimNotFound ex1,
                    2: InvalidClaimStatus ex2,
                    3: InvalidClaimRevision ex3
                )

        void RequestClaimChanges(1: domain.PartyID party_id, 2: ClaimID id, 3: ClaimRevision revision)
                throws (
                    1: ClaimNotFound ex1,
                    2: InvalidClaimStatus ex2,
                    3: InvalidClaimRevision ex3
                )

        void DenyClaim (1: domain.PartyID party_id, 2: ClaimID id, 3: ClaimRevision revision, 4: string reason)
                throws (
                    1: ClaimNotFound ex1,
                    2: InvalidClaimStatus ex2,
                    3: InvalidClaimRevision ex3
                )

        void RevokeClaim (1: domain.PartyID party_id, 2: ClaimID id, 3: ClaimRevision revision, 4: string reason)
                throws (
                    1: ClaimNotFound ex1,
                    2: InvalidClaimStatus ex2,
                    3: InvalidClaimRevision ex3
                )

        MetadataValue GetMetadata (1: domain.PartyID party_id, 2: ClaimID id, 3: MetadataKey key)
                throws (1: ClaimNotFound ex1, 2: MetadataKeyNotFound ex2)

        void SetMetadata (1: domain.PartyID party_id, 2: ClaimID id, 3: MetadataKey key, 4: MetadataValue value)
                throws (1: ClaimNotFound ex1)

        void RemoveMetadata (1: domain.PartyID party_id, 2: ClaimID id, 3: MetadataKey key)
                throws (1: ClaimNotFound ex1, 2: MetadataKeyNotFound ex2)

}

service ClaimCommitter {

        void Accept (1: domain.PartyID party_id, 2: Claim claim)
                throws (
                    1: PartyNotFound ex1,
                    2: InvalidChangeset ex2
                )

        void Commit (1: domain.PartyID party_id, 2: Claim claim)
                throws (
                )

}
