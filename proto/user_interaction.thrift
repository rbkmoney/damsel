namespace java com.rbkmoney.damsel.user_interaction

/**
 * Строковый шаблон согласно [RFC6570](https://tools.ietf.org/html/rfc6570) Level 4.
 */
typedef string Template

/**
 * Форма, представленная набором полей и их значений в виде строковых шаблонов.
 */
typedef map<string, Template> Form

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

// Платежная квитанция
struct TerminalPayment  {
    // Идентификатор платежа и инвойса
    1: required string payment_identifer

    // Сумма
    2: required i64 amount

    /** Символьный код, уникально идентифицирующий валюту. */
    3: required string currency_code

    // Назначение перевода: Пополнение Интернет-счета RBK Money, л/с 1132815383, без НДС
    4: required string reciept_purpose;

   }

struct RussianWireTransfer {

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
    2: TerminalPayment terminalPayment
}
