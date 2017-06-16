include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.pay2card
namespace erlang pay2card


struct Cash {
    1: required domain.Amount amount
    2: required domain.Currency currency
}

 /** Неуспешное завершение взаимодействия с пояснением возникшей проблемы. */
exception Failure {
    1: required string code
    2: optional string description
}

service Pay2CardService {
    void makePay (1: domain.Token cardToken, 2: Cash cash) throws (1: Failure ex1)
}
