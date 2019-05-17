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
typedef string CryptoAddress
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

struct CryptoCurrencyTransferRequest {
    1: required CryptoAddress crypto_address
    2: required domain.CryptoCash crypto_cash
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

    3: CryptoCurrencyTransferRequest crypto_currency_transfer_request
}
