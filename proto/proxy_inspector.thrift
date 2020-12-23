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

/**
 * Данные привязки платежного средства для взаимодействия с инспекторским прокси.
 */
struct BindingContext {
    1: required BindingInfo binding
    2: optional domain.ProxyOptions options = {}
}

/**
 * Данные платежного стредства для инспекции привязки.
 */
struct BindingInfo {
    1: required Party party
    2: required Shop shop
    3: required domain.PaymentTool payment_tool
    /** пробросить из Customer state */
    4: required domain.CustomerID customer_id
    /** пробросить из Customer state */
    5: optional domain.ContactInfo contact_info
}

service InspectorProxy {
    domain.RiskScore InspectPayment (1: Context context)
        throws (1: base.InvalidRequest ex1)

    domain.RiskScore InspectBinding (1: BindingContext context)
        throws (1: base.InvalidRequest ex1)
}
