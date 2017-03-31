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
    1: InvoiceCreated invoice_created
    2: InvoicePaid invoice_paid
    3: PartyShopCreated party_shop_created
}

struct InvoiceCreated {
    1: required domain.ShopID shop_id
}

struct InvoicePaid {
    1: required domain.ShopID shop_id
}

struct PartyShopCreated {
}

service WebhookManager {
    list<Webhook> Get(1: domain.PartyID party_id)
    Webhook Create(1: WebhookParams webhook_params)
    void Delete(1: base.ID webhook_id) throws (1: WebhookNotFound ex1)
}
