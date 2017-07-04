include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.pay2card
namespace erlang pay2card


struct Cash {
    1: required domain.Amount amount
    2: required domain.Currency currency
}

enum Provider {
    ALFA
    BINBANK
}

exception Failure {
    1: required Provider provider
    2: required string code
    3: optional string description
}

struct TransferResult {
    1: required Provider provider
    2: string transactionId
    3: Cash fee
}

service Pay2CardService {
    Cash getFee (1: domain.Token cardToken, 2: Cash cash) throws (1: Failure ex1)

    /** requestId - должен состоять только из цифр */
    TransferResult makeTransfer (1: string requestId 2: domain.Token cardToken, 3: Cash cash) throws (1: Failure ex1)
}
