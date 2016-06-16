/**
 * Определения и сервисы процессинга.
 */

include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.payment_processing

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
    1: required base.EventID id

    /**
     * Идентификатор бизнес-объекта, источника события.
     */
    2: required EventSource  source

    /**
     * Номер события в последовательности событий от указанного источника.
     *
     * Номер первого события от источника всегда равен `1`, то есть `sequence`
     * принимает значения из диапазона `[1; 2^31)`
     */
    3: required i32          sequence

    /**
     * Содержание события.
     */
    4: required EventPayload ev

}

/**
 * Источник события, идентификатор бизнес-объекта, который породил его в
 * процессе выполнения определённого бизнес-процесса.
 */
union EventSource {
    /** Идентификатор инвойса, который породил событие. */
    1: domain.InvoiceID        invoice
}

typedef list<Event> Events

/**
 * Один из возможных вариантов содержания события.
 */
union EventPayload {
    /** Некоторое событие, порождённое инвойсом. */
    1: InvoiceEvent            invoice_event
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
    1: InvoicePaymentStarted   invoice_payment_started
    2: InvoicePaymentBound     invoice_payment_bound
    3: InvoicePaymentSucceeded invoice_payment_succeeded
    4: InvoicePaymentFailed    invoice_payment_failed
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
    /** Человекочитаемые данные, связанные с изменением статуса. */
    2: optional string details
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
 * Событие об успешном прохождении платежа по инвойсу.
 */
struct InvoicePaymentSucceeded {
    /** Идентификатор платежа по инвойсу. */
    1: required domain.InvoicePaymentID payment_id
}

/**
 * Событие о неуспешном завершении платежа по инвойсу.
 */
struct InvoicePaymentFailed {
    /** Идентификатор платежа по инвойсу. */
    1: required domain.InvoicePaymentID payment_id
    /** Данные ошибки, явившейся причиной завершения платежа. */
    2: required domain.OperationError error
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
    1: required string product
    2: optional string description
    3: required base.Timestamp due
    4: required domain.Amount amount
    5: required domain.CurrencyRef currency
    6: required domain.InvoiceContext context
}

struct InvoicePaymentParams {
    1: required domain.Payer payer
    2: required domain.PaymentTool payment_tool
    3: required domain.PaymentSession session
}

exception InvalidUser {}
exception UserInvoiceNotFound {}
exception InvoicePaymentPending { 1: required domain.InvoicePaymentID id }
exception InvoicePaymentNotFound {}
exception EventNotFound {}
exception InvalidInvoiceStatus { 1: required domain.InvoiceStatus status }

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

    void Void (1: UserInfo user, 2: domain.InvoiceID id, 3: string reason)
        throws (1: InvalidUser ex1, 2: UserInvoiceNotFound ex2, 3: InvalidInvoiceStatus ex3)

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
