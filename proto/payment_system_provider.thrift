/**
Определения и сервисы для работы с токенами международных платёжных сиситем
**/

namespace java com.rbkmoney.damsel.payment_system_providers
namespace erlang paysys

include "base.thrift"
include "domain.thrift"
include "msgpack.thrift"
include "timeout_behaviour.thrift"

typedef base.ID PaymentTokenID
typedef base.ID EnrollmentID
typedef base.ID ApiCallID
typedef base.ID PaymentAccountReference
typedef domain.InvoicePayment InvoicePayment

/**
* 
**/
enum PaymentTokenProvider {
    visa,
    mastercard,
    nspkmir
}

/**
 * Непрозрачное для процессинга состояние прокси, связанное с определённой сессией взаимодействия
 * с третьей стороной.
 */
typedef base.Opaque ProxyState

/**
 * Запрос/ответ прокси при обработке обратного вызова в рамках сессии.
 */
typedef base.Opaque Callback
typedef base.Opaque CallbackResponse

struct PaymentToken {
    1: required PaymentTokenID token_id
    2: required EnrollmentID enrollment_id
    3: required PaymentTokenProvider provider
    4: required base.Timestamp created_at
    5: optional string last4
    6: optional TokenExpDate exp_date
    7: optional PaymentAccountReference pan_account_reference
}

/**
* Данные, возвращаемые в случае успеха
**/

/** Дата экспирации токена */
struct TokenExpDate {
    /** Месяц 1..12 */
    1: required i8 month
    /** Год 2015..∞ */
    2: required i16 year
}

/**
* Указанная карта не может быть токенизирована (по разным причинам)
* Указывает на то, что дальше необходимо попробовать провести платёж
* с карточными данными
**/
struct CardNotTokenizable{}

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

/**
*
**/
struct PaymentSystemProxyResult {
    1: required PaymentSystemTokenIntent intent
    2: optional ProxyState next_state
}

union PaymentSystemTokenIntent {
    1: FinishIntent finish
    2: SleepIntent sleep
    3: SuspendIntent suspend
}

struct FinishIntent {
    1: required FinishIntentStatus status
}

union FinishIntentStatus {
    1: FinishIntentSuccess success
    2: FinishIntentFailure failure
}

struct FinishIntentSuccess {
    1: required PaymentToken token
}

/**
 * Требование прервать на определённое время сессию взаимодействия, с намерением продолжить
 * её потом.
 */
struct SleepIntent {
    /** Таймер, определяющий когда следует продолжить взаимодействие. */
    1: required base.Timer timer
}

typedef base.Tag CallbackTag

/**
 * Требование приостановить сессию взаимодействия, с продолжением по факту прихода обратного
 * запроса (callback), либо выполняет один из указаных вариантов timeout_behaviour.
 * Если не указан timeout_behaviour, сессия завершается с неуспешным завершением
 * по факту истечения заданного времени ожидания.
 */
struct SuspendIntent {
    /**
     * Ассоциация, по которой обработчик обратного запроса сможет идентифицировать сессию
     * взаимодействия с третьей стороной, чтобы продолжить по ней взаимодействие.
     */
    1: required CallbackTag tag

    /**
     * Таймер, определяющий время, в течение которого процессинг ожидает обратный запрос.
     */
    2: required base.Timer timeout

    /**
    * Поведение процессинга в случае истечения заданного timeout
    */
    3: optional timeout_behaviour.TimeoutBehaviour timeout_behaviour
}

/**
* Отвечает за взаимодействие с МПС со стороны платформы
**/

service PaymentSystemProxy {

    /**
    * Токенизация банковской карты.
    **/

    PaymentSystemProxyResult Tokenize(1: InvoicePayment invoice_payment)

    PaymentSystemProxyResult GetToken(1: PaymentTokenID token_id)

    PaymentSystemProxyResult GetTokenMeta(1: PaymentTokenID token_id)

    PaymentSystemProxyResult DeleteToken(1: PaymentTokenID token_id)

}

/**
* Отвечает за взаимодействие с сервисом хранения метаданных
**/
service MetadataStorage {

}

/**
* События, поступающие от МПС
**/
union PaymentSystemEvent {
    1: TokenUpdated token_updated
    2: TokenSuspended token_suspended
    3: TokenUnsuspended token_unsuspended
    4: TokenDeleted token_deleted
    5: TokenMetadataUpdated token_metadata_updated
}

struct TokenUpdated {
    1: required PaymentTokenID token
    2: required PaymentTokenProvider provider
}

struct TokenSuspended {
    1: required PaymentTokenID token
    2: required PaymentTokenProvider provider
}

struct TokenUnsuspended {
    1: required PaymentTokenID token
    2: required PaymentTokenProvider provider
}

struct TokenDeleted {
    1: required PaymentTokenID token
    2: required PaymentTokenProvider provider
}

struct TokenMetadataUpdated {
    1: required PaymentTokenID token
    2: required PaymentTokenProvider provider
}

/**
* Отвечает за обработку поступающих событий
**/
service EventHandler {
    void handle_event(1: PaymentSystemEvent event)
}

