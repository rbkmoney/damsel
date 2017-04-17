include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.webhooker
namespace erlang webhooker

typedef string Url
typedef string Key
typedef i64 WebhookID
exception WebhookNotFound {}

struct Webhook {
    1: required WebhookID id
    2: required domain.PartyID party_id
    3: required EventFilter event_filter
    4: required Url url
    5: required Key pub_key
    6: required bool enabled
}

struct WebhookParams {
    1: required domain.PartyID party_id
    2: required EventFilter event_filter
    3: required Url url
}

union EventFilter {
    1: PartyEventFilter party
    2: InvoiceEventFilter invoice
}

struct PartyEventFilter {
    1: required set<PartyEventType> types
}

union PartyEventType {
    1: ClaimEventType claim
}

union ClaimEventType {
    1: ClaimCreated created
    2: ClaimDenied denied
    3: ClaimAccepted accepted
}

struct ClaimCreated {}
struct ClaimDenied {}
struct ClaimAccepted {}

struct InvoiceEventFilter {
    1: required set<InvoiceEventType> types
    2: optional domain.ShopID shop_id
}

union InvoiceEventType {
    1: InvoiceCreated created
    2: InvoiceStatusChanged status_changed
    3: InvoicePaymentEventType payment
}

struct InvoiceCreated {}
struct InvoiceStatusChanged {
    1: optional domain.InvoiceStatus value
}

union InvoicePaymentEventType {
    1: InvoicePaymentCreated created
    2: InvoicePaymentStatusChanged status_changed
}

struct InvoicePaymentCreated {}
struct InvoicePaymentStatusChanged {
    1: optional domain.InvoicePaymentStatus value
}

service WebhookManager {
    list<Webhook> GetList(1: domain.PartyID party_id)
    Webhook Get(1: WebhookID webhook_id) throws (1: WebhookNotFound ex1)
    Webhook Create(1: WebhookParams webhook_params)
    void Delete(1: WebhookID webhook_id) throws (1: WebhookNotFound ex1)
}
