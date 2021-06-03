include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.payment_tool_token
namespace erlang ptt

/**
    Платежный токен, который передается плательщику. Платежный токен содержит
    чувствительные данные, которые сериализуются в thrift-binary и шифруются перед отправкой клиенту.
    Платежный токен может иметь срок действия, по истечении которого становится недействительным.
    Токен может быть привязан к определённой сущности, что делает его неприменимым для оплаты в остальных
    случаях.
*/
struct PaymentToolToken {
    1: required PaymentToolTokenPayload payload
    2: optional base.Timestamp valid_until
    3: optional PaymentToolTokenLink token_link
}

/**
    Возможные привязки токена.
 */
union PaymentToolTokenLink {
    /** Можно оплатить только указанный счёт  */
    1: optional domain.InvoiceID invoice_id
    /** Может оплачивать только указаный плательщик */
    2: optional domain.CustomerID customer_id
}

/**
    Данные платежного токена
*/
union PaymentToolTokenPayload {
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
    2: optional domain.CryptoCurrencyRef crypto_currency
    // Deprecated
    1: optional domain.LegacyCryptoCurrency crypto_currency_deprecated
}

struct MobileCommercePayload {
    1: required domain.MobileCommerce mobile_commerce
}
