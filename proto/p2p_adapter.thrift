include "base.thrift"
include "domain.thrift"
include "user_interaction.thrift"

namespace java com.rbkmoney.damsel.p2p_adapter
namespace erlang p2p_adapter

/**
 * Непрозрачное для процессинга состояние адаптера, связанное с определённой сессией взаимодействия
 * с третьей стороной.
 */
typedef base.Opaque ProxyState

/**
 * Запрос/ответ адаптера при обработке обратного вызова в рамках сессии.
 */
typedef base.Opaque CallbackPayload
typedef base.Opaque CallbackResponsePayload

typedef base.Tag CallbackTag

/**
 * Требование адаптера к процессингу, отражающее дальнейший прогресс сессии взаимодействия
 * с третьей стороной.
 */
union Intent {
    1: FinishIntent finish
    2: SleepIntent sleep
}

/**
 * Требование завершить сессию взаимодействия с третьей стороной.
 */
struct FinishIntent {
    /** Статус, с которым завершилось взаиможействие */
    1: required FinishStatus status

    /**
     * Ответ, который следует возвращать на требования обработать обратный запрос.
     * Указанный ответ будет возвращен при вызове P2PAdapterHost.ProcessCallback
     * с любым CallbackTag из этой сессии, если тот не был обработан до завершения сессии.
     */
    2: optional CallbackResponse callbacks_response
}

/**
 * Статус, c которым завершилась сессия взаимодействия с третьей стороной.
 */
union FinishStatus {
    /** Успешное завершение взаимодействия. */
    1: Success success
    /** Неуспешное завершение взаимодействия с пояснением возникшей проблемы. */
    2: domain.Failure failure
}

struct Success {}

/**
 * Требование прервать на определённое время сессию взаимодействия, с намерением продолжить
 * её потом.
 */
struct SleepIntent {
    /** Таймер, определяющий когда следует продолжить взаимодействие. */
    1: required base.Timer timer

    /**
     * Взаимодействие с пользователем, в случае если таковое необходимо для продолжения прогресса
     * в рамках сессии взаимодействия.
     */
    2: optional user_interaction.UserInteraction user_interaction

    /**
     * Идентификатор, по которому обработчик обратного запроса сможет идентифицировать сессию
     * взаимодействия с третьей стороной, чтобы продолжить по ней взаимодействие.
     * Единожды указанный, продолжает действовать до успешной обработки обратного
     * запроса или завершения сесиии.
     * Должен быть уникальным среди всех сессий такого типа.
     * Один и тот же идентификатор можно устанавливать для одной и той же сессии до тех пор, пока
     * обратный вызов с таким идетификатором не будет успешно обработан. Попытка установить уже
     * обработанный идентификатор приведет к ошибке.
     */
    3: required CallbackTag callback_tag

}

struct Cash {
    1: required domain.Amount   amount
    2: required domain.Currency currency
}

/** Граф финансовых потоков. */
struct CashFlow {
    1: required list<CashFlowPosting> postings
}

/** Денежный поток между двумя участниками. */
struct CashFlowPosting {
    1: required domain.CashFlowAccount source
    2: required domain.CashFlowAccount destination
    3: required Cash volume
}

/**
 * Данные операции, необходимые для обращения к провайдеру.
 */
union OperationInfo {
    1: ProcessOperationInfo process
}

struct ProcessOperationInfo {
    /**
     * Сумма операции.
     * Может не соответсвовать ни сумме списываемой с любого из участников участника, ни сумме,
     * начисляемой любому из участников операции.
     * Сумма является просто атрибутом операции, от которой могут вычисляться прочие величины.
     */
    1: required Cash body

    /**
     * Граф финансовых потоков.
     * Описывает представления процессинга о том, как должны перемещаться деньги между участниками.
     * Это поле может быть использовано, если провайдеру необходимо передавать суммы с учетом комиссий,
     * сумму и комиссию по-отдельности и т.п.
     */
    2: required CashFlow cash_flow

    /** Платежный инструмент, с которого будут списываться деньги. */
    3: required PaymentResource sender

    /** Платежный инструмент, куда будут пересылаться деньги. */
    4: required PaymentResource receiver
}

union PaymentResource {
    1: domain.DisposablePaymentResource disposable
}

/**
 * Данные сессии взаимодействия с адаптером.
 */
struct Session {
    1: optional ProxyState state
}

/**
 * Набор данных для взаимодействия с адаптером в рамках операции.
 */
struct Context {
    1: required Session             session
    2: required OperationInfo       operation
    3: optional domain.ProxyOptions options = {}
}

/**
 * Результат обращения к адаптеру в рамках сессии.
 *
 * В результате обращения прокси может решить, следует ли:
 *  - завершить сессию взаимодействия с провайдером (FinishIntent); или
 *  - просто приостановить на определённое время (SleepIntent), обновив своё состояние, которое
 *    вернётся к нему в последующем запросе
 *
 * Адаптер может связать с текущим платежом данные транзакции у провайдера для учёта в нашей системе,
 * причём на эти данные налагаются следующие требования:
 *  - идентификатор связанной транзакции _не может измениться_ при последующих обращениях в адаптер
 *    по текущему платежу.
 */
struct ProcessResult {
    1: required Intent                 intent
    2: optional ProxyState             next_state
    3: optional domain.TransactionInfo trx
}

struct Callback {
    1: required CallbackTag tag
    2: required CallbackPayload payload
}

struct CallbackResponse {
    1: required CallbackResponsePayload payload
}

/**
 * Результат обработки адаптером обратного вызова в рамках сессии.
 */
struct CallbackResult {
    1: required Intent                 intent
    2: optional ProxyState             next_state
    3: optional domain.TransactionInfo trx
    4: required CallbackResponse       response
}

service P2PAdapter {
    /**
     * Запрос к адаптеру на проведение взаимодействия с провайдером в рамках сессии.
     */
    ProcessResult Process (1: Context context)

    /**
     * Запрос к адапетру на обработку обратного вызова от провайдера в рамках сессии.
     */
    CallbackResult HandleCallback (1: Callback callback, 2: Context context)
}

exception CallbackNotFound {}

union ProcessCallbackResult {
    /** Вызов был обработан в рамках сесии */
    1: CallbackResponse response

    /** Сессия уже завершена, вызов обработать не удалось */
    2: FinishedCallback finished
}

struct FinishedCallback {
    /** Ответ, указанный при завершении сессии в FinishIntent */
    1: optional CallbackResponse response
}

service P2PAdapterHost {

    /**
     * Запрос к процессингу на обработку обратного вызова от провайдера.
     * Обработка этого метода процессингом зависит от состояния сессии:
     *  - будет вызван P2PAdapter.HandleCallback с контекстом сессии, если сессия еще активна,
     *    и вызов с таким идентификатором не обрабатывался; или
     *  - будет возвращен прошлый ответ, если вызов с таким идентификатором уже обрабатывался
     *    вне зависимости от того завершена сессия или нет; или
     *  - будет возвращен ответ, что сессия уже завершена, если сессия завершена, и вызов с таким
     *    идентификатором не был обработан успешно.
     */
    CallbackResponse ProcessCallback (1: Callback callback)
        throws (
            1: CallbackNotFound ex1
        )

}
