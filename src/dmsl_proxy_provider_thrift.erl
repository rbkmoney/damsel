%%
%% Autogenerated by Thrift Compiler (1.0.0-dev)
%%
%% DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
%%

-module(dmsl_proxy_provider_thrift).

-include("dmsl_proxy_provider_thrift.hrl").

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
    'ProxyState'/0,
    'Callback'/0,
    'CallbackResponse'/0,
    'CallbackTag'/0
]).
-export_type([
    'Intent'/0,
    'FinishIntent'/0,
    'FinishStatus'/0,
    'Success'/0,
    'SleepIntent'/0,
    'SuspendIntent'/0,
    'RecurrentPaymentTool'/0,
    'RecurrentTokenInfo'/0,
    'RecurrentTokenSession'/0,
    'RecurrentTokenContext'/0,
    'RecurrentTokenProxyResult'/0,
    'RecurrentTokenIntent'/0,
    'RecurrentTokenFinishIntent'/0,
    'RecurrentTokenFinishStatus'/0,
    'RecurrentTokenSuccess'/0,
    'RecurrentTokenCallbackResult'/0,
    'PaymentInfo'/0,
    'Shop'/0,
    'Invoice'/0,
    'PaymentResource'/0,
    'RecurrentPaymentResource'/0,
    'InvoicePayment'/0,
    'InvoicePaymentRefund'/0,
    'InvoicePaymentCapture'/0,
    'Cash'/0,
    'Session'/0,
    'PaymentContext'/0,
    'PaymentProxyResult'/0,
    'PaymentCallbackResult'/0,
    'PaymentCallbackProxyResult'/0
]).
-export_type([
    'PaymentNotFound'/0
]).

-type namespace() :: 'prxprv'.

%%
%% typedefs
%%
-type typedef_name() ::
    'ProxyState' |
    'Callback' |
    'CallbackResponse' |
    'CallbackTag'.

-type 'ProxyState'() :: dmsl_base_thrift:'Opaque'().
-type 'Callback'() :: dmsl_base_thrift:'Opaque'().
-type 'CallbackResponse'() :: dmsl_base_thrift:'Opaque'().
-type 'CallbackTag'() :: dmsl_base_thrift:'Tag'().

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
    'SuspendIntent' |
    'RecurrentPaymentTool' |
    'RecurrentTokenInfo' |
    'RecurrentTokenSession' |
    'RecurrentTokenContext' |
    'RecurrentTokenProxyResult' |
    'RecurrentTokenIntent' |
    'RecurrentTokenFinishIntent' |
    'RecurrentTokenFinishStatus' |
    'RecurrentTokenSuccess' |
    'RecurrentTokenCallbackResult' |
    'PaymentInfo' |
    'Shop' |
    'Invoice' |
    'PaymentResource' |
    'RecurrentPaymentResource' |
    'InvoicePayment' |
    'InvoicePaymentRefund' |
    'InvoicePaymentCapture' |
    'Cash' |
    'Session' |
    'PaymentContext' |
    'PaymentProxyResult' |
    'PaymentCallbackResult' |
    'PaymentCallbackProxyResult'.

-type exception_name() ::
    'PaymentNotFound'.

%% union 'Intent'
-type 'Intent'() ::
    {'finish', 'FinishIntent'()} |
    {'sleep', 'SleepIntent'()} |
    {'suspend', 'SuspendIntent'()}.

%% struct 'FinishIntent'
-type 'FinishIntent'() :: #'prxprv_FinishIntent'{}.

%% union 'FinishStatus'
-type 'FinishStatus'() ::
    {'success', 'Success'()} |
    {'failure', dmsl_domain_thrift:'Failure'()}.

%% struct 'Success'
-type 'Success'() :: #'prxprv_Success'{}.

%% struct 'SleepIntent'
-type 'SleepIntent'() :: #'prxprv_SleepIntent'{}.

%% struct 'SuspendIntent'
-type 'SuspendIntent'() :: #'prxprv_SuspendIntent'{}.

%% struct 'RecurrentPaymentTool'
-type 'RecurrentPaymentTool'() :: #'prxprv_RecurrentPaymentTool'{}.

%% struct 'RecurrentTokenInfo'
-type 'RecurrentTokenInfo'() :: #'prxprv_RecurrentTokenInfo'{}.

%% struct 'RecurrentTokenSession'
-type 'RecurrentTokenSession'() :: #'prxprv_RecurrentTokenSession'{}.

%% struct 'RecurrentTokenContext'
-type 'RecurrentTokenContext'() :: #'prxprv_RecurrentTokenContext'{}.

%% struct 'RecurrentTokenProxyResult'
-type 'RecurrentTokenProxyResult'() :: #'prxprv_RecurrentTokenProxyResult'{}.

%% union 'RecurrentTokenIntent'
-type 'RecurrentTokenIntent'() ::
    {'finish', 'RecurrentTokenFinishIntent'()} |
    {'sleep', 'SleepIntent'()} |
    {'suspend', 'SuspendIntent'()}.

%% struct 'RecurrentTokenFinishIntent'
-type 'RecurrentTokenFinishIntent'() :: #'prxprv_RecurrentTokenFinishIntent'{}.

%% union 'RecurrentTokenFinishStatus'
-type 'RecurrentTokenFinishStatus'() ::
    {'success', 'RecurrentTokenSuccess'()} |
    {'failure', dmsl_domain_thrift:'Failure'()}.

%% struct 'RecurrentTokenSuccess'
-type 'RecurrentTokenSuccess'() :: #'prxprv_RecurrentTokenSuccess'{}.

%% struct 'RecurrentTokenCallbackResult'
-type 'RecurrentTokenCallbackResult'() :: #'prxprv_RecurrentTokenCallbackResult'{}.

%% struct 'PaymentInfo'
-type 'PaymentInfo'() :: #'prxprv_PaymentInfo'{}.

%% struct 'Shop'
-type 'Shop'() :: #'prxprv_Shop'{}.

%% struct 'Invoice'
-type 'Invoice'() :: #'prxprv_Invoice'{}.

%% union 'PaymentResource'
-type 'PaymentResource'() ::
    {'disposable_payment_resource', dmsl_domain_thrift:'DisposablePaymentResource'()} |
    {'recurrent_payment_resource', 'RecurrentPaymentResource'()}.

%% struct 'RecurrentPaymentResource'
-type 'RecurrentPaymentResource'() :: #'prxprv_RecurrentPaymentResource'{}.

%% struct 'InvoicePayment'
-type 'InvoicePayment'() :: #'prxprv_InvoicePayment'{}.

%% struct 'InvoicePaymentRefund'
-type 'InvoicePaymentRefund'() :: #'prxprv_InvoicePaymentRefund'{}.

%% struct 'InvoicePaymentCapture'
-type 'InvoicePaymentCapture'() :: #'prxprv_InvoicePaymentCapture'{}.

%% struct 'Cash'
-type 'Cash'() :: #'prxprv_Cash'{}.

%% struct 'Session'
-type 'Session'() :: #'prxprv_Session'{}.

%% struct 'PaymentContext'
-type 'PaymentContext'() :: #'prxprv_PaymentContext'{}.

%% struct 'PaymentProxyResult'
-type 'PaymentProxyResult'() :: #'prxprv_PaymentProxyResult'{}.

%% struct 'PaymentCallbackResult'
-type 'PaymentCallbackResult'() :: #'prxprv_PaymentCallbackResult'{}.

%% struct 'PaymentCallbackProxyResult'
-type 'PaymentCallbackProxyResult'() :: #'prxprv_PaymentCallbackProxyResult'{}.

%% exception 'PaymentNotFound'
-type 'PaymentNotFound'() :: #'prxprv_PaymentNotFound'{}.

%%
%% services and functions
%%
-type service_name() ::
    'ProviderProxy' |
    'ProviderProxyHost'.

-type function_name() ::
    'ProviderProxy_service_functions'() |
    'ProviderProxyHost_service_functions'().

-type 'ProviderProxy_service_functions'() ::
    'GenerateToken' |
    'HandleRecurrentTokenCallback' |
    'ProcessPayment' |
    'HandlePaymentCallback'.

-export_type(['ProviderProxy_service_functions'/0]).

-type 'ProviderProxyHost_service_functions'() ::
    'ProcessPaymentCallback' |
    'ProcessRecurrentTokenCallback' |
    'GetPayment'.

-export_type(['ProviderProxyHost_service_functions'/0]).


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
        'ProxyState',
        'Callback',
        'CallbackResponse',
        'CallbackTag'
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
        'SuspendIntent',
        'RecurrentPaymentTool',
        'RecurrentTokenInfo',
        'RecurrentTokenSession',
        'RecurrentTokenContext',
        'RecurrentTokenProxyResult',
        'RecurrentTokenIntent',
        'RecurrentTokenFinishIntent',
        'RecurrentTokenFinishStatus',
        'RecurrentTokenSuccess',
        'RecurrentTokenCallbackResult',
        'PaymentInfo',
        'Shop',
        'Invoice',
        'PaymentResource',
        'RecurrentPaymentResource',
        'InvoicePayment',
        'InvoicePaymentRefund',
        'InvoicePaymentCapture',
        'Cash',
        'Session',
        'PaymentContext',
        'PaymentProxyResult',
        'PaymentCallbackResult',
        'PaymentCallbackProxyResult'
    ].

-spec services() -> [service_name()].

services() ->
    [
        'ProviderProxy',
        'ProviderProxyHost'
    ].

-spec namespace() -> namespace().

namespace() ->
    'prxprv'.

-spec typedef_info(typedef_name()) -> field_type() | no_return().

typedef_info('ProxyState') ->
    string;

typedef_info('Callback') ->
    string;

typedef_info('CallbackResponse') ->
    string;

typedef_info('CallbackTag') ->
    string;

typedef_info(_) -> erlang:error(badarg).

-spec enum_info(_) -> no_return().

enum_info(_) -> erlang:error(badarg).

-spec struct_info(struct_name() | exception_name()) -> struct_info() | no_return().

struct_info('Intent') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_proxy_provider_thrift, 'FinishIntent'}}, 'finish', undefined},
    {2, optional, {struct, struct, {dmsl_proxy_provider_thrift, 'SleepIntent'}}, 'sleep', undefined},
    {3, optional, {struct, struct, {dmsl_proxy_provider_thrift, 'SuspendIntent'}}, 'suspend', undefined}
]};

struct_info('FinishIntent') ->
    {struct, struct, [
    {1, required, {struct, union, {dmsl_proxy_provider_thrift, 'FinishStatus'}}, 'status', undefined}
]};

struct_info('FinishStatus') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_proxy_provider_thrift, 'Success'}}, 'success', undefined},
    {2, optional, {struct, struct, {dmsl_domain_thrift, 'Failure'}}, 'failure', undefined}
]};

struct_info('Success') ->
    {struct, struct, [
    {1, optional, string, 'token', undefined}
]};

struct_info('SleepIntent') ->
    {struct, struct, [
    {1, required, {struct, union, {dmsl_base_thrift, 'Timer'}}, 'timer', undefined},
    {2, optional, {struct, union, {dmsl_user_interaction_thrift, 'UserInteraction'}}, 'user_interaction', undefined}
]};

struct_info('SuspendIntent') ->
    {struct, struct, [
    {1, required, string, 'tag', undefined},
    {2, required, {struct, union, {dmsl_base_thrift, 'Timer'}}, 'timeout', undefined},
    {3, optional, {struct, union, {dmsl_user_interaction_thrift, 'UserInteraction'}}, 'user_interaction', undefined},
    {4, optional, {struct, union, {dmsl_timeout_behaviour_thrift, 'TimeoutBehaviour'}}, 'timeout_behaviour', undefined}
]};

struct_info('RecurrentPaymentTool') ->
    {struct, struct, [
    {1, required, string, 'id', undefined},
    {2, required, string, 'created_at', undefined},
    {3, required, {struct, struct, {dmsl_domain_thrift, 'DisposablePaymentResource'}}, 'payment_resource', undefined},
    {4, required, {struct, struct, {dmsl_proxy_provider_thrift, 'Cash'}}, 'minimal_payment_cost', undefined}
]};

struct_info('RecurrentTokenInfo') ->
    {struct, struct, [
    {1, required, {struct, struct, {dmsl_proxy_provider_thrift, 'RecurrentPaymentTool'}}, 'payment_tool', undefined},
    {2, optional, {struct, struct, {dmsl_domain_thrift, 'TransactionInfo'}}, 'trx', undefined}
]};

struct_info('RecurrentTokenSession') ->
    {struct, struct, [
    {1, optional, string, 'state', undefined}
]};

struct_info('RecurrentTokenContext') ->
    {struct, struct, [
    {1, required, {struct, struct, {dmsl_proxy_provider_thrift, 'RecurrentTokenSession'}}, 'session', undefined},
    {2, required, {struct, struct, {dmsl_proxy_provider_thrift, 'RecurrentTokenInfo'}}, 'token_info', undefined},
    {3, optional, {map, string, string}, 'options', #{}}
]};

struct_info('RecurrentTokenProxyResult') ->
    {struct, struct, [
    {1, required, {struct, union, {dmsl_proxy_provider_thrift, 'RecurrentTokenIntent'}}, 'intent', undefined},
    {2, optional, string, 'next_state', undefined},
    {4, optional, {struct, struct, {dmsl_domain_thrift, 'TransactionInfo'}}, 'trx', undefined}
]};

struct_info('RecurrentTokenIntent') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_proxy_provider_thrift, 'RecurrentTokenFinishIntent'}}, 'finish', undefined},
    {2, optional, {struct, struct, {dmsl_proxy_provider_thrift, 'SleepIntent'}}, 'sleep', undefined},
    {3, optional, {struct, struct, {dmsl_proxy_provider_thrift, 'SuspendIntent'}}, 'suspend', undefined}
]};

struct_info('RecurrentTokenFinishIntent') ->
    {struct, struct, [
    {1, required, {struct, union, {dmsl_proxy_provider_thrift, 'RecurrentTokenFinishStatus'}}, 'status', undefined}
]};

struct_info('RecurrentTokenFinishStatus') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_proxy_provider_thrift, 'RecurrentTokenSuccess'}}, 'success', undefined},
    {2, optional, {struct, struct, {dmsl_domain_thrift, 'Failure'}}, 'failure', undefined}
]};

struct_info('RecurrentTokenSuccess') ->
    {struct, struct, [
    {1, required, string, 'token', undefined}
]};

struct_info('RecurrentTokenCallbackResult') ->
    {struct, struct, [
    {1, required, string, 'response', undefined},
    {2, required, {struct, struct, {dmsl_proxy_provider_thrift, 'RecurrentTokenProxyResult'}}, 'result', undefined}
]};

struct_info('PaymentInfo') ->
    {struct, struct, [
    {1, required, {struct, struct, {dmsl_proxy_provider_thrift, 'Shop'}}, 'shop', undefined},
    {2, required, {struct, struct, {dmsl_proxy_provider_thrift, 'Invoice'}}, 'invoice', undefined},
    {3, required, {struct, struct, {dmsl_proxy_provider_thrift, 'InvoicePayment'}}, 'payment', undefined},
    {4, optional, {struct, struct, {dmsl_proxy_provider_thrift, 'InvoicePaymentRefund'}}, 'refund', undefined},
    {5, optional, {struct, struct, {dmsl_proxy_provider_thrift, 'InvoicePaymentCapture'}}, 'capture', undefined}
]};

struct_info('Shop') ->
    {struct, struct, [
    {1, required, string, 'id', undefined},
    {2, required, {struct, struct, {dmsl_domain_thrift, 'Category'}}, 'category', undefined},
    {3, required, {struct, struct, {dmsl_domain_thrift, 'ShopDetails'}}, 'details', undefined},
    {4, required, {struct, union, {dmsl_domain_thrift, 'ShopLocation'}}, 'location', undefined}
]};

struct_info('Invoice') ->
    {struct, struct, [
    {1, required, string, 'id', undefined},
    {2, required, string, 'created_at', undefined},
    {3, required, string, 'due', undefined},
    {7, required, {struct, struct, {dmsl_domain_thrift, 'InvoiceDetails'}}, 'details', undefined},
    {6, required, {struct, struct, {dmsl_proxy_provider_thrift, 'Cash'}}, 'cost', undefined}
]};

struct_info('PaymentResource') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_domain_thrift, 'DisposablePaymentResource'}}, 'disposable_payment_resource', undefined},
    {2, optional, {struct, struct, {dmsl_proxy_provider_thrift, 'RecurrentPaymentResource'}}, 'recurrent_payment_resource', undefined}
]};

struct_info('RecurrentPaymentResource') ->
    {struct, struct, [
    {1, required, {struct, union, {dmsl_domain_thrift, 'PaymentTool'}}, 'payment_tool', undefined},
    {2, required, string, 'rec_token', undefined}
]};

struct_info('InvoicePayment') ->
    {struct, struct, [
    {1, required, string, 'id', undefined},
    {2, required, string, 'created_at', undefined},
    {3, optional, {struct, struct, {dmsl_domain_thrift, 'TransactionInfo'}}, 'trx', undefined},
    {6, required, {struct, union, {dmsl_proxy_provider_thrift, 'PaymentResource'}}, 'payment_resource', undefined},
    {5, required, {struct, struct, {dmsl_proxy_provider_thrift, 'Cash'}}, 'cost', undefined},
    {7, required, {struct, struct, {dmsl_domain_thrift, 'ContactInfo'}}, 'contact_info', undefined},
    {8, optional, bool, 'make_recurrent', undefined},
    {9, optional, string, 'processing_deadline', undefined}
]};

struct_info('InvoicePaymentRefund') ->
    {struct, struct, [
    {1, required, string, 'id', undefined},
    {2, required, string, 'created_at', undefined},
    {4, required, {struct, struct, {dmsl_proxy_provider_thrift, 'Cash'}}, 'cash', undefined},
    {3, optional, {struct, struct, {dmsl_domain_thrift, 'TransactionInfo'}}, 'trx', undefined}
]};

struct_info('InvoicePaymentCapture') ->
    {struct, struct, [
    {1, required, {struct, struct, {dmsl_proxy_provider_thrift, 'Cash'}}, 'cost', undefined}
]};

struct_info('Cash') ->
    {struct, struct, [
    {1, required, i64, 'amount', undefined},
    {2, required, {struct, struct, {dmsl_domain_thrift, 'Currency'}}, 'currency', undefined}
]};

struct_info('Session') ->
    {struct, struct, [
    {1, required, {struct, union, {dmsl_domain_thrift, 'TargetInvoicePaymentStatus'}}, 'target', undefined},
    {2, optional, string, 'state', undefined}
]};

struct_info('PaymentContext') ->
    {struct, struct, [
    {1, required, {struct, struct, {dmsl_proxy_provider_thrift, 'Session'}}, 'session', undefined},
    {2, required, {struct, struct, {dmsl_proxy_provider_thrift, 'PaymentInfo'}}, 'payment_info', undefined},
    {3, optional, {map, string, string}, 'options', #{}}
]};

struct_info('PaymentProxyResult') ->
    {struct, struct, [
    {1, required, {struct, union, {dmsl_proxy_provider_thrift, 'Intent'}}, 'intent', undefined},
    {2, optional, string, 'next_state', undefined},
    {3, optional, {struct, struct, {dmsl_domain_thrift, 'TransactionInfo'}}, 'trx', undefined}
]};

struct_info('PaymentCallbackResult') ->
    {struct, struct, [
    {1, required, string, 'response', undefined},
    {2, required, {struct, struct, {dmsl_proxy_provider_thrift, 'PaymentCallbackProxyResult'}}, 'result', undefined}
]};

struct_info('PaymentCallbackProxyResult') ->
    {struct, struct, [
    {1, optional, {struct, union, {dmsl_proxy_provider_thrift, 'Intent'}}, 'intent', undefined},
    {2, optional, string, 'next_state', undefined},
    {3, optional, {struct, struct, {dmsl_domain_thrift, 'TransactionInfo'}}, 'trx', undefined}
]};

struct_info('PaymentNotFound') ->
    {struct, exception, []};

struct_info(_) -> erlang:error(badarg).

-spec record_name(struct_name() | exception_name()) -> atom() | no_return().

record_name('FinishIntent') ->
    'prxprv_FinishIntent';

record_name('Success') ->
    'prxprv_Success';

    record_name('SleepIntent') ->
    'prxprv_SleepIntent';

    record_name('SuspendIntent') ->
    'prxprv_SuspendIntent';

    record_name('RecurrentPaymentTool') ->
    'prxprv_RecurrentPaymentTool';

    record_name('RecurrentTokenInfo') ->
    'prxprv_RecurrentTokenInfo';

    record_name('RecurrentTokenSession') ->
    'prxprv_RecurrentTokenSession';

    record_name('RecurrentTokenContext') ->
    'prxprv_RecurrentTokenContext';

    record_name('RecurrentTokenProxyResult') ->
    'prxprv_RecurrentTokenProxyResult';

    record_name('RecurrentTokenFinishIntent') ->
    'prxprv_RecurrentTokenFinishIntent';

    record_name('RecurrentTokenSuccess') ->
    'prxprv_RecurrentTokenSuccess';

    record_name('RecurrentTokenCallbackResult') ->
    'prxprv_RecurrentTokenCallbackResult';

    record_name('PaymentInfo') ->
    'prxprv_PaymentInfo';

    record_name('Shop') ->
    'prxprv_Shop';

    record_name('Invoice') ->
    'prxprv_Invoice';

    record_name('RecurrentPaymentResource') ->
    'prxprv_RecurrentPaymentResource';

    record_name('InvoicePayment') ->
    'prxprv_InvoicePayment';

    record_name('InvoicePaymentRefund') ->
    'prxprv_InvoicePaymentRefund';

    record_name('InvoicePaymentCapture') ->
    'prxprv_InvoicePaymentCapture';

    record_name('Cash') ->
    'prxprv_Cash';

    record_name('Session') ->
    'prxprv_Session';

    record_name('PaymentContext') ->
    'prxprv_PaymentContext';

    record_name('PaymentProxyResult') ->
    'prxprv_PaymentProxyResult';

    record_name('PaymentCallbackResult') ->
    'prxprv_PaymentCallbackResult';

    record_name('PaymentCallbackProxyResult') ->
    'prxprv_PaymentCallbackProxyResult';

    record_name('PaymentNotFound') ->
    'prxprv_PaymentNotFound';

    record_name(_) -> error(badarg).
    
    -spec functions(service_name()) -> [function_name()] | no_return().

functions('ProviderProxy') ->
    [
        'GenerateToken',
        'HandleRecurrentTokenCallback',
        'ProcessPayment',
        'HandlePaymentCallback'
    ];

functions('ProviderProxyHost') ->
    [
        'ProcessPaymentCallback',
        'ProcessRecurrentTokenCallback',
        'GetPayment'
    ];

functions(_) -> error(badarg).

-spec function_info(service_name(), function_name(), params_type | reply_type | exceptions) ->
    struct_info() | no_return().

function_info('ProviderProxy', 'GenerateToken', params_type) ->
    {struct, struct, [
    {1, undefined, {struct, struct, {dmsl_proxy_provider_thrift, 'RecurrentTokenContext'}}, 'context', undefined}
]};
function_info('ProviderProxy', 'GenerateToken', reply_type) ->
        {struct, struct, {dmsl_proxy_provider_thrift, 'RecurrentTokenProxyResult'}};
    function_info('ProviderProxy', 'GenerateToken', exceptions) ->
        {struct, struct, []};
function_info('ProviderProxy', 'HandleRecurrentTokenCallback', params_type) ->
    {struct, struct, [
    {1, undefined, string, 'callback', undefined},
    {2, undefined, {struct, struct, {dmsl_proxy_provider_thrift, 'RecurrentTokenContext'}}, 'context', undefined}
]};
function_info('ProviderProxy', 'HandleRecurrentTokenCallback', reply_type) ->
        {struct, struct, {dmsl_proxy_provider_thrift, 'RecurrentTokenCallbackResult'}};
    function_info('ProviderProxy', 'HandleRecurrentTokenCallback', exceptions) ->
        {struct, struct, []};
function_info('ProviderProxy', 'ProcessPayment', params_type) ->
    {struct, struct, [
    {1, undefined, {struct, struct, {dmsl_proxy_provider_thrift, 'PaymentContext'}}, 'context', undefined}
]};
function_info('ProviderProxy', 'ProcessPayment', reply_type) ->
        {struct, struct, {dmsl_proxy_provider_thrift, 'PaymentProxyResult'}};
    function_info('ProviderProxy', 'ProcessPayment', exceptions) ->
        {struct, struct, []};
function_info('ProviderProxy', 'HandlePaymentCallback', params_type) ->
    {struct, struct, [
    {1, undefined, string, 'callback', undefined},
    {2, undefined, {struct, struct, {dmsl_proxy_provider_thrift, 'PaymentContext'}}, 'context', undefined}
]};
function_info('ProviderProxy', 'HandlePaymentCallback', reply_type) ->
        {struct, struct, {dmsl_proxy_provider_thrift, 'PaymentCallbackResult'}};
    function_info('ProviderProxy', 'HandlePaymentCallback', exceptions) ->
        {struct, struct, []};

function_info('ProviderProxyHost', 'ProcessPaymentCallback', params_type) ->
    {struct, struct, [
    {1, undefined, string, 'tag', undefined},
    {2, undefined, string, 'callback', undefined}
]};
function_info('ProviderProxyHost', 'ProcessPaymentCallback', reply_type) ->
        string;
    function_info('ProviderProxyHost', 'ProcessPaymentCallback', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_base_thrift, 'InvalidRequest'}}, 'ex1', undefined}
    ]};
function_info('ProviderProxyHost', 'ProcessRecurrentTokenCallback', params_type) ->
    {struct, struct, [
    {1, undefined, string, 'tag', undefined},
    {2, undefined, string, 'callback', undefined}
]};
function_info('ProviderProxyHost', 'ProcessRecurrentTokenCallback', reply_type) ->
        string;
    function_info('ProviderProxyHost', 'ProcessRecurrentTokenCallback', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_base_thrift, 'InvalidRequest'}}, 'ex1', undefined}
    ]};
function_info('ProviderProxyHost', 'GetPayment', params_type) ->
    {struct, struct, [
    {1, undefined, string, 'tag', undefined}
]};
function_info('ProviderProxyHost', 'GetPayment', reply_type) ->
        {struct, struct, {dmsl_proxy_provider_thrift, 'PaymentInfo'}};
    function_info('ProviderProxyHost', 'GetPayment', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_proxy_provider_thrift, 'PaymentNotFound'}}, 'ex1', undefined}
    ]};

function_info(_Service, _Function, _InfoType) -> erlang:error(badarg).
