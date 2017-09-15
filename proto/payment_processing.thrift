/**
 * Определения и сервисы процессинга.
 */

include "base.thrift"
include "domain.thrift"
include "user_interaction.thrift"

namespace java com.rbkmoney.damsel.payment_processing
namespace erlang payproc

/* Interface clients */

typedef base.ID UserID

struct UserInfo {
    1: required UserID id
    2: required UserType type
}

/* Временная замена ролям пользователей для разграничения доступа в HG */
union UserType {
    1: InternalUser internal_user
    2: ExternalUser external_user
    3: ServiceUser  service_user
}

struct InternalUser {}

struct ExternalUser {}

struct ServiceUser {}

/* Events */

typedef list<Event> Events

/**
 * Событие, атомарный фрагмент истории бизнес-объекта, например инвойса.
 */
struct Event {

    /**
     * Идентификатор события.
     * Монотонно возрастающее целочисленное значение, таким образом на множестве
     * событий задаётся отношение полного порядка (total order).
     */
    1: required base.EventID id

    /**
     * Время создания события.
     */
    2: required base.Timestamp created_at

    /**
     * Идентификатор бизнес-объекта, источника события.
     */
    3: required EventSource source

    /**
     * Содержание события, состоящее из списка (возможно пустого)
     * изменений состояния бизнес-объекта, источника события.
     */
    4: required EventPayload payload
}

/**
 * Источник события, идентификатор бизнес-объекта, который породил его в
 * процессе выполнения определённого бизнес-процесса.
 */
union EventSource {
    /** Идентификатор инвойса, который породил событие. */
    1: domain.InvoiceID         invoice_id
    /** Идентификатор участника, который породил событие. */
    2: domain.PartyID           party_id
    /** Идентификатор шаблона инвойса, который породил событие. */
    3: domain.InvoiceTemplateID invoice_template_id
}

/**
 * Один из возможных вариантов содержания события.
 */
union EventPayload {
    /** Набор изменений, порождённых инвойсом. */
    1: list<InvoiceChange>          invoice_changes
    /** Набор изменений, порождённых участником. */
    2: list<PartyChange>            party_changes
    /** Набор изменений, порождённых шаблоном инвойса. */
    3: list<InvoiceTemplateChange>  invoice_template_changes
}

/**
 * Один из возможных вариантов события, порождённого инвойсом.
 */
union InvoiceChange {
    1: InvoiceCreated          invoice_created
    2: InvoiceStatusChanged    invoice_status_changed
    3: InvoicePaymentChange    invoice_payment_change
}

union InvoiceTemplateChange {
    1: InvoiceTemplateCreated invoice_template_created
    2: InvoiceTemplateUpdated invoice_template_updated
    3: InvoiceTemplateDeleted invoice_template_deleted
}

/**
 * Событие о создании нового инвойса.
 */
struct InvoiceCreated {
    /** Данные созданного инвойса. */
    1: required domain.Invoice invoice
}

/**
 * Событие об изменении статуса инвойса.
 */
struct InvoiceStatusChanged {
    /** Новый статус инвойса. */
    1: required domain.InvoiceStatus status
}

/**
 * Событие, касающееся определённого платежа по инвойсу.
 */
struct InvoicePaymentChange {
    1: required domain.InvoicePaymentID id
    2: required InvoicePaymentChangePayload payload
}

/**
 * Один из возможных вариантов события, порождённого платежом по инвойсу.
 */
union InvoicePaymentChangePayload {
    1: InvoicePaymentStarted               invoice_payment_started
    3: InvoicePaymentStatusChanged         invoice_payment_status_changed
    2: InvoicePaymentSessionChange         invoice_payment_session_change
    7: InvoicePaymentRefundChange          invoice_payment_refund_change
    6: InvoicePaymentAdjustmentChange      invoice_payment_adjustment_change
}

/**
 * Событие об запуске платежа по инвойсу.
 */
struct InvoicePaymentStarted {
    /** Данные запущенного платежа. */
    1: required domain.InvoicePayment payment
    /** Оценка риска платежа. */
    4: required domain.RiskScore risk_score
    /** Выбранный маршрут обработки платежа. */
    2: required domain.InvoicePaymentRoute route
    /** Данные финансового взаимодействия. */
    3: required domain.FinalCashFlow cash_flow
}

/**
 * Событие об изменении статуса платежа по инвойсу.
 */
struct InvoicePaymentStatusChanged {
    /** Статус платежа по инвойсу. */
    1: required domain.InvoicePaymentStatus status
}

/**
 * Событие в рамках сессии взаимодействия с провайдером по платежу.
 */
struct InvoicePaymentSessionChange {
    1: required domain.TargetInvoicePaymentStatus target
    2: required InvoicePaymentSessionChangePayload payload
}

/**
 * Один из возможных вариантов события, порождённого сессией взаимодействия.
 */
union InvoicePaymentSessionChangePayload {
    1: InvoicePaymentSessionStarted              invoice_payment_session_started
    2: InvoicePaymentSessionFinished             invoice_payment_session_finished
    3: InvoicePaymentSessionSuspended            invoice_payment_session_suspended
    4: InvoicePaymentSessionActivated            invoice_payment_session_activated
    5: InvoicePaymentSessionTransactionBound     invoice_payment_session_transaction_bound
    6: InvoicePaymentSessionProxyStateChanged    invoice_payment_session_proxy_state_changed
    7: InvoicePaymentSessionInteractionRequested invoice_payment_session_interaction_requested
}

struct InvoicePaymentSessionStarted {}

struct InvoicePaymentSessionFinished {
    1: required SessionResult result
}

struct InvoicePaymentSessionSuspended {}
struct InvoicePaymentSessionActivated {}

union SessionResult {
    1: SessionSucceeded succeeded
    2: SessionFailed    failed
}

struct SessionSucceeded {}

struct SessionFailed {
    1: required domain.OperationFailure failure
}

/**
 * Событие о создании нового шаблона инвойса.
 */
struct InvoiceTemplateCreated {
    /** Данные созданного шаблона инвойса. */
    1: required domain.InvoiceTemplate invoice_template
}

/**
 * Событие о модификации шаблона инвойса.
 */
struct InvoiceTemplateUpdated {
    /** Данные модифицированного шаблона инвойса. */
    1: required InvoiceTemplateUpdateParams diff
}

/**
 * Событие об удалении шаблона инвойса.
 */
struct InvoiceTemplateDeleted {}

/**
 * Событие о том, что появилась связь между платежом по инвойсу и транзакцией
 * у провайдера.
 */
struct InvoicePaymentSessionTransactionBound {
    /** Данные о связанной транзакции у провайдера. */
    1: required domain.TransactionInfo trx
}

/**
 * Событие о том, что изменилось непрозрачное состояние прокси в рамках сессии.
 */
struct InvoicePaymentSessionProxyStateChanged {
    1: required base.Opaque proxy_state
}

/**
 * Событие о запросе взаимодействия с плательщиком.
 */
struct InvoicePaymentSessionInteractionRequested {
    /** Необходимое взаимодействие */
    1: required user_interaction.UserInteraction interaction
}

/**
 * Событие, касающееся определённого возврата платежа.
 */
struct InvoicePaymentRefundChange {
    1: required domain.InvoicePaymentRefundID id
    2: required InvoicePaymentRefundChangePayload payload
}

/**
 * Один из возможных вариантов события, порождённого возратом платежа по инвойсу.
 */
union InvoicePaymentRefundChangePayload {
    1: InvoicePaymentRefundCreated       invoice_payment_refund_created
    2: InvoicePaymentRefundStatusChanged invoice_payment_refund_status_changed
    3: InvoicePaymentSessionChange       invoice_payment_session_change
}

/**
 * Событие о создании возврата платежа
 */
struct InvoicePaymentRefundCreated {
    1: required domain.InvoicePaymentRefund refund
    2: required domain.FinalCashFlow cash_flow
}

/**
 * Событие об изменении статуса возврата платежа
 */
struct InvoicePaymentRefundStatusChanged {
    1: required domain.InvoicePaymentRefundStatus status
}

/**
 * Событие, касающееся определённой корректировки платежа.
 */
struct InvoicePaymentAdjustmentChange {
    1: required domain.InvoicePaymentAdjustmentID id
    2: required InvoicePaymentAdjustmentChangePayload payload
}

/**
 * Один из возможных вариантов события, порождённого корректировкой платежа по инвойсу.
 */
union InvoicePaymentAdjustmentChangePayload {
    1: InvoicePaymentAdjustmentCreated       invoice_payment_adjustment_created
    2: InvoicePaymentAdjustmentStatusChanged invoice_payment_adjustment_status_changed
}

/**
 * Событие о создании корректировки платежа
 */
struct InvoicePaymentAdjustmentCreated {
    1: required domain.InvoicePaymentAdjustment adjustment
}

/**
 * Событие об изменении статуса корректировки платежа
 */
struct InvoicePaymentAdjustmentStatusChanged {
    1: required domain.InvoicePaymentAdjustmentStatus status
}

/**
 * Диапазон для выборки событий.
 */
struct EventRange {

    /**
     * Идентификатор события, за которым должны следовать попадающие в выборку
     * события.
     *
     * Если `after` не указано, в выборку попадут события с начала истории; если
     * указано, например, `42`, то в выборку попадут события, случившиеся _после_
     * события `42`.
     */
    1: optional base.EventID after

    /**
     * Максимальное количество событий в выборке.
     *
     * В выборку может попасть количество событий, _не больше_ указанного в
     * `limit`. Если в выборку попало событий _меньше_, чем значение `limit`,
     * был достигнут конец текущей истории.
     *
     * _Допустимые значения_: неотрицательные числа
     */
    2: required i32 limit

}

/* Invoicing service definitions */

struct InvoiceParams {
    1: required PartyID party_id
    2: required ShopID shop_id
    3: required domain.InvoiceDetails details
    4: required base.Timestamp due
    5: required domain.Cash cost
    6: required domain.InvoiceContext context
}

struct InvoiceWithTemplateParams {
    1: required domain.InvoiceTemplateID template_id
    2: optional domain.Cash cost
    3: optional domain.InvoiceContext context
}

struct InvoiceTemplateCreateParams {
    1: required PartyID party_id
    2: required ShopID shop_id
    3: required domain.InvoiceDetails details
    4: required domain.LifetimeInterval invoice_lifetime
    5: required domain.InvoiceTemplateCost cost
    6: required domain.InvoiceContext context
}

struct InvoiceTemplateUpdateParams {
    1: optional domain.InvoiceDetails details
    2: optional domain.LifetimeInterval invoice_lifetime
    3: optional domain.InvoiceTemplateCost cost
    4: optional domain.InvoiceContext context
}

struct InvoicePaymentParams {
    1: required domain.Payer payer
    2: required InvoicePaymentParamsFlow flow
}

union InvoicePaymentParamsFlow {
    1: InvoicePaymentParamsFlowInstant instant
    2: InvoicePaymentParamsFlowHold hold
}

struct InvoicePaymentParamsFlowInstant   {}

struct InvoicePaymentParamsFlowHold {
    1: required domain.OnHoldExpiration on_hold_expiration
}

struct Invoice {
    1: required domain.Invoice invoice
    2: required list<InvoicePayment> payments
}

struct InvoicePayment {
    1: required domain.InvoicePayment payment
    3: required list<InvoicePaymentRefund> refunds
    2: required list<InvoicePaymentAdjustment> adjustments
}

typedef domain.InvoicePaymentRefund InvoicePaymentRefund
typedef domain.InvoicePaymentAdjustment InvoicePaymentAdjustment

/**
 * Параметры создаваемого возврата платежа.
 */
struct InvoicePaymentRefundParams {
    /** Причина, на основании которой производится возврат. */
    1: optional string reason
}

/**
 * Параметры создаваемой поправки к платежу.
 */
struct InvoicePaymentAdjustmentParams {
    /** Ревизия, относительно которой необходимо пересчитать граф финансовых потоков. */
    1: optional domain.DataRevision domain_revision
    /** Причина, на основании которой создаётся поправка. */
    2: required string reason
}

// Exceptions

// forward-declared
exception PartyNotFound {}
exception ShopNotFound {}
exception InvalidPartyStatus { 1: required InvalidStatus status }
exception InvalidShopStatus { 1: required InvalidStatus status }
exception InvalidContractStatus { 1: required domain.ContractStatus status }

union InvalidStatus {
    1: domain.Blocking blocking
    2: domain.Suspension suspension
}

exception InvalidUser {}
exception InvoiceNotFound {}
exception InvoicePaymentNotFound {}
exception InvoicePaymentRefundNotFound {}
exception InvoicePaymentAdjustmentNotFound {}
exception EventNotFound {}
exception OperationNotPermitted {}

exception InvoicePaymentPending {
    1: required domain.InvoicePaymentID id
}

exception InvoicePaymentRefundPending {
    1: required domain.InvoicePaymentRefundID id
}

exception InvoicePaymentAdjustmentPending {
    1: required domain.InvoicePaymentAdjustmentID id
}

exception InvalidInvoiceStatus {
    1: required domain.InvoiceStatus status
}

exception InvalidPaymentStatus {
    1: required domain.InvoicePaymentStatus status
}

exception InvalidPaymentAdjustmentStatus {
    1: required domain.InvoicePaymentAdjustmentStatus status
}

exception InvoiceTemplateNotFound {}
exception InvoiceTemplateRemoved {}

service Invoicing {

    Invoice Create (1: UserInfo user, 2: InvoiceParams params)
        throws (
            1: InvalidUser ex1,
            2: base.InvalidRequest ex2,
            3: PartyNotFound ex3,
            4: ShopNotFound ex4,
            5: InvalidPartyStatus ex5,
            6: InvalidShopStatus ex6,
            7: InvalidContractStatus ex7
        )

    Invoice CreateWithTemplate (1: UserInfo user, 2: InvoiceWithTemplateParams params)
        throws (
            1: InvalidUser ex1,
            2: base.InvalidRequest ex2,
            3: InvalidPartyStatus ex3,
            4: InvalidShopStatus ex4,
            5: InvalidContractStatus ex5
            6: InvoiceTemplateNotFound ex6,
            7: InvoiceTemplateRemoved ex7
        )

    Invoice Get (1: UserInfo user, 2: domain.InvoiceID id)
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2
        )

    Events GetEvents (1: UserInfo user, 2: domain.InvoiceID id, 3: EventRange range)
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: EventNotFound ex3,
            4: base.InvalidRequest ex4
        )

    /* Terms */

    domain.TermSet GetComputedTerms (1: UserInfo user, 2: domain.InvoiceID id)
        throws (1: InvalidUser ex1, 2: InvoiceNotFound ex2)

    /* Payments */

    InvoicePayment StartPayment (
        1: UserInfo user,
        2: domain.InvoiceID id,
        3: InvoicePaymentParams params
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvalidInvoiceStatus ex3,
            4: InvoicePaymentPending ex4,
            5: base.InvalidRequest ex5,
            6: InvalidPartyStatus ex6,
            7: InvalidShopStatus ex7,
            8: InvalidContractStatus ex8
        )

    InvoicePayment GetPayment (
        1: UserInfo user,
        2: domain.InvoiceID id,
        3: domain.InvoicePaymentID payment_id
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvoicePaymentNotFound ex3
        )

    void CancelPayment (
        1: UserInfo user,
        2: domain.InvoiceID id,
        3: domain.InvoicePaymentID payment_id
        4: string reason
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvoicePaymentNotFound ex3,
            4: InvalidPaymentStatus ex4,
            5: base.InvalidRequest ex5,
            6: OperationNotPermitted ex6,
            7: InvalidPartyStatus ex7,
            8: InvalidShopStatus ex8
        )

    void CapturePayment (
        1: UserInfo user,
        2: domain.InvoiceID id,
        3: domain.InvoicePaymentID payment_id
        4: string reason
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvoicePaymentNotFound ex3,
            4: InvalidPaymentStatus ex4,
            5: base.InvalidRequest ex5,
            6: OperationNotPermitted ex6,
            7: InvalidPartyStatus ex7,
            8: InvalidShopStatus ex8
        )
    /**
     * Создать поправку к платежу.
     *
     * После создания поправку необходимо либо подтвердить, если её эффекты
     * соответствуют ожиданиям, либо отклонить в противном случае (по аналогии с
     * заявками).
     * Пока созданная поправка ни подтверждена, ни отклонена, другую поправку
     * создать невозможно.
     */
    InvoicePaymentAdjustment CreatePaymentAdjustment (
        1: UserInfo user,
        2: domain.InvoiceID id,
        3: domain.InvoicePaymentID payment_id,
        4: InvoicePaymentAdjustmentParams params
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvoicePaymentNotFound ex3,
            4: InvalidPaymentStatus ex4,
            5: InvoicePaymentAdjustmentPending ex5
        )

    InvoicePaymentAdjustment GetPaymentAdjustment (
        1: UserInfo user,
        2: domain.InvoiceID id,
        3: domain.InvoicePaymentID payment_id
        4: domain.InvoicePaymentAdjustmentID adjustment_id
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvoicePaymentNotFound ex3,
            4: InvoicePaymentAdjustmentNotFound ex4
        )

    void CapturePaymentAdjustment (
        1: UserInfo user,
        2: domain.InvoiceID id,
        3: domain.InvoicePaymentID payment_id
        4: domain.InvoicePaymentAdjustmentID adjustment_id
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvoicePaymentNotFound ex3,
            4: InvoicePaymentAdjustmentNotFound ex4,
            5: InvalidPaymentAdjustmentStatus ex5
        )

    void CancelPaymentAdjustment (
        1: UserInfo user
        2: domain.InvoiceID id,
        3: domain.InvoicePaymentID payment_id
        4: domain.InvoicePaymentAdjustmentID adjustment_id
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvoicePaymentNotFound ex3,
            4: InvoicePaymentAdjustmentNotFound ex4,
            5: InvalidPaymentAdjustmentStatus ex5
        )

    /**
     * Сделать возврат платежа.
     */
    domain.InvoicePaymentRefund RefundPayment (
        1: UserInfo user
        2: domain.InvoiceID id,
        3: domain.InvoicePaymentID payment_id
        4: InvoicePaymentRefundParams params
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvoicePaymentNotFound ex3,
            4: InvalidPaymentStatus ex4,
            5: InvoicePaymentRefundPending ex5,
            6: OperationNotPermitted ex6
        )

    domain.InvoicePaymentRefund GetPaymentRefund (
        1: UserInfo user
        2: domain.InvoiceID id,
        3: domain.InvoicePaymentID payment_id
        4: domain.InvoicePaymentRefundID refund_id
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvoicePaymentNotFound ex3,
            4: InvoicePaymentRefundNotFound ex4
        )

    void Fulfill (1: UserInfo user, 2: domain.InvoiceID id, 3: string reason)
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvalidInvoiceStatus ex3,
            4: InvalidPartyStatus ex4,
            5: InvalidShopStatus ex5,
            6: InvalidContractStatus ex6
        )

    void Rescind (1: UserInfo user, 2: domain.InvoiceID id, 3: string reason)
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvalidInvoiceStatus ex3,
            4: InvoicePaymentPending ex4,
            5: InvalidPartyStatus ex5,
            6: InvalidShopStatus ex6,
            7: InvalidContractStatus ex7
        )
    }

service InvoiceTemplating {

    domain.InvoiceTemplate Create (1: UserInfo user, 2: InvoiceTemplateCreateParams params)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: InvalidPartyStatus ex3,
            4: ShopNotFound ex4,
            5: InvalidShopStatus ex5,
            6: base.InvalidRequest ex6
        )

    domain.InvoiceTemplate Get (1: UserInfo user, 2: domain.InvoiceTemplateID id)
        throws (
            1: InvalidUser ex1,
            2: InvoiceTemplateNotFound ex2,
            3: InvoiceTemplateRemoved ex3
        )

    domain.InvoiceTemplate Update (1: UserInfo user, 2: domain.InvoiceTemplateID id, 3: InvoiceTemplateUpdateParams params)
        throws (
            1: InvalidUser ex1,
            2: InvoiceTemplateNotFound ex2,
            3: InvoiceTemplateRemoved ex3,
            4: InvalidPartyStatus ex4,
            5: InvalidShopStatus ex5,
            6: base.InvalidRequest ex6
        )
    void Delete (1: UserInfo user, 2: domain.InvoiceTemplateID id)
        throws (
            1: InvalidUser ex1,
            2: InvoiceTemplateNotFound ex2,
            3: InvoiceTemplateRemoved ex3,
            4: InvalidPartyStatus ex4,
            5: InvalidShopStatus ex5
        )
}

/* Party management service definitions */

// Types

typedef domain.PartyID PartyID
typedef domain.ShopID  ShopID

struct PartyParams {
    1: required domain.PartyContactInfo contact_info
}

struct PayoutToolParams {
    1: required domain.CurrencyRef currency
    2: required domain.PayoutToolInfo tool_info
}

struct ShopParams {
    1: optional domain.CategoryRef category
    6: required domain.ShopLocation location
    2: required domain.ShopDetails details
    3: required domain.ContractID contract_id
    4: required domain.PayoutToolID payout_tool_id
}

struct ShopAccountParams {
    1: required domain.CurrencyRef currency
}

struct ContractParams {
    1: required domain.Contractor contractor
    2: optional domain.ContractTemplateRef template
}

struct ContractAdjustmentParams {
    1: required domain.ContractTemplateRef template
}

union PartyModification {
    4: ContractModificationUnit contract_modification
    6: ShopModificationUnit shop_modification
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
}

struct ContractTermination {
    2: optional string reason
}

struct ContractAdjustmentModificationUnit {
    1: required domain.ContractAdjustmentID adjustment_id
    2: required ContractAdjustmentModification modification
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
}

typedef list<PartyModification> PartyChangeset

struct ShopModificationUnit {
    1: required ShopID id
    2: required ShopModification modification
}

union ShopModification {
    5: ShopParams creation
    6: domain.CategoryRef category_modification
    7: domain.ShopDetails details_modification
    8: ShopContractModification contract_modification
    9: domain.PayoutToolID payout_tool_modification
    10: ProxyModification proxy_modification
    11: domain.ShopLocation location_modification
    12: ShopAccountParams shop_account_creation
}

struct ShopContractModification {
    1: required domain.ContractID contract_id
    2: required domain.PayoutToolID payout_tool_id
}

struct ProxyModification {
    1: optional domain.Proxy proxy
}

// Claims

typedef i64 ClaimID
typedef i32 ClaimRevision

struct Claim {
    1: required ClaimID id
    2: required ClaimStatus status
    3: required PartyChangeset changeset
    4: required ClaimRevision revision
    5: required base.Timestamp created_at
    6: optional base.Timestamp updated_at
}

union ClaimStatus {
    1: ClaimPending pending
    2: ClaimAccepted accepted
    3: ClaimDenied denied
    4: ClaimRevoked revoked
}

struct ClaimPending {}

struct ClaimAccepted {
    2: optional ClaimEffects effects
}

struct ClaimDenied {
    1: optional string reason
}

struct ClaimRevoked {
    1: optional string reason
}

// Claim effects

typedef list<ClaimEffect> ClaimEffects

union ClaimEffect {
    /* 1: PartyEffect Reserved for future */
    2: ContractEffectUnit contract_effect
    3: ShopEffectUnit shop_effect
}

struct ContractEffectUnit {
    1: required domain.ContractID contract_id
    2: required ContractEffect effect
}

union ContractEffect {
    1: domain.Contract created
    2: domain.ContractStatus status_changed
    3: domain.ContractAdjustment adjustment_created
    4: domain.PayoutTool payout_tool_created
    5: domain.LegalAgreement legal_agreement_bound
}

struct ShopEffectUnit {
    1: required ShopID shop_id
    2: required ShopEffect effect
}

union ShopEffect {
    1: domain.Shop created
    2: domain.CategoryRef category_changed
    3: domain.ShopDetails details_changed
    4: ShopContractChanged contract_changed
    5: domain.PayoutToolID payout_tool_changed
    6: ShopProxyChanged proxy_changed
    7: domain.ShopLocation location_changed
    8: domain.ShopAccount account_created
}

struct ShopContractChanged {
    1: required domain.ContractID contract_id
    2: required domain.PayoutToolID payout_tool_id
}

struct ShopProxyChanged {
    1: optional domain.Proxy proxy
}

struct AccountState {
    1: required domain.AccountID account_id
    2: required domain.Amount own_amount
    3: required domain.Amount available_amount
    4: required domain.Currency currency
}

struct ComputedTermsParams {
    1: required ComputedTermsObject target
    2: optional base.Timestamp timestamp
}

union ComputedTermsObject {
    1: domain.ContractID contract_id
    2: domain.ShopID shop_id
}

// Events

union PartyChange {
    1: domain.Party         party_created
    4: domain.Blocking      party_blocking
    5: domain.Suspension    party_suspension
    6: ShopBlocking         shop_blocking
    7: ShopSuspension       shop_suspension
    2: Claim                claim_created
    3: ClaimStatusChanged   claim_status_changed
    8: ClaimUpdated         claim_updated
    9: PartyMetaSet         party_meta_set
    10: domain.PartyMetaNamespace party_meta_removed
}

struct ShopBlocking {
    1: required ShopID shop_id
    2: required domain.Blocking blocking
}

struct ShopSuspension {
    1: required ShopID shop_id
    2: required domain.Suspension suspension
}

struct ClaimStatusChanged {
    1: required ClaimID id
    2: required ClaimStatus status
    3: required ClaimRevision revision
    4: required base.Timestamp changed_at
}

struct ClaimUpdated {
    1: required ClaimID id
    2: required PartyChangeset changeset
    3: required ClaimRevision revision
    4: required base.Timestamp updated_at
}

struct PartyMetaSet {
    1: required domain.PartyMetaNamespace ns
    2: required domain.PartyMetaData data
}

// Exceptions

exception PartyExists {}
exception PartyNotExistsYet {}
exception ContractNotFound {}
exception ClaimNotFound {}
exception InvalidClaimRevision {}

exception InvalidClaimStatus {
    1: required ClaimStatus status
}

exception ChangesetConflict { 1: required ClaimID conflicted_id }
exception InvalidChangeset { 1: required InvalidChangesetReason reason }

union InvalidChangesetReason {
    1: domain.ContractID contract_not_exists
    2: domain.ContractID contract_already_exists
    3: ContractStatusInvalid contract_status_invalid
    4: domain.ContractAdjustmentID contract_adjustment_already_exists
    5: domain.PayoutToolID payout_tool_not_exists
    6: domain.PayoutToolID payout_tool_already_exists
    7: ShopID shop_not_exists
    8: ShopID shop_already_exists
    9: ShopStatusInvalid shop_status_invalid
    10: ContractTermsViolated contract_terms_violated
}

struct ContractStatusInvalid {
    1: required domain.ContractID contract_id
    2: required domain.ContractStatus status
}

struct ShopStatusInvalid {
    1: required ShopID shop_id
    2: required InvalidStatus status
}

struct ContractTermsViolated {
    1: required ShopID shop_id
    2: required domain.ContractID contract_id
    3: required domain.TermSet terms
}

exception AccountNotFound {}

exception ShopAccountNotFound {}

exception PartyMetaNamespaceNotFound {}

// Service

service PartyManagement {

    /* Party */

    void Create (1: UserInfo user, 2: PartyID party_id, 3: PartyParams params)
        throws (1: InvalidUser ex1, 2: PartyExists ex2)

    domain.Party Get (1: UserInfo user, 2: PartyID party_id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2)

    domain.Party Checkout (1: UserInfo user, 2: PartyID party_id, 3: base.Timestamp timestamp)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: PartyNotExistsYet ex3)

    void Suspend (1: UserInfo user, 2: PartyID party_id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: InvalidPartyStatus ex3)

    void Activate (1: UserInfo user, 2: PartyID party_id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: InvalidPartyStatus ex3)

    void Block (1: UserInfo user, 2: PartyID party_id, 3: string reason)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: InvalidPartyStatus ex3)

    void Unblock (1: UserInfo user, 2: PartyID party_id, 3: string reason)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: InvalidPartyStatus ex3)

    /* Party Meta */

    domain.PartyMeta GetMeta (1: UserInfo user, 2: PartyID party_id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2)

    domain.PartyMetaData GetMetaData (1: UserInfo user, 2: PartyID party_id, 3: domain.PartyMetaNamespace ns)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: PartyMetaNamespaceNotFound ex3)

    void SetMetaData (1: UserInfo user, 2: PartyID party_id, 3: domain.PartyMetaNamespace ns, 4: domain.PartyMetaData data)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2)

    void RemoveMetaData (1: UserInfo user, 2: PartyID party_id, 3: domain.PartyMetaNamespace ns)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: PartyMetaNamespaceNotFound ex3)

    /* Contract */

    domain.Contract GetContract (1: UserInfo user, 2: PartyID party_id, 3: domain.ContractID contract_id)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: ContractNotFound ex3
        )

    /* Shop */

    domain.Shop GetShop (1: UserInfo user, 2: PartyID party_id, 3: ShopID id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: ShopNotFound ex3)

     void SuspendShop (1: UserInfo user, 2: PartyID party_id, 3: ShopID id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: ShopNotFound ex3, 4: InvalidShopStatus ex4)

    void ActivateShop (1: UserInfo user, 2: PartyID party_id, 3: ShopID id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: ShopNotFound ex3, 4: InvalidShopStatus ex4)

    void BlockShop (1: UserInfo user, 2: PartyID party_id, 3: ShopID id, 4: string reason)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: ShopNotFound ex3, 4: InvalidShopStatus ex4)

    void UnblockShop (1: UserInfo user, 2: PartyID party_id, 3: ShopID id, 4: string reason)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: ShopNotFound ex3, 4: InvalidShopStatus ex4)

    /* Terms */

    domain.TermSet GetComputedTerms (1: UserInfo user, 2: PartyID party_id, 3: ComputedTermsParams params)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: ShopNotFound ex3, 4: ContractNotFound ex4)

    /* Claim */

    Claim CreateClaim (1: UserInfo user, 2: PartyID party_id, 3: PartyChangeset changeset)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: InvalidPartyStatus ex3,
            4: ChangesetConflict ex4,
            5: InvalidChangeset ex5,
            6: base.InvalidRequest ex6
        )

    Claim GetClaim (1: UserInfo user, 2: PartyID party_id, 3: ClaimID id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: ClaimNotFound ex3)

    list<Claim> GetClaims (1: UserInfo user, 2: PartyID party_id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2)

    void AcceptClaim (1: UserInfo user, 2: PartyID party_id, 3: ClaimID id, 4: ClaimRevision revision)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: ClaimNotFound ex3,
            4: InvalidClaimStatus ex4,
            5: InvalidClaimRevision ex5,
            6: InvalidChangeset ex6
        )

    void UpdateClaim (1: UserInfo user, 2: PartyID party_id, 3: ClaimID id, 4: ClaimRevision revision, 5: PartyChangeset changeset)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: InvalidPartyStatus ex3,
            4: ClaimNotFound ex4,
            5: InvalidClaimStatus ex5,
            6: InvalidClaimRevision ex6,
            7: ChangesetConflict ex7,
            8: InvalidChangeset ex8,
            9: base.InvalidRequest ex9
        )

    void DenyClaim (1: UserInfo user, 2: PartyID party_id, 3: ClaimID id, 4: ClaimRevision revision, 5: string reason)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: ClaimNotFound ex3,
            4: InvalidClaimStatus ex4,
            5: InvalidClaimRevision ex5
        )

    void RevokeClaim (1: UserInfo user, 2: PartyID party_id, 3: ClaimID id, 4: ClaimRevision revision, 5: string reason)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: InvalidPartyStatus ex3,
            4: ClaimNotFound ex4,
            5: InvalidClaimStatus ex5,
            6: InvalidClaimRevision ex6
        )

    /* Event polling */

    Events GetEvents (1: UserInfo user, 2: PartyID party_id, 3: EventRange range)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: EventNotFound ex3,
            4: base.InvalidRequest ex4
        )

    /* Accounts */

    domain.ShopAccount GetShopAccount (1: UserInfo user, 2: PartyID party_id, 3: ShopID shop_id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: ShopNotFound ex3, 4: ShopAccountNotFound ex4)

    AccountState GetAccountState (1: UserInfo user, 2: PartyID party_id, 3: domain.AccountID account_id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: AccountNotFound ex3)
}

/* Event sink service definitions */

/** Исключение, сигнализирующее о том, что последнего события не существует. */
exception NoLastEvent {}

service EventSink {

    /**
     * Получить последовательный набор событий из истории системы, от более
     * ранних к более поздним, из диапазона, заданного `range`. Результат
     * выполнения запроса может содержать от `0` до `range.limit` событий.
     *
     * Если в `range.after` указан идентификатор неизвестного события, то есть
     * события, не наблюдаемого клиентом ранее в известной ему истории,
     * бросится исключение `EventNotFound`.
     */
    Events GetEvents (1: EventRange range)
        throws (1: EventNotFound ex1, 2: base.InvalidRequest ex2)

    /**
     * Получить идентификатор наиболее позднего известного на момент исполнения
     * запроса события.
     */
    base.EventID GetLastEventID ()
        throws (1: NoLastEvent ex1)

}
