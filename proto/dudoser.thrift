include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.dudoser
namespace erlang dudoser

typedef string MessageBody
typedef string MessageSubject
typedef string MessageTo
typedef list<list<byte>> MessageAttachments



//Простой идентификатор шаблона
typedef i32 MessageTemplateIDSimple

/**
* Составной идентификатор шаблона письма
* messageType - тип сообщения
* merchantID - идентификатор мерчанта
* shopID - идентификатор магазина
*/
struct MessageTemplateIDComplex {
    1: string messageType
    2: i32 merchantID
    3: domain.ShopID shopID
}

/**
* Юнион из двух видов идентификаторов
**/
union MessageTemplateID {
    1: MessageTemplateIDComplex templateIDForShop
    2: MessageTemplateIDSimple templateID
}

typedef string MessageTemplateBody

/**
* Ошибки, возникающие при отправке письма.
* Например, недоступен почтовый сервер
**/
exception MessageNotSend {
}

/**
* Ошибка, если по указанным идентификаторам не найден шаблон
**/
exception MessageTemplateNotFound {
}

/**
* Ошибка, если пытаются отправить слишком длинное письмо или шаблон
**/
exception MessageDataTooBig {
    1: i32 limit;
}

service DudoserService {
    /**
    * Отправка готового письма.
    * Параметры - тело, тема письма, адрес, вложения
    **/
    bool send(1:MessageBody message,
                    2:MessageSubject subject,
                    3:MessageTo to,
                    4:MessageAttachments attachments) throws (1: base.InvalidRequest ex1, 2:MessageNotSend ex2, 3:MessageDataTooBig ex3)

    /**
    * Отправка письма по шаблону.
    * Параметры - данные для подставновки в шаблон, идентификатор шаблона, адрес, вложения
    **/
    void sendByTemplate(1:base.StringMap parameters,
                        2:MessageTemplateID templateId,
                        3:MessageTo to,
                        4:MessageAttachments attachments) throws (1: base.InvalidRequest ex1, 2:MessageNotSend ex2, 3:MessageDataTooBig ex3, 4:MessageTemplateNotFound ex4)

    /**
    * Добавление шаблона без привязки к магазину.
    * Параметры - тело шаблона (возможно параметризованное), вложения
    * Результат - возвращается числовой идентификатор шаблона
    **/
    MessageTemplateIDSimple addTemplate(1:MessageTemplateBody template,
                        2:MessageAttachments attachments) throws (1: base.InvalidRequest ex1, 2:MessageDataTooBig ex2)

    /**
    * Добавление шаблона с привязкой к магазину.
    * Параметры - тело шаблона, комплексный идентификатор шаблона, описывающий привязку шаблона к магазину, вложения
    * Результат - возвращается числовой идентификатор шаблона
    **/
    MessageTemplateIDSimple addTemplateForShop(1:MessageTemplateBody template,
                            2:MessageTemplateID templateIDForShop,
                            3:MessageAttachments attachments) throws (1: base.InvalidRequest ex1, 2:MessageDataTooBig ex2)

    /**
    * Редактирование существующего шаблона.
    * Параметры - общий идентификатор шаблона, тело шаблона, вложения
    **/
    void updateTemplate(1:MessageTemplateID templateId,
                        2:MessageTemplateBody template,
                        3:MessageAttachments attachments) throws (1: base.InvalidRequest ex1, 2:MessageDataTooBig ex2, 3:MessageTemplateNotFound ex3)
    /**
    * Удаление шаблона.
    **/
    void removeTemplate(1:MessageTemplateID templateId) throws (1: base.InvalidRequest ex1, 2:MessageTemplateNotFound ex2)

}