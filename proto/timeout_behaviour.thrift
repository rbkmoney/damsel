namespace java com.rbkmoney.damsel.timeout_behaviour
include "base.thrift"

union TimeoutBehaviour {
    /** Неуспешное завершение взаимодействия с пояснением возникшей проблемы. */
    1: domain.Failure failure
    /** Вызов прокси для обработки события истечения таймаута. */
    2: Callback callback
}
