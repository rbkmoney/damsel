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

union Destination {
    1: domain.BankCard bank_card
    2: domain.CryptoWallet crypto_wallet
}

struct Identity {
    1: required base.ID id
    2: optional list<IdentityDocument> documents
    3: optional list<ContactDetail> contact
}

union IdentityDocument {
    1: RUSDomesticPassport rus_domestic_passport
}

struct RUSDomesticPassport {
    1: required string token
    2: optional string fullname_masked
}

union ContactDetail {
    1: string email
    2: string phone_number
}
