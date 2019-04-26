/*
 * Definitions of trivial services serving test purposes only.
 */

include "base.thrift"

namespace java com.rbkmoney.damsel.test

struct Shout {
    1: required string contents
}

exception Failure {
    1: required string reason
}

service Echo {
    Shout echo (1: Shout shout) throws (1: Failure ex)
}
