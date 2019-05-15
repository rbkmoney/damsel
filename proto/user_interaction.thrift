namespace java com.rbkmoney.damsel.user_interaction
include "base.thrift"
include "domain.thrift"

/**
 * Строковый шаблон согласно [RFC6570](https://tools.ietf.org/html/rfc6570) Level 4.
 */
typedef string Template

/**
 * Форма, представленная набором полей и их значений в виде строковых шаблонов.
 */
typedef map<string, Template> Form

typedef base.ID WalletID
typedef base.Rational Rational
typedef domain.Amount Amount
typedef domain.CoinName CoinName
typedef domain.CurrencySymbolicCode CurrencySymbolicCode
typedef string OrderID
/**
 * Запрос HTTP, пригодный для отправки средствами браузера.
 */
union BrowserHTTPRequest {
    1: BrowserGetRequest get_request
    2: BrowserPostRequest post_request
}

struct BrowserGetRequest {
    /** Шаблон URI запроса, набор переменных указан ниже. */
    1: required Template uri
}

struct BrowserPostRequest {
    /** Шаблон URI запроса, набор переменных указан ниже. */
    1: required Template uri
    2: required Form form
}

// Платеж через терминал
struct PaymentTerminalReceipt  {
    // Сокращенный идентификатор платежа и инвойса (spid)
    1: required string short_payment_id;

    // Дата истечения срока платежа
    // после этой даты платеж будет отклонен
    2: required base.Timestamp due
}

struct CryptoCurrencyInvoiceResult {
    1: required WalletID wallet_id
    2: required Rational crypto_currency_amount
    3: required CoinName coin_name
    4: required Amount amount
    5: required CurrencySymbolicCode currency_symbolic_code
    7: optional OrderID order_id
    8: optional string note
}

union UserInteraction {
    /**
     * Требование переадресовать user agent пользователя, в виде HTTP-запроса.
     *
     * В шаблонах в структуре HTTP-запроса могут встретиться следующие переменные:
     *  - `termination_uri`
     *    URI, на который следует переадресовать user agent пользователя по завершении
     *    взаимодействия.
     */
    1: BrowserHTTPRequest redirect

    /**
    * Информация о платежной квитанции, которую нужно оплатить вне нашей системы
    **/
    2: PaymentTerminalReceipt payment_terminal_reciept

    3: CryptoCurrencyInvoiceResult crypto_currency_invoice_result
}
