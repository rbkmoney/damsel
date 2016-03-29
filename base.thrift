/*
 * Base definitions.
 */

namespace * hg

struct Error {
    1: required string code;
    2: optional string description;
}

exception Failure {
    1: required Error error;
}
