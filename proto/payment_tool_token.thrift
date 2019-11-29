include "domain.thrift"

namespace java com.rbkmoney.damsel.payment_tool_token
namespace erlang ptt

/*
    Платежный токен, который передается плательщику. Платежный токен содержит
    чувствительные данные, которые сериализуются в thrift-binary и шифруются перед отправкой клиенту.
*/

union PaymentToolToken {
    1: BankCardPayload bank_card_payload
    2: PaymentTerminalPayload payment_terminal_payload
    3: DigitalWalletPayload digital_wallet_payload
    4: CryptoCurrencyPayload crypto_currency_payload
    5: MobileCommercePayload mobile_commerce_payload
}

struct BankCardPayload {
    1: required domain.BankCard bank_card
}

struct PaymentTerminalPayload {
    1: required domain.PaymentTerminal payment_terminal
}

struct DigitalWalletPayload {
    1: required domain.DigitalWallet digital_wallet
}

struct CryptoCurrencyPayload {
    1: required domain.CryptoCurrency crypto_currency
}

struct MobileCommercePayload {
    1: required domain.MobileCommerce mobile_commerce
}
