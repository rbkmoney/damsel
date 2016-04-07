/*
 * Definitions of trivial services serving test purposes only.
 */

include "base.thrift"

namespace * dmsl

struct Shout {
    1: required string contents;
}

service Echo {
    Shout echo (1: Shout shout) throws (1: base.Failure ex)
}
