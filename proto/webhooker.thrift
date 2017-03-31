include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.webhooker
namespace erlang webhooker

typedef string Url
typedef string Key
exception WebhookNotFound {}

struct Webhook {
    1: required base.ID id
    2: required domain.PartyID party_id
    3: required EventFilter event_filter
    4: required Url url
    5: required Key pub_key
}

struct WebhookParams {
    1: required domain.PartyID party_id
    2: required EventFilter filter_struct
    3: required Url url
}

union EventFilter {
    1: PartyEventFilter   party
    2: InvoiceEventFilter invoice
}

struct PartyEventFilter {
    1: required PartyEventType type
}

union PartyEventType {
    1: ClaimEventType claim
}

union ClaimEventType {
    1: ClaimCreated  created
    2: ClaimDenied   denied
    3: ClaimAccepted accepted
}

struct ClaimCreated {}
struct ClaimDenied {}
struct ClaimAccepted {}

struct InvoiceEventFilter {
    1: required InvoiceEventType type
    2: optional domain.ShopID shop_id
}

union InvoiceEventType {
    1: InvoiceCreated            created
    2: InvoiceStatusChanged      status_changed
    3: InvoicePaymentEventType payment
}

struct InvoiceCreated {}
struct InvoiceStatusChanged {}

union InvoicePaymentEventType {
    1: InvoicePaymentCreated       created
    2: InvoicePaymentStatusChanged status_changed
}

struct InvoicePaymentCreated {}
struct InvoicePaymentStatusChanged {}

service WebhookManager {
    list<Webhook> Get(1: domain.PartyID party_id)
    Webhook Create(1: WebhookParams webhook_params)
    void Delete(1: base.ID webhook_id) throws (1: WebhookNotFound ex1)
}
