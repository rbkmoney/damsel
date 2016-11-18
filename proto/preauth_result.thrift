include "base.thrift"

namespace java com.rbkmoney.damsel.preauth_result
namespace erlang preauth_result

union Status {
    1: optional Granted granted
    2: optional Denied denied
    3: optional Unavailable unavailable
}

struct Granted {}
struct Denied {}
struct Unavailable {}

union Params{
    1: Params3DSecure params_3dsecure
}

struct Params3DSecure {
    1: optional byte eci
    2: optional string cavv
    3: optional byte cavv_algo
    4: optional string xid
}
