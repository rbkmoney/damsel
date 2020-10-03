%%
%% Autogenerated by Thrift Compiler (1.0.0-dev)
%%
%% DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
%%

-module(dmsl_p2p_adapter_thrift).

-include("dmsl_p2p_adapter_thrift.hrl").

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
    'AdapterState'/0,
    'CallbackPayload'/0,
    'CallbackResponsePayload'/0,
    'CallbackTag'/0,
    'UserInteractionID'/0,
    'OperationID'/0,
    'SessionID'/0
]).
-export_type([
    'Intent'/0,
    'FinishIntent'/0,
    'FinishStatus'/0,
    'Success'/0,
    'SleepIntent'/0,
    'UserInteraction'/0,
    'UserInteractionIntent'/0,
    'UserInteractionCreate'/0,
    'UserInteractionFinish'/0,
    'Cash'/0,
    'Fees'/0,
    'OperationInfo'/0,
    'ProcessOperationInfo'/0,
    'PaymentResource'/0,
    'Session'/0,
    'Context'/0,
    'ProcessResult'/0,
    'Callback'/0,
    'CallbackResponse'/0,
    'CallbackResult'/0,
    'ProcessCallbackResult'/0,
    'ProcessCallbackSucceeded'/0,
    'ProcessCallbackFinished'/0
]).
-export_type([
    'SessionNotFound'/0
]).

-type namespace() :: 'p2p_adapter'.

%%
%% typedefs
%%
-type typedef_name() ::
    'AdapterState' |
    'CallbackPayload' |
    'CallbackResponsePayload' |
    'CallbackTag' |
    'UserInteractionID' |
    'OperationID' |
    'SessionID'.

-type 'AdapterState'() :: dmsl_base_thrift:'Opaque'().
-type 'CallbackPayload'() :: dmsl_base_thrift:'Opaque'().
-type 'CallbackResponsePayload'() :: dmsl_base_thrift:'Opaque'().
-type 'CallbackTag'() :: dmsl_base_thrift:'Tag'().
-type 'UserInteractionID'() :: dmsl_base_thrift:'ID'().
-type 'OperationID'() :: dmsl_base_thrift:'ID'().
-type 'SessionID'() :: dmsl_base_thrift:'ID'().

%%
%% enums
%%
-type enum_name() :: none().

%%
%% structs, unions and exceptions
%%
-type struct_name() ::
    'Intent' |
    'FinishIntent' |
    'FinishStatus' |
    'Success' |
    'SleepIntent' |
    'UserInteraction' |
    'UserInteractionIntent' |
    'UserInteractionCreate' |
    'UserInteractionFinish' |
    'Cash' |
    'Fees' |
    'OperationInfo' |
    'ProcessOperationInfo' |
    'PaymentResource' |
    'Session' |
    'Context' |
    'ProcessResult' |
    'Callback' |
    'CallbackResponse' |
    'CallbackResult' |
    'ProcessCallbackResult' |
    'ProcessCallbackSucceeded' |
    'ProcessCallbackFinished'.

-type exception_name() ::
    'SessionNotFound'.

%% union 'Intent'
-type 'Intent'() ::
    {'finish', 'FinishIntent'()} |
    {'sleep', 'SleepIntent'()}.

%% struct 'FinishIntent'
-type 'FinishIntent'() :: #'p2p_adapter_FinishIntent'{}.

%% union 'FinishStatus'
-type 'FinishStatus'() ::
    {'success', 'Success'()} |
    {'failure', dmsl_domain_thrift:'Failure'()}.

%% struct 'Success'
-type 'Success'() :: #'p2p_adapter_Success'{}.

%% struct 'SleepIntent'
-type 'SleepIntent'() :: #'p2p_adapter_SleepIntent'{}.

%% struct 'UserInteraction'
-type 'UserInteraction'() :: #'p2p_adapter_UserInteraction'{}.

%% union 'UserInteractionIntent'
-type 'UserInteractionIntent'() ::
    {'create', 'UserInteractionCreate'()} |
    {'finish', 'UserInteractionFinish'()}.

%% struct 'UserInteractionCreate'
-type 'UserInteractionCreate'() :: #'p2p_adapter_UserInteractionCreate'{}.

%% struct 'UserInteractionFinish'
-type 'UserInteractionFinish'() :: #'p2p_adapter_UserInteractionFinish'{}.

%% struct 'Cash'
-type 'Cash'() :: #'p2p_adapter_Cash'{}.

%% struct 'Fees'
-type 'Fees'() :: #'p2p_adapter_Fees'{}.

%% union 'OperationInfo'
-type 'OperationInfo'() ::
    {'process', 'ProcessOperationInfo'()}.

%% struct 'ProcessOperationInfo'
-type 'ProcessOperationInfo'() :: #'p2p_adapter_ProcessOperationInfo'{}.

%% union 'PaymentResource'
-type 'PaymentResource'() ::
    {'disposable', dmsl_domain_thrift:'DisposablePaymentResource'()}.

%% struct 'Session'
-type 'Session'() :: #'p2p_adapter_Session'{}.

%% struct 'Context'
-type 'Context'() :: #'p2p_adapter_Context'{}.

%% struct 'ProcessResult'
-type 'ProcessResult'() :: #'p2p_adapter_ProcessResult'{}.

%% struct 'Callback'
-type 'Callback'() :: #'p2p_adapter_Callback'{}.

%% struct 'CallbackResponse'
-type 'CallbackResponse'() :: #'p2p_adapter_CallbackResponse'{}.

%% struct 'CallbackResult'
-type 'CallbackResult'() :: #'p2p_adapter_CallbackResult'{}.

%% union 'ProcessCallbackResult'
-type 'ProcessCallbackResult'() ::
    {'succeeded', 'ProcessCallbackSucceeded'()} |
    {'finished', 'ProcessCallbackFinished'()}.

%% struct 'ProcessCallbackSucceeded'
-type 'ProcessCallbackSucceeded'() :: #'p2p_adapter_ProcessCallbackSucceeded'{}.

%% struct 'ProcessCallbackFinished'
-type 'ProcessCallbackFinished'() :: #'p2p_adapter_ProcessCallbackFinished'{}.

%% exception 'SessionNotFound'
-type 'SessionNotFound'() :: #'p2p_adapter_SessionNotFound'{}.

%%
%% services and functions
%%
-type service_name() ::
    'P2PAdapter' |
    'P2PAdapterHost'.

-type function_name() ::
    'P2PAdapter_service_functions'() |
    'P2PAdapterHost_service_functions'().

-type 'P2PAdapter_service_functions'() ::
    'Process' |
    'HandleCallback'.

-export_type(['P2PAdapter_service_functions'/0]).

-type 'P2PAdapterHost_service_functions'() ::
    'ProcessCallback'.

-export_type(['P2PAdapterHost_service_functions'/0]).


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
        'AdapterState',
        'CallbackPayload',
        'CallbackResponsePayload',
        'CallbackTag',
        'UserInteractionID',
        'OperationID',
        'SessionID'
    ].

-spec enums() -> [].

enums() ->
    [].

-spec structs() -> [struct_name()].

structs() ->
    [
        'Intent',
        'FinishIntent',
        'FinishStatus',
        'Success',
        'SleepIntent',
        'UserInteraction',
        'UserInteractionIntent',
        'UserInteractionCreate',
        'UserInteractionFinish',
        'Cash',
        'Fees',
        'OperationInfo',
        'ProcessOperationInfo',
        'PaymentResource',
        'Session',
        'Context',
        'ProcessResult',
        'Callback',
        'CallbackResponse',
        'CallbackResult',
        'ProcessCallbackResult',
        'ProcessCallbackSucceeded',
        'ProcessCallbackFinished'
    ].

-spec services() -> [service_name()].

services() ->
    [
        'P2PAdapter',
        'P2PAdapterHost'
    ].

-spec namespace() -> namespace().

namespace() ->
    'p2p_adapter'.

-spec typedef_info(typedef_name()) -> field_type() | no_return().

typedef_info('AdapterState') ->
    string;

typedef_info('CallbackPayload') ->
    string;

typedef_info('CallbackResponsePayload') ->
    string;

typedef_info('CallbackTag') ->
    string;

typedef_info('UserInteractionID') ->
    string;

typedef_info('OperationID') ->
    string;

typedef_info('SessionID') ->
    string;

typedef_info(_) -> erlang:error(badarg).

-spec enum_info(_) -> no_return().

enum_info(_) -> erlang:error(badarg).

-spec struct_info(struct_name() | exception_name()) -> struct_info() | no_return().

struct_info('Intent') ->
    {struct, union, [
        {1, optional, {struct, struct, {dmsl_p2p_adapter_thrift, 'FinishIntent'}}, 'finish', undefined},
        {2, optional, {struct, struct, {dmsl_p2p_adapter_thrift, 'SleepIntent'}}, 'sleep', undefined}
    ]};

struct_info('FinishIntent') ->
    {struct, struct, [
        {1, required, {struct, union, {dmsl_p2p_adapter_thrift, 'FinishStatus'}}, 'status', undefined}
    ]};

struct_info('FinishStatus') ->
    {struct, union, [
        {1, optional, {struct, struct, {dmsl_p2p_adapter_thrift, 'Success'}}, 'success', undefined},
        {2, optional, {struct, struct, {dmsl_domain_thrift, 'Failure'}}, 'failure', undefined}
    ]};

struct_info('Success') ->
    {struct, struct, []};

struct_info('SleepIntent') ->
    {struct, struct, [
        {1, required, {struct, union, {dmsl_base_thrift, 'Timer'}}, 'timer', undefined},
        {2, optional, {struct, struct, {dmsl_p2p_adapter_thrift, 'UserInteraction'}}, 'user_interaction', undefined},
        {3, optional, string, 'callback_tag', undefined}
    ]};

struct_info('UserInteraction') ->
    {struct, struct, [
        {1, required, string, 'id', undefined},
        {2, required, {struct, union, {dmsl_p2p_adapter_thrift, 'UserInteractionIntent'}}, 'intent', undefined}
    ]};

struct_info('UserInteractionIntent') ->
    {struct, union, [
        {1, optional, {struct, struct, {dmsl_p2p_adapter_thrift, 'UserInteractionCreate'}}, 'create', undefined},
        {2, optional, {struct, struct, {dmsl_p2p_adapter_thrift, 'UserInteractionFinish'}}, 'finish', undefined}
    ]};

struct_info('UserInteractionCreate') ->
    {struct, struct, [
        {1, required, {struct, union, {dmsl_user_interaction_thrift, 'UserInteraction'}}, 'user_interaction', undefined}
    ]};

struct_info('UserInteractionFinish') ->
    {struct, struct, []};

struct_info('Cash') ->
    {struct, struct, [
        {1, required, i64, 'amount', undefined},
        {2, required, {struct, struct, {dmsl_domain_thrift, 'Currency'}}, 'currency', undefined}
    ]};

struct_info('Fees') ->
    {struct, struct, [
        {1, required, {map, {enum, {dmsl_domain_thrift, 'CashFlowConstant'}}, {struct, struct, {dmsl_p2p_adapter_thrift, 'Cash'}}}, 'fees', undefined}
    ]};

struct_info('OperationInfo') ->
    {struct, union, [
        {1, optional, {struct, struct, {dmsl_p2p_adapter_thrift, 'ProcessOperationInfo'}}, 'process', undefined}
    ]};

struct_info('ProcessOperationInfo') ->
    {struct, struct, [
        {1, required, {struct, struct, {dmsl_p2p_adapter_thrift, 'Cash'}}, 'body', undefined},
        {5, optional, {struct, struct, {dmsl_p2p_adapter_thrift, 'Fees'}}, 'merchant_fees', undefined},
        {6, optional, {struct, struct, {dmsl_p2p_adapter_thrift, 'Fees'}}, 'provider_fees', undefined},
        {2, required, {struct, union, {dmsl_p2p_adapter_thrift, 'PaymentResource'}}, 'sender', undefined},
        {3, required, {struct, union, {dmsl_p2p_adapter_thrift, 'PaymentResource'}}, 'receiver', undefined},
        {4, optional, string, 'deadline', undefined},
        {7, required, string, 'id', undefined}
    ]};

struct_info('PaymentResource') ->
    {struct, union, [
        {1, optional, {struct, struct, {dmsl_domain_thrift, 'DisposablePaymentResource'}}, 'disposable', undefined}
    ]};

struct_info('Session') ->
    {struct, struct, [
        {1, optional, string, 'state', undefined},
        {2, required, string, 'id', undefined}
    ]};

struct_info('Context') ->
    {struct, struct, [
        {1, required, {struct, struct, {dmsl_p2p_adapter_thrift, 'Session'}}, 'session', undefined},
        {2, required, {struct, union, {dmsl_p2p_adapter_thrift, 'OperationInfo'}}, 'operation', undefined},
        {3, optional, {map, string, string}, 'options', #{}}
    ]};

struct_info('ProcessResult') ->
    {struct, struct, [
        {1, required, {struct, union, {dmsl_p2p_adapter_thrift, 'Intent'}}, 'intent', undefined},
        {2, optional, string, 'next_state', undefined},
        {3, optional, {struct, struct, {dmsl_domain_thrift, 'TransactionInfo'}}, 'trx', undefined}
    ]};

struct_info('Callback') ->
    {struct, struct, [
        {1, required, string, 'tag', undefined},
        {2, required, string, 'payload', undefined}
    ]};

struct_info('CallbackResponse') ->
    {struct, struct, [
        {1, required, string, 'payload', undefined}
    ]};

struct_info('CallbackResult') ->
    {struct, struct, [
        {1, required, {struct, union, {dmsl_p2p_adapter_thrift, 'Intent'}}, 'intent', undefined},
        {2, optional, string, 'next_state', undefined},
        {3, optional, {struct, struct, {dmsl_domain_thrift, 'TransactionInfo'}}, 'trx', undefined},
        {4, required, {struct, struct, {dmsl_p2p_adapter_thrift, 'CallbackResponse'}}, 'response', undefined}
    ]};

struct_info('ProcessCallbackResult') ->
    {struct, union, [
        {1, optional, {struct, struct, {dmsl_p2p_adapter_thrift, 'ProcessCallbackSucceeded'}}, 'succeeded', undefined},
        {2, optional, {struct, struct, {dmsl_p2p_adapter_thrift, 'ProcessCallbackFinished'}}, 'finished', undefined}
    ]};

struct_info('ProcessCallbackSucceeded') ->
    {struct, struct, [
        {1, required, {struct, struct, {dmsl_p2p_adapter_thrift, 'CallbackResponse'}}, 'response', undefined}
    ]};

struct_info('ProcessCallbackFinished') ->
    {struct, struct, [
        {1, required, {struct, struct, {dmsl_p2p_adapter_thrift, 'Context'}}, 'response', undefined}
    ]};

struct_info('SessionNotFound') ->
    {struct, exception, []};

struct_info(_) -> erlang:error(badarg).

-spec record_name(struct_name() | exception_name()) -> atom() | no_return().

record_name('FinishIntent') ->
    'p2p_adapter_FinishIntent';

record_name('Success') ->
    'p2p_adapter_Success';

record_name('SleepIntent') ->
    'p2p_adapter_SleepIntent';

record_name('UserInteraction') ->
    'p2p_adapter_UserInteraction';

record_name('UserInteractionCreate') ->
    'p2p_adapter_UserInteractionCreate';

record_name('UserInteractionFinish') ->
    'p2p_adapter_UserInteractionFinish';

record_name('Cash') ->
    'p2p_adapter_Cash';

record_name('Fees') ->
    'p2p_adapter_Fees';

record_name('ProcessOperationInfo') ->
    'p2p_adapter_ProcessOperationInfo';

record_name('Session') ->
    'p2p_adapter_Session';

record_name('Context') ->
    'p2p_adapter_Context';

record_name('ProcessResult') ->
    'p2p_adapter_ProcessResult';

record_name('Callback') ->
    'p2p_adapter_Callback';

record_name('CallbackResponse') ->
    'p2p_adapter_CallbackResponse';

record_name('CallbackResult') ->
    'p2p_adapter_CallbackResult';

record_name('ProcessCallbackSucceeded') ->
    'p2p_adapter_ProcessCallbackSucceeded';

record_name('ProcessCallbackFinished') ->
    'p2p_adapter_ProcessCallbackFinished';

record_name('SessionNotFound') ->
    'p2p_adapter_SessionNotFound';

record_name(_) -> error(badarg).

-spec functions(service_name()) -> [function_name()] | no_return().

functions('P2PAdapter') ->
    [
        'Process',
        'HandleCallback'
    ];

functions('P2PAdapterHost') ->
    [
        'ProcessCallback'
    ];

functions(_) -> error(badarg).

-spec function_info(service_name(), function_name(), params_type | reply_type | exceptions) ->
    struct_info() | no_return().

function_info('P2PAdapter', 'Process', params_type) ->
    {struct, struct, [
        {1, undefined, {struct, struct, {dmsl_p2p_adapter_thrift, 'Context'}}, 'context', undefined}
    ]};
function_info('P2PAdapter', 'Process', reply_type) ->
    {struct, struct, {dmsl_p2p_adapter_thrift, 'ProcessResult'}};
function_info('P2PAdapter', 'Process', exceptions) ->
    {struct, struct, []};
function_info('P2PAdapter', 'HandleCallback', params_type) ->
    {struct, struct, [
        {1, undefined, {struct, struct, {dmsl_p2p_adapter_thrift, 'Callback'}}, 'callback', undefined},
        {2, undefined, {struct, struct, {dmsl_p2p_adapter_thrift, 'Context'}}, 'context', undefined}
    ]};
function_info('P2PAdapter', 'HandleCallback', reply_type) ->
    {struct, struct, {dmsl_p2p_adapter_thrift, 'CallbackResult'}};
function_info('P2PAdapter', 'HandleCallback', exceptions) ->
    {struct, struct, []};

function_info('P2PAdapterHost', 'ProcessCallback', params_type) ->
    {struct, struct, [
        {1, undefined, {struct, struct, {dmsl_p2p_adapter_thrift, 'Callback'}}, 'callback', undefined}
    ]};
function_info('P2PAdapterHost', 'ProcessCallback', reply_type) ->
    {struct, union, {dmsl_p2p_adapter_thrift, 'ProcessCallbackResult'}};
function_info('P2PAdapterHost', 'ProcessCallback', exceptions) ->
    {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_p2p_adapter_thrift, 'SessionNotFound'}}, 'ex1', undefined}
    ]};

function_info(_Service, _Function, _InfoType) -> erlang:error(badarg).
