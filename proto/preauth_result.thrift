include "base.thrift"

namespace java com.rbkmoney.damsel.preauth_result
namespace erlang preauth_result

union Status {
    1: optional Grant grant
    2: optional Deny deny
    3: optional Unavailable unavailable
}

struct Grant {}
struct Deny {}
struct Unavailable {}

union Params{
    1: optional Params3DSecure Params_3dsecure
}

struct Params3DSecure {
    1: optional byte ECI
    2: optional string CAVV
    3: optional string XID
    4: optional string PARes
}
