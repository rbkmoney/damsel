include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.message_sender
namespace erlang message_sender

struct MessageAttachment{
    1:string name
    2:string type
    3:binary data
}

typedef list<MessageAttachment> MessageAttachments

/**
* Здесь могут быть и другие виды сообщений, например, SMSMessage, PushMessage
**/
union Message{
    1:MailMessage mail_message
}

struct MailMessage {
    1:required string mail_body
    2:required string subject
    3:required string from_email
    4:required list<string> to_emails
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
    void send(1:Message message) throws (1: base.InvalidRequest ex1, 2:MessageNotSend ex2, 3:MessageDataTooBig ex3)
}