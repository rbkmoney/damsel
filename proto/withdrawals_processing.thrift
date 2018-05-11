include "base.thrift"
include "msgpack.thrift"
include "withdrawals_domain.thrift"

namespace java com.rbkmoney.damsel.withdrawals.processing
namespace erlang wthproc

/// Processing

typedef base.ID WithdrawalID
typedef withdrawals_domain.Withdrawal Withdrawal

struct WithdrawalState {
    1: required WithdrawalID id
    2: required Withdrawal withdrawal
    3: required base.Timestamp created_at
    4: optional base.Timestamp updated_at
    5: required WithdrawalStatus status
    // 99: required context.ContextSet ctx
}

union WithdrawalStatus {
    1: WithdrawalPending pending
}

struct WithdrawalPending {}

// Events

typedef i64 EventID

struct Event {
    1: required EventID id
    2: required WithdrawalID source
    3: required base.Timestamp created_at
    4: required list<Change> changes
}

union Change {
    1: WithdrawalStatus status_changed
}

// Service

exception WithdrawalNotFound {}

service Processing {

    WithdrawalState Start (1: Withdrawal withdrawal) throws (
        // TODO
    )

    WithdrawalState Get (1: WithdrawalID id) throws (
        1: WithdrawalNotFound ex1
        // TODO
    )

}

/// Event sink

typedef list<Event> Events

struct EventRange {
    1: optional EventID after
    2: required i32 limit
}

exception EventNotFound {}
exception NoLastEvent {}

service EventSink {

    Events GetEvents (1: EventRange range)
        throws (1: EventNotFound ex1)

    EventID GetLastEventID ()
        throws (1: NoLastEvent ex1)

}
