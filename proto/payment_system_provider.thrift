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
typedef base.ID ApiCallID
typedef base.ID PaymentAccountReference
typedef domain.InvoicePayment InvoicePayment

/**
* Поддерживаемые платёжные системы
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
* Необходимые для авторизации данные
* NOTE: TokenCredentials не должен покидать PCIDSS зону
**/
typedef base.Opaque TokenCredentials

/**
* Указанная карта не может быть токенизирована (по разным причинам)
* Указывает на то, что дальше необходимо попробовать провести платёж
* с карточными данными
**/
exception CardNotTokenizable{}

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

struct PaymentSystemProxyResult {
    1: required PaymentSystemTokenIntent intent
    2: optional ProxyState next_state
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

service PaymentSystemProxy {

    /**
    * Токенизация банковской карты.
    **/
    PaymentSystemProxyResult Tokenize(1: InvoicePayment invoice_payment)

    /**
    * Получить данные (ключи, криптограммы) для авторизации платежа
    **/
    PaymentSystemProxyResult GetTokenCredentials(1: PaymentTokenID token_id)
        throws (
            1: TokenNotFound not_found
        )
}
