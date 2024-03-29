include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.message_sender
namespace erlang message_sender

struct MessageAttachment{
    1: required string name
    2: optional string mime_type
    3: required binary data
}

typedef list<MessageAttachment> MessageAttachments

/**
* Здесь могут быть и другие виды сообщений, например, MessageSMS, MessagePush
**/
union Message{
    1: MessageMail message_mail
}

/**
*
**/
struct MailBody {
    // Content-Type письма (вместе с кодировкой). Например, "text/plain; charset=iso-8859-1"
    1: optional string content_type
    2: required string text
}

struct MessageMail {
    1: required MailBody mail_body
    2: optional string subject
    3: required string from_email
    4: required list<string> to_emails
    5: optional MessageAttachments attachments
}

struct ShopExclusionRule {
    1: required list<string> shop_ids
}

union MessageExclusionRule {
    1: ShopExclusionRule shop_rule
}

struct MessageExclusion {
    1: required string name
    2: required MessageExclusionRule rule
}

struct MessageExclusionRef {
    1: required i64 id
}

enum ExclusionType {
    SHOP
}

struct MessageExclusionObject {
    1: required MessageExclusionRef ref
    2: required MessageExclusion exclusion
}

exception ExclusionNotFound {}

service MessageSender {
    /**
    * Отправка сообщения.
    **/
    void send(1: Message message) throws (1: base.InvalidRequest ex1)

    /**
    * Добавить исключение для отправки
    **/
    MessageExclusionObject addExclusionRule(1: MessageExclusion rule)

    MessageExclusionObject getExclusionRule(1: MessageExclusionRef ref) throws (1: ExclusionNotFound ex1)

    /**
    * Получить список исключений
    **/
    list<MessageExclusionObject> getExclusionRules(1: optional ExclusionType type)

    /**
    * Удалить исключение
    **/
    void removeExclusionRule(1: MessageExclusionRef ref) throws (1: ExclusionNotFound ex1)
}
