namespace erlang tmbhv
namespace java com.rbkmoney.damsel.timeout_behaviour
include "base.thrift"
include "domain.thrift"

typedef base.Opaque Callback

union TimeoutBehaviour {
    1: domain.OperationTimeout operation_timeout
    /** Неуспешное завершение взаимодействия с пояснением возникшей проблемы. */
    2: domain.Failure failure
    /** Вызов прокси для обработки события истечения таймаута. */
    3: Callback callback
}
