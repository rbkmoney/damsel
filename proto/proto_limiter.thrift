include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.proto_limiter
namespace erlang proto_limiter

/**
* Протокол разрабатывался в рамках https://rbkmoney.atlassian.net/browse/MSPF-626
* как временное решение для закрытия задачи https://rbkmoney.atlassian.net/browse/MSPF-623
* Описание сущностей лимитов является частью микросервиса proto-limiter
*/

typedef base.ID LimitChangeID
typedef domain.TurnoverLimitID LimitID

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
   4: required base.Timestamp operation_timestamp
}

exception LimitNotFound {}
exception LimitChangeNotFound {}
exception RateCurrencyNotFound {
    1: required domain.CurrencySymbolicCode limit_currency
    2: required domain.CurrencySymbolicCode rate_currency
}
exception RateQuoteNotFound {}
exception ForbiddenOperationAmount {
    1: required domain.Cash amount
    2: required domain.CashRange allowed_range
}

service Limiter {
    Limit Get(1: LimitID id, 2: base.Timestamp timestamp) throws (
        1: LimitNotFound e1,
        2: base.InvalidRequest e3
    )
    void Hold(1: LimitChange change) throws (
        1: LimitNotFound e1,
        2: RateCurrencyNotFound e2,
        3: base.InvalidRequest e3,
        4: RateQuoteNotFound e4
    )
    void Commit(1: LimitChange change) throws (
        1: LimitNotFound e1,
        2: LimitChangeNotFound e2,
        3: base.InvalidRequest e3
    )
    void PartialCommit(1: LimitChange change) throws (
        1: LimitNotFound e1,
        2: LimitChangeNotFound e2,
        3: ForbiddenOperationAmount e3,
        4: base.InvalidRequest e4
        5: RateCurrencyNotFound e5,
        6: RateQuoteNotFound e6
    )
    void Rollback(1: LimitChange change) throws (
        1: LimitNotFound e1,
        2: LimitChangeNotFound e2,
        3: base.InvalidRequest e3
    )
}
