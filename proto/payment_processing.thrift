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

/* Invoices */

struct InvoiceState {
    1: required domain.Invoice invoice
    2: required list<domain.InvoicePayment> payments = []
}

/* Events */

/**
 * Событие, атомарный фрагмент истории бизнес-объекта, например инвойса.
 */
struct Event {

    /**
     * Идентификатор события.
     * Монотонно возрастающее целочисленное значение, таким образом на множестве
     * событий задаётся отношение полного порядка (total order).
     */
    1: required base.EventID   id

    /**
     * Время создания события.
     */
    2: required base.Timestamp created_at

    /**
     * Идентификатор бизнес-объекта, источника события.
     */
    3: required EventSource    source

    /**
     * Номер события в последовательности событий от указанного источника.
     *
     * Номер первого события от источника всегда равен `1`, то есть `sequence`
     * принимает значения из диапазона `[1; 2^31)`
     */
    4: required i32            sequence

    /**
     * Содержание события.
     */
    5: required EventPayload   payload

}

/**
 * Источник события, идентификатор бизнес-объекта, который породил его в
 * процессе выполнения определённого бизнес-процесса.
 */
union EventSource {
    /** Идентификатор инвойса, который породил событие. */
    1: domain.InvoiceID        invoice
    /** Идентификатор участника, который породил событие. */
    2: domain.PartyID          party
}

typedef list<Event> Events

/**
 * Один из возможных вариантов содержания события.
 */
union EventPayload {
    /** Некоторое событие, порождённое инвойсом. */
    1: InvoceEventWrapper            invoice_event_wrapper
    /** Некоторое событие, порождённое участником. */
    2: PartyEvent              party_event
}

/**
 * Один из возможных вариантов события, порождённого инвойсом.
 */
struct InvoceEventWrapper {
    1: required domain.Invoice invoice
    2: required InvoiceEvent invoice_event
}

union InvoiceEvent {
    1: InvoiceCreated          invoice_created
    2: InvoiceStatusChanged    invoice_status_changed
    3: InvoicePaymentEvent     invoice_payment_event
}

/**
 * Один из возможных вариантов события, порождённого платежом по инвойсу.
 */
union InvoicePaymentEvent {
    1: InvoicePaymentStarted       invoice_payment_started
    2: InvoicePaymentBound         invoice_payment_bound
    3: InvoicePaymentStatusChanged invoice_payment_status_changed
    4: InvoicePaymentInteractionRequested invoice_payment_interaction_requested
    5: InvoicePaymentInspected invoice_payment_inspected
}

/**
 * Событие о создании нового инвойса.
 */
struct InvoiceCreated {
}

/**
 * Событие об изменении статуса инвойса.
 */
struct InvoiceStatusChanged {
    /** Новый статус инвойса. */
    1: required domain.InvoiceStatus status
}

/**
 * Событие об запуске платежа по инвойсу.
 */
struct InvoicePaymentStarted {
    /** Данные запущенного платежа. */
    1: required domain.InvoicePayment payment
    /** Выбранный маршрут обработки платежа. */
    2: optional domain.InvoicePaymentRoute route
    /** Данные финансового взаимодействия. */
    3: optional domain.FinalCashFlow cash_flow
}

/**
 * Событие о том, что появилась связь между платежом по инвойсу и транзакцией
 * у провайдера.
 */
struct InvoicePaymentBound {
    /** Идентификатор платежа по инвойсу. */
    1: required domain.InvoicePaymentID payment_id
    /** Данные о связанной транзакции у провайдера. */
    2: required domain.TransactionInfo trx
}

/**
 * Событие об изменении статуса платежа по инвойсу.
 */
struct InvoicePaymentStatusChanged {
    /** Идентификатор платежа по инвойсу. */
    1: required domain.InvoicePaymentID payment_id
    /** Статус платежа по инвойсу. */
    2: required domain.InvoicePaymentStatus status
}

/**
 * Событие об запросе взаимодействия с плательщиком.
 */
struct InvoicePaymentInteractionRequested {
    /** Идентификатор платежа по инвойсу. */
    1: required domain.InvoicePaymentID payment_id
    /** Необходимое взаимодействие */
    2: required user_interaction.UserInteraction interaction
}

/**
 * Событие о прохождении инспекции
 */
struct InvoicePaymentInspected {
    /** Идентификатор платежа по инвойсу. */
    1: required domain.InvoicePaymentID payment_id
    /** Результат инспекции */
    2: required domain.RiskScore risk_score
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

struct InvoicePaymentParams {
    1: required domain.Payer payer
}

// Exceptions

// forward-declared
exception PartyNotFound {}
exception ShopNotFound {}
exception InvalidPartyStatus { 1: required InvalidStatus status }
exception InvalidShopStatus { 1: required InvalidStatus status }

exception InvalidUser {}
exception UserInvoiceNotFound {}
exception InvoicePaymentNotFound {}
exception EventNotFound {}

exception InvoicePaymentPending {
    1: required domain.InvoicePaymentID id
}

exception InvalidInvoiceStatus {
    1: required domain.InvoiceStatus status
}

service Invoicing {

    domain.InvoiceID Create (1: UserInfo user, 2: InvoiceParams params)
        throws (
            1: InvalidUser ex1,
            2: base.InvalidRequest ex2,
            3: PartyNotFound ex3,
            4: ShopNotFound ex4,
            5: InvalidPartyStatus ex5,
            6: InvalidShopStatus ex6
        )

    InvoiceState Get (1: UserInfo user, 2: domain.InvoiceID id)
        throws (
            1: InvalidUser ex1,
            2: UserInvoiceNotFound ex2
        )

    Events GetEvents (1: UserInfo user, 2: domain.InvoiceID id, 3: EventRange range)
        throws (
            1: InvalidUser ex1,
            2: UserInvoiceNotFound ex2,
            3: EventNotFound ex3,
            4: base.InvalidRequest ex4
        )

    domain.InvoicePaymentID StartPayment (
        1: UserInfo user,
        2: domain.InvoiceID id,
        3: InvoicePaymentParams params
    )
        throws (
            1: InvalidUser ex1,
            2: UserInvoiceNotFound ex2,
            3: InvalidInvoiceStatus ex3,
            4: InvoicePaymentPending ex4,
            5: base.InvalidRequest ex5,
            6: InvalidPartyStatus ex6,
            7: InvalidShopStatus ex7
        )

    domain.InvoicePayment GetPayment (
        1: UserInfo user,
        2: domain.InvoiceID id,
        3: domain.InvoicePaymentID payment_id
    )
        throws (
            1: InvalidUser ex1,
            2: UserInvoiceNotFound ex2,
            3: InvoicePaymentNotFound ex3
        )

    void Fulfill (1: UserInfo user, 2: domain.InvoiceID id, 3: string reason)
        throws (
            1: InvalidUser ex1,
            2: UserInvoiceNotFound ex2,
            3: InvalidInvoiceStatus ex3,
            4: InvalidPartyStatus ex4,
            5: InvalidShopStatus ex5
        )

    void Rescind (1: UserInfo user, 2: domain.InvoiceID id, 3: string reason)
        throws (
            1: InvalidUser ex1,
            2: UserInvoiceNotFound ex2,
            3: InvalidInvoiceStatus ex3,
            4: InvoicePaymentPending ex4,
            5: InvalidPartyStatus ex5,
            6: InvalidShopStatus ex6
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
    2: required domain.ShopDetails details
    3: required domain.ContractID contract_id
    4: required domain.PayoutToolID payout_tool_id
    5: optional domain.Proxy proxy
}

struct ContractParams {
    1: required domain.Contractor contractor
    2: optional domain.ContractTemplateRef template
    3: required PayoutToolParams payout_tool_params
}

struct ContractAdjustmentParams {
    1: required domain.ContractTemplateRef template
}

union PartyModification {
    1: domain.Blocking blocking
    2: domain.Suspension suspension
    3: domain.Contract contract_creation
    4: ContractModificationUnit contract_modification
    5: domain.Shop shop_creation
    6: ShopModificationUnit shop_modification
}

struct ContractModificationUnit {
    1: required domain.ContractID id
    2: required ContractModification modification
}

union ContractModification {
    1: ContractTermination termination
    2: domain.ContractAdjustment adjustment_creation
    3: domain.PayoutTool payout_tool_creation
    4: domain.LegalAgreement legal_agreement_binding
}

struct ContractTermination {
    1: required base.Timestamp terminated_at
    2: optional string reason
}

typedef list<PartyModification> PartyChangeset

struct ShopModificationUnit {
    1: required ShopID id
    2: required ShopModification modification
}

union ShopModification {
    1: domain.Blocking blocking
    2: domain.Suspension suspension
    3: ShopUpdate update
    4: ShopAccountCreated account_created
}

struct ShopUpdate {
    1: optional domain.CategoryRef category
    2: optional domain.ShopDetails details
    3: optional domain.ContractID contract_id
    4: optional domain.PayoutToolID payout_tool_id
    5: optional domain.Proxy proxy
}

struct ShopAccountCreated {
    1: required domain.ShopAccount account
}

// Claims

typedef i64 ClaimID

struct Claim {
    1: required ClaimID id
    2: required ClaimStatus status
    3: required PartyChangeset changeset
}

union ClaimStatus {
    1: ClaimPending pending
    2: ClaimAccepted accepted
    3: ClaimDenied denied
    4: ClaimRevoked revoked
}

struct ClaimPending {}

struct ClaimAccepted {
    1: required base.Timestamp accepted_at
}

struct ClaimDenied {
    1: required string reason
}

struct ClaimRevoked {
    1: required string reason
}

struct ClaimResult {
    1: required ClaimID id
    2: required ClaimStatus status
}

struct AccountState {
    1: required domain.AccountID account_id
    2: required domain.Amount own_amount
    3: required domain.Amount available_amount
    4: required domain.Currency currency
}

// Events

union PartyEvent {
    1: domain.Party party_created
    2: Claim claim_created
    3: ClaimStatusChanged claim_status_changed
}

struct ClaimStatusChanged {
    1: required ClaimID id
    2: required ClaimStatus status
}

// Exceptions

exception PartyExists {}
exception ClaimNotFound {}
exception ContractNotFound {}
exception InvalidContractStatus { 1: required domain.ContractStatus status }
exception PayoutToolNotFound {}


exception InvalidClaimStatus {
    1: required ClaimStatus status
}

union InvalidStatus {
    1: domain.Blocking blocking
    2: domain.Suspension suspension
}

exception AccountNotFound {}

exception ShopAccountNotFound {}

// Service

service PartyManagement {

    void Create (1: UserInfo user, 2: PartyID party_id, 3: PartyParams params)
        throws (1: InvalidUser ex1, 2: PartyExists ex2)

    domain.Party Get (1: UserInfo user, 2: PartyID party_id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2)

    ClaimResult CreateContract (1: UserInfo user, 2: PartyID party_id, 3: ContractParams params)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: InvalidPartyStatus ex3,
            4: base.InvalidRequest ex4
        )

    domain.Contract GetContract (1: UserInfo user, 2: PartyID party_id, 3: domain.ContractID contract_id)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: ContractNotFound ex3
        )

    ClaimResult TerminateContract (1: UserInfo user, 2: PartyID party_id, 3: domain.ContractID contract_id, 4: string reason)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: ContractNotFound ex3,
            4: InvalidContractStatus ex4,
            5: base.InvalidRequest ex5
        )

    ClaimResult BindContractLegalAgreemnet (
        1: UserInfo user,
        2: PartyID party_id,
        3: domain.ContractID contract_id,
        4: domain.LegalAgreement legal_agreement
    )
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: ContractNotFound ex3,
            4: InvalidContractStatus ex4,
            5: InvalidPartyStatus ex5,
            6: base.InvalidRequest ex6
        )

    ClaimResult CreateContractAdjustment (
        1: UserInfo user,
        2: PartyID party_id,
        3: domain.ContractID contract_id,
        4: ContractAdjustmentParams params
    )
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: ContractNotFound ex3,
            4: InvalidContractStatus ex4,
            5: InvalidPartyStatus ex5,
            6: base.InvalidRequest ex6
        )

    ClaimResult CreatePayoutTool (
        1: UserInfo user,
        2: PartyID party_id,
        3: domain.ContractID contract_id,
        4: PayoutToolParams params
    )
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: InvalidPartyStatus ex3,
            4: ContractNotFound ex4,
            5: InvalidContractStatus ex5,
            6: base.InvalidRequest ex6
        )

    ClaimResult CreateShop (1: UserInfo user, 2: PartyID party_id, 3: ShopParams params)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: InvalidPartyStatus ex3,
            5: ContractNotFound ex5,
            6: InvalidContractStatus ex6,
            7: PayoutToolNotFound ex7,
            4: base.InvalidRequest ex4
        )

    domain.Shop GetShop (1: UserInfo user, 2: PartyID party_id, 3: ShopID id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: ShopNotFound ex3)

    ClaimResult UpdateShop (1: UserInfo user, 2: PartyID party_id, 3: ShopID id, 4: ShopUpdate update)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: ShopNotFound ex3,
            4: InvalidPartyStatus ex4,
            5: InvalidShopStatus ex5,
            7: ContractNotFound ex7,
            8: InvalidContractStatus ex8,
            9: PayoutToolNotFound ex9,
            6: base.InvalidRequest ex6
        )

    /* Claims */

    Claim GetClaim (1: UserInfo user, 2: PartyID party_id, 3: ClaimID id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: ClaimNotFound ex3)

    Claim GetPendingClaim (1: UserInfo user, 2: PartyID party_id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: ClaimNotFound ex3)

    void AcceptClaim (1: UserInfo user, 2: PartyID party_id, 3: ClaimID id)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: ClaimNotFound ex3,
            4: InvalidClaimStatus ex4
        )

    void DenyClaim (1: UserInfo user, 2: PartyID party_id, 3: ClaimID id, 4: string reason)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: ClaimNotFound ex3,
            4: InvalidClaimStatus ex4
        )

    void RevokeClaim (1: UserInfo user, 2: PartyID party_id, 3: ClaimID id, 4: string reason)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: InvalidPartyStatus ex3,
            4: ClaimNotFound ex4,
            5: InvalidClaimStatus ex5
        )

    /* Party blocking / suspension */

    ClaimResult Suspend (1: UserInfo user, 2: PartyID party_id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: InvalidPartyStatus ex3)

    ClaimResult Activate (1: UserInfo user, 2: PartyID party_id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: InvalidPartyStatus ex3)

    ClaimResult Block (1: UserInfo user, 2: PartyID party_id, 3: string reason)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: InvalidPartyStatus ex3)

    ClaimResult Unblock (1: UserInfo user, 2: PartyID party_id, 3: string reason)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: InvalidPartyStatus ex3)

    /* Shop blocking / suspension */

    ClaimResult SuspendShop (1: UserInfo user, 2: PartyID party_id, 3: ShopID id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: ShopNotFound ex3, 4: InvalidShopStatus ex4)

    ClaimResult ActivateShop (1: UserInfo user, 2: PartyID party_id, 3: ShopID id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: ShopNotFound ex3, 4: InvalidShopStatus ex4)

    ClaimResult BlockShop (1: UserInfo user, 2: PartyID party_id, 3: ShopID id, 4: string reason)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: ShopNotFound ex3, 4: InvalidShopStatus ex4)

    ClaimResult UnblockShop (1: UserInfo user, 2: PartyID party_id, 3: ShopID id, 4: string reason)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: ShopNotFound ex3, 4: InvalidShopStatus ex4)

    /* Event polling */

    Events GetEvents (1: UserInfo user, 2: domain.PartyID party_id, 3: EventRange range)
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
