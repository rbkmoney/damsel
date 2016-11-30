include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.proxy_inspector
namespace erlang proxy_inspector


/**
 * Данные платежа, необходимые для инспекции платежа.
 */
struct PaymentInfo {
    1: required Shop shop
    2: required InvoicePayment payment
}

struct Shop {
    1: required domain.ShopID id
    2: required domain.Category category
    3: required domain.ShopDetails details
}

struct InvoicePayment {
    1: required domain.InvoicePaymentID id
    2: required base.Timestamp created_at
    3: required domain.Payer payer
    4: required domain.Cash cost
}

service InspectorProxy {
    domain.RiskScore InspectPayment (1: PaymentInfo payment_info)
        throws (1: base.TryLater ex1)
}
