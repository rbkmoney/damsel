include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.proto_limiter
namespace erlang proto_limiter


typedef base.ID LimitChangeID

union LimitID {
    1: domain.ProviderLimitID provider_limit_id
}

struct Limit {
    1: required LimitID id
    2: required domain.Cash cash
    3: optional base.Timestamp creation_time
    4: optional base.Timestamp reload_time
    5: optional string description
}

struct LimitChange {
   1: required LimitID id
   2: required LimitChangeID change_id
   3: required domain.Cash cash
}

/**
* Результат применение единицы изменения лимита:
* affected_limit - новое состояние лимита
*/
struct ChangeLog {
    1: required Limit affected_limit
}


exception LimitNotFound {}
exception LimitChangeNotFound {}
exception InconsistentLimitCurrency {
    1: required domain.CurrencySymbolicCode limit_currency
    2: required domain.CurrencySymbolicCode change_currency
}

service Limiter {
    ChangeLog Hold(1: LimitChange change) throws (
        1: LimitNotFound e1,
        2: InconsistentLimitCurrency e2,
        3: base.InvalidRequest e3
    )
    ChangeLog Commit(1: LimitChange change) throws (
        1: LimitNotFound e1,
        2: LimitChangeNotFound e2,
        3: base.InvalidRequest e3
    )
    ChangeLog Rollback(1: LimitChange change) throws (
        1: LimitNotFound e1,
        2: LimitChangeNotFound e2,
        3: base.InvalidRequest e3
    )
}
