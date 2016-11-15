include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.message_sender
namespace erlang message_sender

typedef list<binary> MessageAttachments

/**
* Здесь могут быть и другие виды сообщений, например, SMSMessage, PushMessage
**/
union Message{
    1:MailMessage mailMessage
}

struct MailMessage {
    1:required string mailBody
    2:required string subject
    3:required string fromEmail
    4:required list<string> toEmail
    5:optional MessageAttachments attachments
}

/**
* Ошибки, возникающие при отправке письма.
* Например, недоступен почтовый сервер
**/
exception MessageNotSend {
}

/**
* Ошибка, если пытаются отправить слишком длинное письмо
**/
exception MessageDataTooBig {
    1: i32 limit;
}

service MessageSenderService {
    /**
    * Отправка готового письма.
    * Параметр - сообщение
    **/
    bool send(1:Message message) throws (1: base.InvalidRequest ex1, 2:MessageNotSend ex2, 3:MessageDataTooBig ex3)
}