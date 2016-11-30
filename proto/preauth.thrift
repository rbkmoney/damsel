include "base.thrift"

namespace java com.rbkmoney.damsel.preauth
namespace erlang preauth

union Status {
    1: Granted granted
    2: Denied denied
    3: Unavailable unavailable
}

struct Granted {
    1: required State state
}

struct Denied {
    1: required State state
}

struct Unavailable {
    1: required State state
}

union State {
    1: State3DSecure state_3dsecure
}

struct State3DSecure {
    1: optional i8 eci
    2: optional string cavv
    3: optional i8 cavv_algo
    4: optional string xid
}
