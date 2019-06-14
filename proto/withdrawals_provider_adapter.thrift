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
}

typedef withdrawals_domain.Destination Destination
typedef withdrawals_domain.Identity    Identity

struct Cash {
    1: required domain.Amount   amount
    2: required domain.Currency currency
}

struct CryptoCash {
    1: required domain.Amount   amount
    2: required domain.CryptoCurrency currency
}


/**
 * Данные вывода, необходимые для обращения к провайдеру.
 */
struct HoldWithdrawal {
    1: optional base.ID id
    2: required Cash cash
    3: required CryptoCash exchange_cash
}

/**
 * Данные вывода, необходимые для обращения к провайдеру.
 */
struct CaptureWithdrawal {
    1: required base.ID id
    2: required base.ID order_id
    3: required Destination destination
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

/**
 * Результат холдирования.
 *
 * В результате обращения адаптер получаем идентификатор обязательства,
 * сумму в оригинальной и сконвертированной валюте, время создания и действия обязательства.
 */
struct HoldResult {
    1: optional base.ID         id
    2: required base.ID         order_id
    3: required HoldStatus      status
    4: required CryptoCash      exchanged_cash
    5: required Cash            cash
    7: required base.Timestamp  create_at
    8: required base.Timestamp  expires_on
}

union HoldStatus {
    1: HoldNew hold_new
    2: HoldCompleted hold_completed
    3: HoldExpired hold_expired
}

struct HoldNew {}
struct HoldCompleted {}
struct HoldExpired {}

/**
 * Вариант с таблицей курсов.
 */

struct HoldTable {
    1: required list<HoldLine> lines
}

struct HoldLine {
    1: required domain.CashRange range
    2: required list<CryptoCash> exchange_rates
    3: required list<base.ID> order_ids
    4: required base.Timestamp  create_at
    5: required base.Timestamp  expires_on
}

struct HoldResultTable {
    1: optional base.ID         id
    2: required HoldStatus      status
    3: required HoldTable       data
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
     * Запрос к адаптеру на холдирование суммы выплаты.
     */
    HoldResult holdWithdrawal (
        1: HoldWithdrawal hold
        2: InternalState state
        3: Options opts
    )
    throws (
    )

    /**
     * Запрос к адаптеру c подтверждением проведения выплаты по ранее полученному обязательству.
     */
    ProcessResult captureWithdrawal (
        1: CaptureWithdrawal capture
        2: InternalState state
        3: Options opts
    )
    throws (
    )
}
