/**
Определения и сервисы для работы с токенами международных платёжных сиситем
**/

namespace java com.rbkmoney.damsel.payment_system_providers
namespace erlang paysys

include "base.thrift"
include "domain.thrift"
include "msgpack.thrift"

typedef base.ID PaymentTokenID
typedef domain.InvoicePayment InvoicePayment
typedef base.ID SessionID
typedef base.Tag CallbackTag
typedef base.Opaque CallbackPayload
typedef base.Opaque CallbackResponsePayload
typedef base.Opaque PaymentTokenEnrollment

/**
* Поддерживаемые платёжные системы
**/
enum PaymentTokenProvider {
    visa
    mastercard
    nspkmir
}

/**
 * Непрозрачное для процессинга состояние прокси, связанное с определённой сессией взаимодействия
 * с третьей стороной.
 */
typedef base.Opaque ProviderState

/**
* Необходимые для авторизации данные
**/
typedef base.Opaque TokenCredentials

/**
* Указанная карта не может быть токенизирована (по разным причинам)
* Указывает на то, что дальше необходимо попробовать провести платёж
* с карточными данными
**/
struct CardNotTokenizable{}

/**
* Платёжная система не знает про токен
**/
exception TokenNotFound{}

exception SessionNotFound {}

/**
* Другие исключения
**/

struct Failure {
    1: required string reason
    2: optional Failure cause
}

/**
* Ошибки, которые могут возникать при взаимодействии с
* API МПС, которые влияют на принятие решения
**/

union FinishIntentFailure {
    1: CardNotTokenizable card_not_tokenizable
    2: domain.Failure failure
}

struct PaymentSystemProviderResult {
    1: required Intent intent
    2: optional ProviderState next_state
}

struct Callback {
    1: required CallbackTag tag
    2: required CallbackPayload payload
}

struct CallbackResponse {
    1: required CallbackResponsePayload payload
}

union Intent {
    1: FinishIntent finish
    2: SleepIntent sleep
}

struct FinishIntent {
    1: required FinishIntentStatus status
}

union FinishIntentStatus {
    1: FinishIntentSuccess success
    2: FinishIntentFailure failure
}

union FinishIntentSuccess {
    1: TokenizationSuccess tokenization_success
    2: GetTokenCredentialsSuccess credential_success
}

struct TokenizationSuccess {
    1: PaymentTokenID token_id
    2: PaymentTokenEnrollment token_enrollment
}

struct GetTokenCredentialsSuccess {
    1: required TokenCredentials token_credentials
}

/**
 * Требование прервать на определённое время сессию взаимодействия, с намерением продолжить
 * её потом.
 */
struct SleepIntent {
    /** Таймер, определяющий когда следует продолжить взаимодействие. */
    1: required base.Timer timer

    /**
     * Идентификатор, по которому обработчик обратного запроса сможет идентифицировать сессию
     * взаимодействия с третьей стороной, чтобы продолжить по ней взаимодействие.
     * Единожды указанный, продолжает действовать до успешной обработки обратного
     * запроса или завершения сессии.
     * Должен быть уникальным среди всех сессий такого типа.
     * Один и тот же идентификатор можно устанавливать для одной и той же сессии до тех пор, пока
     * обратный вызов с таким идентификатором не будет успешно обработан. Попытка установить уже
     * обработанный идентификатор приведет к ошибке.
     */
    2: optional CallbackTag callback_tag
}

/**
* Сессия, в рамках которой производится взаимодействие с адаптером
**/
struct Session {
    1: required SessionID id
    2: optional ProviderState state
}

struct Context {
    1: required Session session
    2: optional domain.ProxyOptions options = {}
}

/**
 * Результат обработки провайдером обратного вызова в рамках сессии.
 */
struct CallbackResult {
    1: required Intent intent
    2: optional ProviderState next_state
    3: required CallbackResponse response
}

union ProcessCallbackResult {
    /** Вызов был обработан в рамках сесии */
    1: ProcessCallbackSucceeded succeeded

    /** Сессия уже завершена, вызов обработать не удалось */
    2: ProcessCallbackFinished finished
}

struct ProcessCallbackSucceeded {
    1: required CallbackResponse response
}

struct ProcessCallbackFinished {
    /**
     * Состояние сессии после обработки последнего ответа адаптера.
     */
    1: required Context response
}

/**
* NOTE: Данный сервис должен работать в PCIDSS-зоне
**/
service PaymentSystemAdapter {

    /**
    * Токенизация банковской карты.
    **/
    PaymentSystemProviderResult Tokenize(1: InvoicePayment invoice_payment, 2: Context context)

    /**
    * Получить данные (ключи, криптограммы) для авторизации платежа
    **/
    PaymentSystemProviderResult GetTokenCredentials(1: PaymentTokenID token_id, 2: Context context)
        throws (
            1: TokenNotFound not_found
        )

    /**
     * Запрос к провайдеру на обработку обратного вызова в рамках сессии.
     */
    CallbackResult HandleCallback (1: Callback callback, 2: Context context)

}

service PaymentSystemAdapterHost {
    /**
     * Запрос к процессингу на обработку обратного вызова от провайдера.
     * Обработка этого метода процессингом зависит от состояния сессии:
     *  - будет вызван PaymentSystemAdapter.HandleCallback с контекстом сессии, если сессия еще активна,
     *    и вызов с таким идентификатором не обрабатывался; или
     *  - будет возвращен прошлый ответ, если вызов с таким идентификатором уже обрабатывался
     *    вне зависимости от того завершена сессия или нет; или
     *  - будет возвращен ответ, что сессия уже завершена, если сессия завершена, и вызов с таким
     *    идентификатором не был обработан успешно.
     */
    ProcessCallbackResult ProcessCallback (1: Callback callback)
        throws (
            1: SessionNotFound not_found
        )

}