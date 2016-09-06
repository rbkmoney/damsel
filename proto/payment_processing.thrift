/**
 * Определения и сервисы процессинга.
 */

include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.payment_processing
namespace erlang payproc

/* Interface clients */

typedef base.ID UserID

struct UserInfo {
    1: required UserID id
}

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
    1: InvoiceEvent            invoice_event
    /** Некоторое событие, порождённое участником. */
    2: PartyEvent              party_event
}

/**
 * Один из возможных вариантов события, порождённого инвойсом.
 */
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
 * Событие об запуске платежа по инвойсу.
 */
struct InvoicePaymentStarted {
    /** Данные запущенного платежа. */
    1: required domain.InvoicePayment payment
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
    7: required ShopID shop_id
    1: required string product
    2: optional string description
    3: required base.Timestamp due
    4: required domain.Amount amount
    5: required domain.CurrencyRef currency
    6: required domain.InvoiceContext context
}

struct InvoicePaymentParams {
    1: required domain.Payer payer
}

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
        throws (1: InvalidUser ex1, 2: base.InvalidRequest ex2)

    InvoiceState Get (1: UserInfo user, 2: domain.InvoiceID id)
        throws (1: InvalidUser ex1, 2: UserInvoiceNotFound ex2)

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
            5: base.InvalidRequest ex5
        )

    domain.InvoicePayment GetPayment (1: UserInfo user, 2: domain.InvoicePaymentID id)
        throws (1: InvalidUser ex1, 2: InvoicePaymentNotFound ex2)

    void Fulfill (1: UserInfo user, 2: domain.InvoiceID id, 3: string reason)
        throws (1: InvalidUser ex1, 2: UserInvoiceNotFound ex2, 3: InvalidInvoiceStatus ex3)

    void Rescind (1: UserInfo user, 2: domain.InvoiceID id, 3: string reason)
        throws (1: InvalidUser ex1, 2: UserInvoiceNotFound ex2, 3: InvalidInvoiceStatus ex3)

}

/* Party management service definitions */

// Types

typedef domain.PartyID PartyID
typedef domain.ShopID  ShopID

struct PartyState {
    1: required domain.Party party
    2: required domain.DataRevision revision
}

struct ShopState {
    1: required domain.Shop shop
    2: required domain.DataRevision revision
}

struct ShopParams {
    1: required domain.CategoryObject category
    2: required domain.ShopDetails details
    3: optional domain.Contractor contractor
}

union PartyModification {
    1: domain.Blocking blocking
    2: domain.Suspension suspension
    3: domain.Shop shop_creation
    4: ShopModificationUnit shop_modification
}

typedef list<PartyModification> PartyChangeset

struct ShopModificationUnit {
    1: required ShopID id
    2: ShopModification modification
}

union ShopModification {
    1: domain.Blocking blocking
    2: domain.Suspension suspension
    3: ShopUpdate update
}

struct ShopUpdate {
    1: optional domain.CategoryObject category
    2: optional domain.ShopDetails details
    3: optional domain.Contractor contractor
}

typedef base.ID ClaimID

struct Claim {
    1: required ClaimID id
    2: required ClaimStatus status
    3: required PartyChangeset changeset
}

union ClaimStatus {
    1: ClaimPending pending
    2: ClaimAccepted approved
    3: ClaimDenied denied
    4: ClaimRevoked revoked
}

struct ClaimPending {}

struct ClaimAccepted {
    1: required domain.DataRevision revision
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

// Events

union PartyEvent {
    1: PartyCreated party_created
    2: ClaimCreated claim_created
    3: ClaimStatusChanged claim_status_changed
}

struct PartyCreated {
    1: required PartyState party
}

struct ClaimCreated {
    1: required Claim claim
}

struct ClaimStatusChanged {
    1: required ClaimID id
    2: required ClaimStatus status
}

// Exceptions

exception PartyExists {}
exception PartyNotFound {}
exception ShopNotFound {}
exception ClaimNotFound {}

exception InvalidClaimStatus {
    1: required ClaimStatus status
}

union InvalidStatus {
    1: domain.Blocking blocking
    2: domain.Suspension suspension
}

exception InvalidPartyStatus {
    1: required InvalidStatus status
}

exception InvalidShopStatus {
    1: required InvalidStatus status
}

// Service

service PartyManagement {

    void Create (1: UserInfo user, 2: PartyID party_id)
        throws (1: InvalidUser ex1, 2: PartyExists ex2)

    PartyState Get (1: UserInfo user, 2: PartyID party_id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2)

    ClaimResult CreateShop (1: UserInfo user, 2: PartyID party_id, 3: ShopParams params)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: InvalidPartyStatus ex3,
            4: base.InvalidRequest ex4
        )

    ShopState GetShop (1: UserInfo user, 2: PartyID party_id, 3: ShopID id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: ShopNotFound ex3)

    ClaimResult UpdateShop (1: UserInfo user, 2: PartyID party_id, 3: ShopID id, 4: ShopUpdate update)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: ShopNotFound ex3,
            4: InvalidPartyStatus ex4,
            5: InvalidShopStatus ex5,
            6: base.InvalidRequest ex6
        )

    // TODO do we really need that?
    // ClaimResult RemoveShop (1: UserInfo user, 2: PartyID party_id, 3: domain.ShopID shop_id)
    //     throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: ShopNotFound ex3)

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
            3: ClaimNotFound ex3,
            4: InvalidClaimStatus ex4
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
