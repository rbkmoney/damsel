include "base.thrift"
include "proxy.thrift"
include "domain.thrift"
include "payment_processing.thrift"

namespace java com.rbkmoney.damsel.proxy_provider
namespace erlang prxprv

struct RecurrentPaymentTool {
    1: required payment_processing.RecurrentPaymentToolID id
    2: required base.Timestamp                            created_at
    3: required domain.DisposablePaymentResource          payment_resource
    4: optional domain.Token                              rec_token
}

/**
 * Данные, необходимые для генерации многоразового токена
 */
struct RecurrentTokenInfo {
    1: required Shop                   shop
    2: required RecurrentPaymentTool   payment_tool
    3: optional domain.TransactionInfo trx
}

/**
 * Данные сессии взаимодействия с провайдерским прокси в рамках генерации многоразового токена.
 */
struct RecurrentTokenGenerationSession {
    1: optional proxy.ProxyState state
}

/**
 * Набор данных для взаимодействия с провайдерским прокси в рамках проведения генерации
 * многоразового токена.
 */
struct RecurrentTokenGenerationContext {
    1: required RecurrentTokenGenerationSession session
    2: required RecurrentTokenInfo              token_info
    3: optional domain.ProxyOptions             options = {}
}

struct RecurrentTokenGenerationProxyResult {
    1: required proxy.Intent           intent
    2: optional proxy.ProxyState       next_state
    3: optional domain.Token           token
    4: optional domain.TransactionInfo trx
}

struct RecurrentTokenGenerationCallbackResult {
    1: required proxy.CallbackResponse              response
    2: required RecurrentTokenGenerationProxyResult result
}

/**
 * Данные платежа, необходимые для обращения к провайдеру.
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
 * Набор данных для взаимодействия с провайдерским прокси в рамках платежа.
 */
struct PaymentContext {
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
struct PaymentProxyResult {
    1: required proxy.Intent intent
    2: optional proxy.ProxyState next_state
    3: optional domain.TransactionInfo trx
}

/**
 * Результат обработки провайдерским прокси обратного вызова в рамках сессии.
 */
struct PaymentCallbackResult {
    1: required proxy.CallbackResponse response
    2: required PaymentCallbackProxyResult result
}

struct PaymentCallbackProxyResult {
    // TODO temporary crutch, remove it as soon as possible
    // An `undefined` means that the suspend will be kept untouched
    1: optional proxy.Intent intent
    2: optional proxy.ProxyState next_state
    3: optional domain.TransactionInfo trx
}

service ProviderProxy {

    /**
     * Запрос к прокси на создание многоразового токена
     */
    RecurrentTokenGenerationProxyResult GenerateToken (
        1: RecurrentTokenGenerationContext context
    )

    /**
     * Запрос к прокси на обработку обратного вызова от провайдера в рамках сессии получения
     * многоразового токена.
     */
    RecurrentTokenGenerationCallbackResult HandleRecurrentTokenGenerationCallback (
        1: proxy.Callback                  callback
        2: RecurrentTokenGenerationContext context
    )

    /**
     * Запрос к прокси на проведение взаимодействия с провайдером в рамках платежной сессии.
     */
    PaymentProxyResult ProcessPayment (1: PaymentContext context)

    /**
     * Запрос к прокси на обработку обратного вызова от провайдера в рамках платежной сессии.
     */
    PaymentCallbackResult HandlePaymentCallback (1: proxy.Callback callback, 2: PaymentContext context)

}

service ProviderProxyHost {

    /**
     * Запрос к процессингу на обработку обратного вызова от провайдера.
     */
    proxy.CallbackResponse ProcessCallback (1: base.Tag tag, 2: proxy.Callback callback)
        throws (1: base.InvalidRequest ex1)

}
