include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.dudoser
namespace erlang dudoser

typedef string MailMessageBody
typedef string MailSubject
typedef string MailTo
typedef list<list<byte>> MailAttachments



//Простой идентификатор шаблона
typedef i32 MailTemplateIDSimple

/**
* Составной идентификатор шаблона письма
* messageType - тип сообщения
* merchantID - идентификатор мерчанта
* shopID - идентификатор магазина
*/
struct MailTemplateIDComplex {
    1: string messageType
    2: i32 merchantID
    3: domain.ShopID shopID
}

/**
* Юнион из двух видов идентификаторов
**/
union MailTemplateID {
    1: MailTemplateIDComplex mailTemplateIDForShop
    2: MailTemplateIDSimple mailTemplateID
}

typedef string MailTemplateBody

/**
* Ошибки, возникающие при отправке письма.
* Например, недоступен почтовый сервер
**/
exception MailSendException {
}

/**
* Ошибка, если по указанным идентификаторам не найден шаблон
**/
exception MailTemplateNotFoundException {
}

/**
* Ошибка, если пытаются отправить слишком длинное письмо или шаблон
**/
exception MailDataTooBig {
    1: i32 limit;
}

service DudoserService {
    /**
    * Отправка готового письма.
    * Параметры - тело, тема письма, адрес, вложения
    **/
    bool sendMail(1:MailMessageBody message,
                    2:MailSubject subject,
                    3:MailTo to,
                    4:MailAttachments attachments) throws (1: base.InvalidRequest ex1, 2:MailSendException ex2, 3:MailDataTooBig ex3)

    /**
    * Отправка письма по шаблону.
    * Параметры - данные для подставновки в шаблон, идентификатор шаблона, адрес, вложения
    **/
    void sendMailByTemplate(1:base.StringMap parameters,
                        2:MailTemplateID templateId,
                        3:MailTo to,
                        4:MailAttachments attachments) throws (1: base.InvalidRequest ex1, 2:MailSendException ex2, 3:MailDataTooBig ex3, 4:MailTemplateNotFoundException ex4)

    /**
    * Добавление шаблона без привязки к магазину.
    * Паараметры - тело шаблона (возможно параметризованное), вложения
    * Результат - возвращается числовой идентификатор шаблона
    **/
    MailTemplateIDSimple addTemplate(1:MailTemplateBody template,
                        2:MailAttachments attachments) throws (1: base.InvalidRequest ex1, 2:MailDataTooBig ex2)

    /**
    * Добаавление шаблона с привязкой к магазину.
    * Параметры - тело шаблона, косплексный идентификатор шаблона, описывающий привязку шаблона к магазину, вложения
    * Результат - возвращается числовой идентификатор шаблона
    **/
    MailTemplateIDSimple addTemplateForShop(1:MailTemplateBody template,
                            2:MailTemplateID mailTemplateIDForShop,
                            3:MailAttachments attachments) throws (1: base.InvalidRequest ex1, 2:MailDataTooBig ex2)

    /**
    * Редактирование существующего шаблона.
    * Параметры - общий идентификатор шаблона, тело шаблона, вложения
    **/
    void updateTemplate(1:MailTemplateID templateId,
                        2:MailTemplateBody template,
                        3:MailAttachments attachments) throws (1: base.InvalidRequest ex1, 2:MailDataTooBig ex2, 3:MailTemplateNotFoundException ex3)
    /**
    * Удаление шаблона.
    **/
    void removeTemplate(1:MailTemplateID templateId) throws (1: base.InvalidRequest ex1, 2:MailTemplateNotFoundException ex2)

}