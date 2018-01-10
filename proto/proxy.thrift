include "base.thrift"
include "user_interaction.thrift"

namespace java com.rbkmoney.damsel.proxy

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

/**
 * Требование прокси к процессингу, отражающее дальнейший прогресс сессии взаимодействия
 * с третьей стороной.
 */
union Intent {
    1: FinishIntent finish
    2: SleepIntent sleep
    3: SuspendIntent suspend
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

struct Success {}

struct Failure {
    1: required string code
    2: optional string description
}

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
}

typedef base.Tag CallbackTag

/**
 * Требование приостановить сессию взаимодействия, с продолжением по факту прихода обратного
 * запроса (callback), либо с неуспешным завершением по факту истечения заданного времени
 * ожидания.
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
     * Взаимодействие с пользователем, в случае если таковое необходимо для продолжения прогресса
     * в рамках сессии взаимодействия.
     */
    3: optional user_interaction.UserInteraction user_interaction
}
