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
    1: required PaymentSystemTokenIntent intent
    2: optional ProviderState next_state
}

union PaymentSystemTokenIntent {
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
    1: PaymentTokenID token_id
    2: TokenCredentials credentials
}

/**
 * Требование прервать на определённое время сессию взаимодействия, с намерением продолжить
 * её потом.
 */
struct SleepIntent {
    /** Таймер, определяющий когда следует продолжить взаимодействие. */
    1: required base.Timer timer
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
}
