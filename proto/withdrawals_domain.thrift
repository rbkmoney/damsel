include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.withdrawals.domain
namespace erlang wthdm

/// Domain

struct Withdrawal {
    1: required domain.Cash body
    // Source ?
    2: required Destination destination
    3: optional Identity sender
    4: optional Identity receiver
}

struct Destination {
    1: required base.ID id
    // TODO
}

struct Identity {
    1: required base.ID id
    2: required list<IdentityDocument> documents
    3: required list<ContactDetail> contact
}

union IdentityDocument {
    1: RUSDomesticPassport rus_domestic_passport
}

struct RUSDomesticPassport {
    1: required string token
    2: required string fullname_masked
}

union ContactDetail {
    1: string email
    2: string phone_number
}
