include "base.thrift"
include "proxy.thrift"
include "domain.thrift"
include "preauth_result.thrift"

namespace java com.rbkmoney.damsel.proxy_preauth
namespace erlang proxy_preauth

struct Session {
    1: optional proxy.ProxyState state
}

struct Context {
    1: required Session session
    2: required PaymentInfo payment
}

struct PaymentInfo {
    1: required Shop shop
    2: required Invoice invoice
    3: required InvoicePayment payment
}

struct Shop {
    1: required domain.ShopID id
    2: required domain.Category category
    3: required domain.ShopDetails details
}

struct Invoice {
    1: required domain.InvoiceID id
    2: required base.Timestamp created_at
    3: required string product
    4: optional string description
    5: required domain.Cash cost
}

struct InvoicePayment {
    1: required domain.InvoicePaymentID id
    2: required base.Timestamp created_at
    3: required domain.Payer payer
    4: required domain.Cash cost
}

struct Binding {
    1: required string id
    2: optional base.Timestamp timestamp
}

struct ProxyResult {
    1: required proxy.Intent intent
    2: optional proxy.ProxyState next_state
    3: optional AuthResult auth_result
    4: optional Binding binding
}

struct AuthResult {
    1: required preauth_result.Status status
    2: optional preauth_result.Params params
}

struct CallbackResult {
    1: required proxy.CallbackResponse response
    2: required ProxyResult result
}

service PreauthProxy {
    ProxyResult AuthPayment (1: Context context)
        throws (1: base.TryLater ex1)

    CallbackResult HandleAuthCallback (1: proxy.Callback callback, 2: Context context)
        throws (1: base.TryLater ex1)
}

service PreauthProxyHost {
    proxy.CallbackResponse ProcessCallback (1: base.Tag tag, 2: proxy.Callback callback)
        throws (1: base.InvalidRequest ex1)
}
