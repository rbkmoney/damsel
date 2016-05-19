/**
 * Определения и сервисы процессинга.
 */

include "base.thrift"
include "domain.thrift"

/* Interface clients */

typedef base.ID ClientID

struct Client {
    1: required ClientID id
}

/* Invoices */

struct InvoiceState {
    1: required domain.Invoice invoice
    2: required list<domain.InvoicePayment> payments = []
}

/* Events */

typedef base.ID EventID

struct Event {
    1: required EventID id
    2: required EventType ev
}

typedef list<Event> Events

union EventType {
    1: InvoiceStatusChanged invoice_status_changed
    2: InvoicePaymentStatusChanged invoice_payment_finished
}

struct InvoiceStatusChanged {
    1: required domain.Invoice invoice
}

struct InvoicePaymentStatusChanged {
    1: required domain.InvoiceID invoice_id
    2: required domain.InvoicePayment payment
}

struct EventRange {
    1: optional EventID after
    2: required i32 limit
}

/* Service definitions */

struct InvoiceParams {
    1: required string product
    2: optional string description
    3: required domain.Funds cost
    4: required domain.InvoiceContext context
}

struct InvoicePaymentParams {
    1: required domain.Payer payer
    2: required domain.PaymentTool payment_tool
    3: required domain.PaymentSession session
}

exception InvalidClient {}
exception InvoiceNotFound {}
exception EventNotFound {}
exception InvalidInvoiceStatus { 1: required domain.InvoiceStatus status }

service Invoicing {

    domain.InvoiceID Create (1: Client client)
        throws (1: InvalidClient ex1)

    InvoiceState Get (1: Client client, 2: domain.InvoiceID id)
        throws (1: InvalidClient ex1, 2: InvoiceNotFound ex2)

    Events GetEvents (1: Client client, 2: domain.InvoiceID id, 3: EventRange range)
        throws (1: InvalidClient ex1, 2: InvoiceNotFound ex2, 3: EventNotFound ex3)

    domain.InvoicePaymentID StartPayment (
        1: Client client,
        2: domain.InvoiceID id,
        3: InvoicePaymentParams params
    )
        throws (1: InvalidClient ex1, 2: InvoiceNotFound ex2, 3: InvalidInvoiceStatus ex3)

    void Fulfill (1: Client client, 2: domain.InvoiceID id, 3: string reason)
        throws (1: InvalidClient ex1, 2: InvoiceNotFound ex2, 3: InvalidInvoiceStatus ex3)

    void Void (1: Client client, 2: domain.InvoiceID id, 3: string reason)
        throws (1: InvalidClient ex1, 2: InvoiceNotFound ex2, 3: InvalidInvoiceStatus ex3)

}
