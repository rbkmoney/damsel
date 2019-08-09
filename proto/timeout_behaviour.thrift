namespace erlang tmbhv
namespace java com.rbkmoney.damsel.timeout_behaviour
include "base.thrift"
include "domain.thrift"

typedef base.Opaque Callback

union TimeoutBehaviour {
    1: domain.OperationFailure operation_failure
    /** Вызов прокси для обработки события истечения таймаута. */
    2: Callback callback
}
