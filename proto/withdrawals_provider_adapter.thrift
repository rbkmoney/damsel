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
 * Непрозрачные для процессинга данные конвертации валют, связанные с особенностями взаимодействия с
 * третьей стороной.
 */
typedef msgpack.Value RateData

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
    6: optional ExchangeAgree exchange_agree
}

typedef withdrawals_domain.Destination Destination
typedef withdrawals_domain.Identity    Identity

struct Cash {
    1: required domain.Amount   amount
    2: required domain.Currency currency
}

/**
 * Данные для получения курсов конвертации по выбранным валютам.
 */
struct GetExchangeRatesParams {
    1: optional base.ID idempotency_id
    2: required domain.Currency currency_from
    3: required domain.Currency currency_to
    4: required ExchangeCash exchange_cash
}

union ExchangeCash {
    1: Cash cash_from
    2: Cash cash_to
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

struct ExchangeAgree {
    1: required base.ID             idempotency_id
    2: required list<ExchangeRate>  rates
    3: required base.Timestamp      created_at
    4: required base.Timestamp      expires_on
    5: optional RateData            rate_data
}

struct ExchangeRate {
    1: required domain.Currency currency_from
    2: required domain.Currency currency_to
    3: required base.Rational rate
    4: required domain.CashRange cash_range_from
    5: required domain.RoundingMethod rounding_method
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
     * Запрос к адаптеру на получение курсов конвертации.
     */
    ExchangeAgree GetExchangeRates (
        1: GetExchangeRatesParams params
        2: InternalState state
        3: Options opts
    )
    throws (
    )
}
