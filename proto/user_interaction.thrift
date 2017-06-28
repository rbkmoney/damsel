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
struct PayRecipet {
    // Идентификатор платежа и инвойса
    1: required string payment_identifer

    // Сумма
    2: required i64 amount

    // Назначение перевода*: Пополнение Интернет-счета RBK Money, л/с 1132815383, без НДС
    3: optional string recieptPurpose;

    // Получатель: НКО “ЭПС” (ООО)
    4: optional string recipient;

    // ИНН: 7750005700
    5: optional string inn;

    // КПП: 772801001
    6: optional string kpp;

    // Банк получателя: НКО “ЭПС” (ООО), г. Москва
    7: optional string recipient_bank;

    // Расчетный счет Р/с: 47416810101020000000
    8: optional string checking_account;

    // Корр.счет: 30103810445250000313
    9: optional string correspondent_account;

    // БИК:	044525313 в отделении 1 Москва
    10: optional string bik;
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
    * Информация о платежной квитанции, которую нужно оплатить в не нашей системы
    **/
    2: PayRecipet pay
}
