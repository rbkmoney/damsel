include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.proxy_inspector
namespace erlang proxy_inspector

/**
 * Набор данных для взаимодействия с инспекторским прокси.
 */
struct Context {
    1: required PaymentInfo payment
    2: optional domain.ProxyOptions options = {}
}

/**
 * Данные платежа, необходимые для инспекции платежа.
 */
struct PaymentInfo {
    1: required Shop shop
    2: required InvoicePayment payment
    3: required Invoice invoice
    4: required Party party
}

struct Party {
    1: required domain.PartyID party_id
}

struct Shop {
    1: required domain.ShopID id
    2: required domain.Category category
    3: required domain.ShopDetails details
    4: required domain.ShopLocation location
}

struct InvoicePayment {
    1: required domain.InvoicePaymentID id
    2: required base.Timestamp created_at
    3: required domain.Payer payer
    4: required domain.Cash cost
}

struct Invoice {
    1: required domain.InvoiceID id
    2: required base.Timestamp created_at
    3: required base.Timestamp due
    4: required domain.InvoiceDetails details
}

service InspectorProxy {
    domain.RiskScore InspectPayment (1: Context context)
        throws (1: base.InvalidRequest ex1)
}
