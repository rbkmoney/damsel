%%
%% Autogenerated by Thrift Compiler (1.0.0-dev)
%%
%% DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
%%

-module(dmsl_message_sender_thrift).

-include("dmsl_message_sender_thrift.hrl").

-export([namespace/0]).
-export([enums/0]).
-export([typedefs/0]).
-export([structs/0]).
-export([services/0]).
-export([typedef_info/1]).
-export([enum_info/1]).
-export([struct_info/1]).
-export([record_name/1]).
-export([functions/1]).
-export([function_info/3]).

-export_type([namespace/0]).
-export_type([typedef_name/0]).
-export_type([enum_name/0]).
-export_type([struct_name/0]).
-export_type([exception_name/0]).
-export_type([service_name/0]).
-export_type([function_name/0]).

-export_type([enum_info/0]).
-export_type([struct_info/0]).

-export_type([
    'MessageAttachments'/0
]).
-export_type([
    'MessageAttachment'/0,
    'Message'/0,
    'MailBody'/0,
    'MessageMail'/0
]).

-type namespace() :: 'message_sender'.

%%
%% typedefs
%%
-type typedef_name() ::
    'MessageAttachments'.

-type 'MessageAttachments'() :: ['MessageAttachment'()].

%%
%% enums
%%
-type enum_name() :: none().

%%
%% structs, unions and exceptions
%%
-type struct_name() ::
    'MessageAttachment' |
    'Message' |
    'MailBody' |
    'MessageMail'.

-type exception_name() :: none().

%% struct 'MessageAttachment'
-type 'MessageAttachment'() :: #'message_sender_MessageAttachment'{}.

%% union 'Message'
-type 'Message'() ::
    {'message_mail', 'MessageMail'()}.

%% struct 'MailBody'
-type 'MailBody'() :: #'message_sender_MailBody'{}.

%% struct 'MessageMail'
-type 'MessageMail'() :: #'message_sender_MessageMail'{}.

%%
%% services and functions
%%
-type service_name() ::
    'MessageSender'.

-type function_name() ::
    'MessageSender_service_functions'().

-type 'MessageSender_service_functions'() ::
    'send'.

-export_type(['MessageSender_service_functions'/0]).


-type struct_flavour() :: struct | exception | union.
-type field_num() :: pos_integer().
-type field_name() :: atom().
-type field_req() :: required | optional | undefined.

-type type_ref() :: {module(), atom()}.
-type field_type() ::
    bool | byte | i16 | i32 | i64 | string | double |
{enum, type_ref()} |
{struct, struct_flavour(), type_ref()} |
{list, field_type()} |
{set, field_type()} |
{map, field_type(), field_type()}.

-type struct_field_info() ::
    {field_num(), field_req(), field_type(), field_name(), any()}.
-type struct_info() ::
    {struct, struct_flavour(), [struct_field_info()]}.

-type enum_choice() :: none().

-type enum_field_info() ::
    {enum_choice(), integer()}.
-type enum_info() ::
    {enum, [enum_field_info()]}.

-spec typedefs() -> [typedef_name()].

typedefs() ->
    [
        'MessageAttachments'
    ].

-spec enums() -> [].

enums() ->
    [].

-spec structs() -> [struct_name()].

structs() ->
    [
        'MessageAttachment',
        'Message',
        'MailBody',
        'MessageMail'
    ].

-spec services() -> [service_name()].

services() ->
    [
        'MessageSender'
    ].

-spec namespace() -> namespace().

namespace() ->
    'message_sender'.

-spec typedef_info(typedef_name()) -> field_type() | no_return().

typedef_info('MessageAttachments') ->
    {list, {struct, struct, {dmsl_message_sender_thrift, 'MessageAttachment'}}};

typedef_info(_) -> erlang:error(badarg).

-spec enum_info(_) -> no_return().

enum_info(_) -> erlang:error(badarg).

-spec struct_info(struct_name() | exception_name()) -> struct_info() | no_return().

struct_info('MessageAttachment') ->
    {struct, struct, [
    {1, required, string, 'name', undefined},
    {2, optional, string, 'mime_type', undefined},
    {3, required, string, 'data', undefined}
]};

struct_info('Message') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_message_sender_thrift, 'MessageMail'}}, 'message_mail', undefined}
]};

struct_info('MailBody') ->
    {struct, struct, [
    {1, optional, string, 'content_type', undefined},
    {2, required, string, 'text', undefined}
]};

struct_info('MessageMail') ->
    {struct, struct, [
    {1, required, {struct, struct, {dmsl_message_sender_thrift, 'MailBody'}}, 'mail_body', undefined},
    {2, optional, string, 'subject', undefined},
    {3, required, string, 'from_email', undefined},
    {4, required, {list, string}, 'to_emails', undefined},
    {5, optional, {list, {struct, struct, {dmsl_message_sender_thrift, 'MessageAttachment'}}}, 'attachments', undefined}
]};

struct_info(_) -> erlang:error(badarg).

-spec record_name(struct_name() | exception_name()) -> atom() | no_return().

record_name('MessageAttachment') ->
    'message_sender_MessageAttachment';

record_name('MailBody') ->
    'message_sender_MailBody';

    record_name('MessageMail') ->
    'message_sender_MessageMail';

    record_name(_) -> error(badarg).
    
    -spec functions(service_name()) -> [function_name()] | no_return().

functions('MessageSender') ->
    [
        'send'
    ];

functions(_) -> error(badarg).

-spec function_info(service_name(), function_name(), params_type | reply_type | exceptions) ->
    struct_info() | no_return().

function_info('MessageSender', 'send', params_type) ->
    {struct, struct, [
    {1, undefined, {struct, union, {dmsl_message_sender_thrift, 'Message'}}, 'message', undefined}
]};
function_info('MessageSender', 'send', reply_type) ->
        {struct, struct, []};
    function_info('MessageSender', 'send', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_base_thrift, 'InvalidRequest'}}, 'ex1', undefined}
    ]};

function_info(_Service, _Function, _InfoType) -> erlang:error(badarg).