include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.dudoser
namespace erlang dudoser

typedef string MessageBody
typedef string Subject
typedef string To
typedef list<list<byte>> Attachments



//Простой идентификатор шаблона
typedef i32 TemplateIDSimple

/**
* Составной идентификатор шаблона письма
* messageType - тип сообщения
* merchantID - идентификатор мерчанта
* shopID - идентификатор магазина
*/
struct TemplateIDComplex {
    1: string messageType
    2: i32 merchantID
    3: domain.ShopID shopID
}

/**
* Юнион из двух видов идентификаторов
**/
union TemplateID {
    1: TemplateIDComplex templateIDForShop
    2: TemplateIDSimple templateID
}

typedef string TemplateBody

/**
* Ошибки, возникающие при отправке письма.
* Например, недоступен почтовый сервер
**/
exception NotSend {
}

/**
* Ошибка, если по указанным идентификаторам не найден шаблон
**/
exception TemplateNotFound {
}

/**
* Ошибка, если пытаются отправить слишком длинное письмо или шаблон
**/
exception DataTooBig {
    1: i32 limit;
}

service DudoserService {
    /**
    * Отправка готового письма.
    * Параметры - тело, тема письма, адрес, вложения
    **/
    bool send(1:MessageBody message,
                    2:Subject subject,
                    3:To to,
                    4:Attachments attachments) throws (1: base.InvalidRequest ex1, 2:NotSend ex2, 3:DataTooBig ex3)

    /**
    * Отправка письма по шаблону.
    * Параметры - данные для подставновки в шаблон, идентификатор шаблона, адрес, вложения
    **/
    void sendByTemplate(1:base.StringMap parameters,
                        2:TemplateID templateId,
                        3:To to,
                        4:Attachments attachments) throws (1: base.InvalidRequest ex1, 2:NotSend ex2, 3:DataTooBig ex3, 4:TemplateNotFound ex4)

    /**
    * Добавление шаблона без привязки к магазину.
    * Параметры - тело шаблона (возможно параметризованное), вложения
    * Результат - возвращается числовой идентификатор шаблона
    **/
    TemplateIDSimple addTemplate(1:TemplateBody template,
                        2:Attachments attachments) throws (1: base.InvalidRequest ex1, 2:DataTooBig ex2)

    /**
    * Добавление шаблона с привязкой к магазину.
    * Параметры - тело шаблона, комплексный идентификатор шаблона, описывающий привязку шаблона к магазину, вложения
    * Результат - возвращается числовой идентификатор шаблона
    **/
    TemplateIDSimple addTemplateForShop(1:TemplateBody template,
                            2:TemplateID templateIDForShop,
                            3:Attachments attachments) throws (1: base.InvalidRequest ex1, 2:DataTooBig ex2)

    /**
    * Редактирование существующего шаблона.
    * Параметры - общий идентификатор шаблона, тело шаблона, вложения
    **/
    void updateTemplate(1:TemplateID templateId,
                        2:TemplateBody template,
                        3:Attachments attachments) throws (1: base.InvalidRequest ex1, 2:DataTooBig ex2, 3:TemplateNotFound ex3)
    /**
    * Удаление шаблона.
    **/
    void removeTemplate(1:TemplateID templateId) throws (1: base.InvalidRequest ex1, 2:TemplateNotFound ex2)

}