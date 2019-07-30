include "base.thrift"
include "msgpack.thrift"
include "domain.thrift"
include "withdrawals_domain.thrift"

namespace java com.rbkmoney.damsel.withdrawals.provider_adapter
namespace erlang wthadpt

typedef domain.Failure Failure

/**
 * Adapter options.
 */
typedef domain.ProxyOptions Options

/**
 * Непрозрачное для процессинга состояние адаптера, связанное с определённой сессией взаимодействия с
 * третьей стороной.
 */
typedef msgpack.Value InternalState

/**
 * Непрозрачные для процессинга данные котировки, связанные с особенностями взаимодействия с
 * третьей стороной.
 */
typedef msgpack.Value QuoteData

/**
 * Требование адаптера к процессингу, отражающее дальнейший прогресс сессии взаимодействия с третьей
 * стороной.
 */
union Intent {
    1: FinishIntent finish
    2: SleepIntent sleep
}

/**
 * Требование завершить сессию взаимодействия с третьей стороной.
 */
struct FinishIntent {
    1: required FinishStatus status
}

/**
 * Статус, c которым завершилась сессия взаимодействия с третьей стороной.
 */
union FinishStatus {
    /** Успешное завершение взаимодействия. */
    1: Success success
    /** Неуспешное завершение взаимодействия с пояснением возникшей проблемы. */
    2: Failure failure
}

struct Success {
    1: required domain.TransactionInfo trx_info
}

/**
 * Требование прервать на определённое время сессию взаимодействия, с намерением продолжить её потом.
 */
struct SleepIntent {
    /** Таймер, определяющий когда следует продолжить взаимодействие. */
    1: required base.Timer timer
}

///

/**
 * Данные вывода, необходимые для обращения к провайдеру.
 */
struct Withdrawal {
    1: required base.ID id
    2: required Cash body
    3: required Destination destination
    4: optional Identity sender
    5: optional Identity receiver
    6: optional Quote quote
}

typedef withdrawals_domain.Destination Destination
typedef withdrawals_domain.Identity    Identity

struct Cash {
    1: required domain.Amount   amount
    2: required domain.Currency currency
}

/**
 * Данные для получения котировки на заданную сумму по выбранным валютам.
 */
struct GetQuoteParams {
    1: optional base.ID idempotency_id
    2: required domain.Currency currency_from
    3: required domain.Currency currency_to
    /**
     * Сумма в одной из валют обмена
     */
    4: required Cash exchange_cash
}

union QuoteFailure {
    1: LimitExceededFailure limit_exceeded
}

union LimitExceededFailure {
    1: GeneralFailure value_above_max_limit
    2: GeneralFailure value_under_min_limit
}

struct GeneralFailure {}

exception GetQuoteFailure {
    1: required QuoteFailure failure
}

///

/**
 * Результат обращения к адаптеру в рамках сессии.
 *
 * В результате обращения адаптер может решить, следует ли:
 *  - завершить сессию взаимодействия с провайдером (FinishIntent); или
 *  - просто приостановить на определённое время (SleepIntent), обновив своё состояние, которое
 *    вернётся к нему в последующем запросе.
 */
struct ProcessResult {
    1: required Intent                 intent
    2: optional InternalState          next_state
}

struct Quote {
    1: required Cash                cash_from
    2: required Cash                cash_to
    3: required base.Timestamp      created_at
    4: required base.Timestamp      expires_on
    5: required QuoteData           quote_data
}

service Adapter {

    /**
     * Запрос к адаптеру на проведение взаимодействия с провайдером в рамках платежной сессии.
     */
    ProcessResult ProcessWithdrawal (
        1: Withdrawal withdrawal
        2: InternalState state
        3: Options opts
    )
    throws (
    )

    /**
     * Запрос к адаптеру на получение котировки.
     */
    Quote GetQuote (
        1: GetQuoteParams params
        2: Options opts
    )
    throws (
        1: GetQuoteFailure ex1
    )
}
