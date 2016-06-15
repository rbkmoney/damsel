/**
 * Определения и сервисы процессинга.
 */

include "base.thrift"
include "domain.thrift"

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

struct Event {
    1: required base.EventID id
    2: required EventType ev
}

typedef list<Event> Events

union EventType {
    1: InvoiceStatusChanged invoice_status_changed
    2: InvoicePaymentStatusChanged invoice_payment_status_changed
}

struct InvoiceStatusChanged {
    1: required domain.Invoice invoice
}

struct InvoicePaymentStatusChanged {
    2: required domain.InvoicePayment payment
}

struct EventRange {
    1: optional base.EventID after
    2: required i32 limit
}

/* Service definitions */

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
