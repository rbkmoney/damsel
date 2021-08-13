-ifndef(dmsl_message_sender_thrift_included__).
-define(dmsl_message_sender_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_domain_thrift.hrl").



%% struct 'MessageAttachment'
-record('message_sender_MessageAttachment', {
    'name' :: binary(),
    'mime_type' :: binary() | undefined,
    'data' :: binary()
}).

%% struct 'MailBody'
-record('message_sender_MailBody', {
    'content_type' :: binary() | undefined,
    'text' :: binary()
}).

%% struct 'MessageMail'
-record('message_sender_MessageMail', {
    'mail_body' :: dmsl_message_sender_thrift:'MailBody'(),
    'subject' :: binary() | undefined,
    'from_email' :: binary(),
    'to_emails' :: [binary()],
    'attachments' :: dmsl_message_sender_thrift:'MessageAttachments'() | undefined
}).

%% struct 'ShopExclusionRule'
-record('message_sender_ShopExclusionRule', {
    'shop_ids' :: [binary()]
}).

%% struct 'MessageExclusion'
-record('message_sender_MessageExclusion', {
    'name' :: binary(),
    'rule' :: dmsl_message_sender_thrift:'MessageExclusionRule'()
}).

%% struct 'MessageExclusionRef'
-record('message_sender_MessageExclusionRef', {
    'id' :: integer()
}).

%% struct 'MessageExclusionObject'
-record('message_sender_MessageExclusionObject', {
    'ref' :: dmsl_message_sender_thrift:'MessageExclusionRef'(),
    'exclusion' :: dmsl_message_sender_thrift:'MessageExclusion'()
}).

%% exception 'ExclusionNotFound'
-record('message_sender_ExclusionNotFound', {}).

-endif.
