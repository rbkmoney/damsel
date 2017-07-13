include "base.thrift"
include "proxy.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.proxy_provider
namespace erlang prxprv

/**
 * Данные, необходимые для генерации многоразового токена
 */
struct TokenInfo {
    1: required domain.Token            token
    2: required domain.PaymentSessionID session
}

/**
 * Данные сессии взаимодействия с провайдерским прокси в рамках генерации многоразового токена.
 */
struct TokenGenerationSession {
    1: required TargetPaymentMeanStatus target
    2: optional proxy.ProxyState        state
}

/**
 * Целевое значение статуса многоразового токена.
 */
union TargetPaymentMeanStatus {
    1: domain.PaymentMeanPending  pending
    2: domain.PaymentMeanAcquired acquired
    3: domain.PaymentMeanFailed   failed
}

/**
 * Набор данных для взаимодействия с провайдерским прокси в рамках проведения генерации
 * многоразового токена.
 */
struct TokenGenerationContext {
    1: required TokenGenerationSession session
    2: required TokenInfo              token_info
    3: optional domain.ProxyOptions    options = {}
}

struct TokenGenerationProxyResult {
    1: required proxy.Intent       intent
    2: optional proxy.ProxyState   next_state
    3: optional domain.PaymentMean payment_mean
}

struct TokenGenerationCallbackResult {
    1: required proxy.CallbackResponse     response
    2: required TokenGenerationProxyResult result
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
 * Данные сессии взаимодействия с провайдерским прокси в рамках платежа.
 */
struct Session {
    1: required TargetInvoicePaymentStatus target
    2: optional proxy.ProxyState state
}

/**
 * Целевое значение статуса платежа.
 * Согласно https://github.com/rbkmoney/coredocs/blob/589799f/docs/domain/entities/payment.md
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
    TokenGenerationProxyResult GenerateToken(
        1: domain.Token token,
        2: domain.PaymentSessionID session_id
        3: domain.BindingID binding_id
    )

    /**
     * Запрос к прокси на обработку обратного вызова от провайдера в рамках сессии получения
     * многоразового токена.
     */
    TokenGenerationCallbackResult HandleTokenGenerationCallback (
        1: proxy.Callback callback,
        2: TokenGenerationContext context
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
