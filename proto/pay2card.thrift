include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.pay2card
namespace erlang pay2card


struct Cash {
    1: required domain.Amount amount
    2: required domain.Currency currency
}

enum Provider {
    ALFABANK
    BINBANK
}

exception ProviderFailure {
    1: required Provider provider
    2: required string code
    3: optional string description
}

struct TransferResult {
    1: required Provider provider
    2: required string transaction_id
    3: optional Cash fee
}

service Pay2Card {
    Cash getFee (1: domain.Token card_token, 2: Cash cash) throws (1: ProviderFailure ex1)

    /** requestId - должен состоять только из цифр */
    TransferResult makeTransfer (1: string request_id, 2: domain.Token card_token, 3: Cash cash) throws (1: ProviderFailure ex1, 2:  base.InvalidRequest ex2)
}
