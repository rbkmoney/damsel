include "base.thrift"

/**
 * Шаблон URI согласно [RFC6570](https://tools.ietf.org/html/rfc6570).
 */
typedef string URITemplate

/**
 * Набор заголовков HTTP-запроса, каждый из которых может быть шаблонизирован.
 * Набор переменных указан ниже.
 */
typedef map<string, URITemplate> HTTPHeaders

/**
 * Тело HTTP-запроса, определяющее набор данных и тип содержимого.
 */
union HTTPRequestBody {
    /** Данные формы в виде шаблона URI, набор переменных указан ниже. */
    1: URITemplate form
    2: base.Content arbitrary
}

struct HTTPRequest {
    /** Шаблон URI запроса, набор переменных указан ниже. */
    1: required URITemplate uri
    2: required HTTPHeaders headers = []
    3: optional HTTPRequestBody body
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
    1: HTTPRequest redirect
}
