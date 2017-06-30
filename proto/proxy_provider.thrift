include "base.thrift"
include "proxy.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.proxy_provider
namespace erlang prxprv

/**
 * Данные платежа, необходимые для обращения к провайдеру.
 */
struct PaymentInfo {
    1: required Shop shop
    2: required Invoice invoice
    3: required InvoicePayment payment
    4: optional InvoicePaymentRefund refund
}

struct Shop {
    1: required domain.ShopID id
    2: required domain.Category category
    3: required domain.ShopDetails details
    4: required domain.ShopLocation location
}

struct Invoice {
    1: required domain.InvoiceID id
    2: required base.Timestamp created_at
    3: required base.Timestamp due
    7: required domain.InvoiceDetails details
    6: required Cash cost
}

struct InvoicePayment {
    1: required domain.InvoicePaymentID id
    2: required base.Timestamp created_at
    3: optional domain.TransactionInfo trx
    4: required domain.Payer payer
    5: required Cash cost
}

struct InvoicePaymentRefund {
    1: required domain.InvoicePaymentRefundID id
    2: required base.Timestamp created_at
    3: optional domain.TransactionInfo trx
}

struct Cash {
    1: required domain.Amount amount
    2: required domain.Currency currency
}

/**
 * Данные сессии взаимодействия с провайдерским прокси.
 *
 * В момент, когда прокси успешно завершает сессию взаимодействия, процессинг считает,
 * что поставленная цель достигнута, и платёж перешёл в соответствующий статус.
 */
struct Session {
    1: required domain.TargetInvoicePaymentStatus target
    2: optional proxy.ProxyState state
}

/**
 * Набор данных для взаимодействия с провайдерским прокси.
 */
struct Context {
    1: required Session session
    2: required PaymentInfo payment_info
    3: optional domain.ProxyOptions options = {}
}

/**
 * Результат обращения к провайдерскому прокси в рамках сессии.
 *
 * В результате обращения прокси может решить, следует ли:
 *  - завершить сессию взаимодействия с провайдером (FinishIntent); или
 *  - просто приостановить на определённое время (SleepIntent), обновив своё состояние, которое
 *    вернётся к нему в последующем запросе; или
 *  - приостановить до получения обратного запроса (SuspendIntent), обновив своё состояние, которое
 *    вернётся к нему при получени означенного обратного запроса.
 *
 * Прокси может связать с текущим платежом данные транзакции у провайдера для учёта в нашей системе,
 * причём на эти данные налагаются следующие требования:
 *  - данные должны быть связаны на момент завершения сессии взаимодействия с провайдером в рамках
 *    достижения цели по переводу платежа в статус `processed`;
 *  - идентификатор связанной транзакции _не может измениться_ при последующих обращениях в прокси
 *    по текущему платежу.
 */
struct ProxyResult {
    1: required proxy.Intent intent
    2: optional proxy.ProxyState next_state
    3: optional domain.TransactionInfo trx
}

/**
 * Результат обработки провайдерским прокси обратного вызова в рамках сессии.
 */
struct CallbackResult {
    1: required proxy.CallbackResponse response
    2: required ProxyResult result
}

service ProviderProxy {

    /**
     * Запрос к прокси на проведение взаимодействия с провайдером в рамках сессии.
     */
    ProxyResult ProcessPayment (1: Context context)

    /**
     * Запрос к прокси на обработку обратного вызова от провайдера в рамках сессии.
     */
    CallbackResult HandlePaymentCallback (1: proxy.Callback callback, 2: Context context)

}

service ProviderProxyHost {

    /**
     * Запрос к процессингу на обработку обратного вызова от провайдера.
     */
    proxy.CallbackResponse ProcessCallback (1: base.Tag tag, 2: proxy.Callback callback)
        throws (1: base.InvalidRequest ex1)

}
