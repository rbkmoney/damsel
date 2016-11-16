include "base.thrift"
include "proxy.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.proxy_preauth
namespace erlang proxy_preauth

typedef base.Opaque Callback
typedef base.Opaque CallbackResponse

struct Session {
    1: optional proxy.ProxyState state
}

struct Context {
    1: required Session session
    2: required domain.PaymentTool payment_tool
    3: required domain.Cash cost
    4: required domain.ClientInfo client_info
}

struct ProxyResult {
    1: required proxy.Intent intent
    2: optional proxy.ProxyState next_state
    3: required AuthResult auth_result
}

struct AuthResult {
    1: required AuthStatus status
    2: optional base.Opaque params
}

union AuthStatus {
    1: optional AuthPending pending
    2: optional AuthSuccess success
    3: optional AuthFail fail
    4: optional AuthUnavailable unavailable
}

struct CallbackResult {
    1: required CallbackResponse response
    2: required ProxyResult result
}

struct AuthPending {}
struct AuthSuccess {}
struct AuthFail {}
struct AuthUnavailable {}

service PreauthProxy {
    ProxyResult AuthPayment (1: Context context)
        throws (1: base.TryLater ex1)

    CallbackResult HandleAuthCallback (1: Callback callback, 2: Context context)
        throws (1: base.TryLater ex1)
}

service PreauthProxyHost {
    CallbackResponse ProcessCallback (1: base.Tag tag, 2: Callback callback)
        throws (1: base.InvalidRequest ex1)
}
