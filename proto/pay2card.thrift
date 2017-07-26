include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.pay2card
namespace erlang pay2card


struct Cash {
    1: required domain.Amount amount
    2: required domain.Currency currency
}

enum Provider {
    alfabank
    binbank
}

exception ProviderFailure {
    1: required Provider provider
    2: required string code
    3: optional string description
}

struct TransferResult {
    1: required Provider provider
    2: required string transaction_id
    3: required string maskCard
    4: optional Cash fee
}

service Pay2Card {
    Cash getFee (1: domain.Token card_token, 2: Cash cash) throws (1: ProviderFailure ex1)

    /** requestId - должен состоять только из цифр */
    /** actor_id - идентификатор инициатора перевода, например MerchantId.ShopId */
    TransferResult makeTransfer (1: string request_id, 2: string actor_id, 3: domain.Token card_token, 4: Cash cash) throws (1: ProviderFailure ex1, 2:  base.InvalidRequest ex2)
}
