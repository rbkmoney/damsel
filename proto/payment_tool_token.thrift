include "domain.thrift"

namespace java com.rbkmoney.damsel.payment_tool_token
namespace erlang ptt

/*
    Платежный токен, который передается плательщику. Платежный токен содержит
    чувствительные данные, которые сериализуются в thrift-binary и шифруются перед отправкой клиенту.
*/

union PaymentToolToken {
    1: BankCardPayload bank_card_payload
}

struct BankCardPayload {
    1: required domain.BankCard bank_card
}
