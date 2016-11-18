include "base.thrift"
include "proxy.thrift"
include "domain.thrift"
include "preauth.thrift"

namespace java com.rbkmoney.damsel.proxy_preauth
namespace erlang proxy_preauth

struct Context {
    1: required Session session
    2: required PaymentInfo payment
    3: optional domain.ProxyOptions options = {}
}

/**
 * Сессия взаимодействия с предавторизационным прокси
 */
struct Session {
    1: optional proxy.ProxyState state
}

/**
 * Данные платежа, необходимые для предавторизации платежа.
 */
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

/**
 * Связь с третьей стороной - авторизатором платежей
 */
struct Binding {
    1: required string id
    2: optional base.Timestamp timestamp
    3: required base.StringMap extra = []
}


/**
 * Требование прокси к процессингу, отражающее дальнейший прогресс сессии взаимодействия
 * с третьей стороной.
 */
union Intent {
    1: FinishIntent finish
    2: proxy.SleepIntent sleep
    3: proxy.SuspendIntent suspend
}

/**
 * Требование завершить сессию взаимодействия с третьей стороной.
 */
struct FinishIntent {
    1: required FinishStatus status
}

typedef base.Error ThirdPartyError

/**
 * Статус, c которым завершилась сессия взаимодействия с третьей стороной.
 */
union FinishStatus {
    /** Успешное завершение взаимодействия. */
    1: preauth.Status ok
    /** Неуспешное завершение взаимодействия с пояснением возникшей проблемы. */
    2: ThirdPartyError failure
}

/**
 * Результат взаимодействия с прокси
 */
struct ProxyResult {
    1: required Intent intent
    2: optional proxy.ProxyState next_state
    3: optional Binding binding
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
