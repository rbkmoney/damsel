%%
%% Autogenerated by Thrift Compiler (1.0.0-dev)
%%
%% DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
%%

-module(dmsl_payout_processing_thrift).

-include("dmsl_payout_processing_thrift.hrl").

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
    'PayoutID'/0,
    'Events'/0,
    'UserID'/0
]).
-export_type([
    'UserInfo'/0,
    'UserType'/0,
    'InternalUser'/0,
    'ExternalUser'/0,
    'ServiceUser'/0,
    'Event'/0,
    'EventSource'/0,
    'EventPayload'/0,
    'PayoutChange'/0,
    'PayoutCreated'/0,
    'Payout'/0,
    'PayoutStatus'/0,
    'PayoutUnpaid'/0,
    'PayoutPaid'/0,
    'PaidDetails'/0,
    'CardPaidDetails'/0,
    'ProviderDetails'/0,
    'AccountPaidDetails'/0,
    'PayoutCancelled'/0,
    'PayoutConfirmed'/0,
    'PayoutType'/0,
    'CardPayout'/0,
    'AccountPayout'/0,
    'PayoutStatusChanged'/0,
    'EventRange'/0,
    'Pay2CardParams'/0,
    'TimeRange'/0,
    'GeneratePayoutParams'/0
]).
-export_type([
    'NoLastEvent'/0,
    'EventNotFound'/0,
    'InsufficientFunds'/0,
    'LimitExceeded'/0
]).

-type namespace() :: 'payout_processing'.

%%
%% typedefs
%%
-type typedef_name() ::
    'PayoutID' |
    'Events' |
    'UserID'.

-type 'PayoutID'() :: dmsl_base_thrift:'ID'().
-type 'Events'() :: ['Event'()].
-type 'UserID'() :: dmsl_base_thrift:'ID'().

%%
%% enums
%%
-type enum_name() :: none().

%%
%% structs, unions and exceptions
%%
-type struct_name() ::
    'UserInfo' |
    'UserType' |
    'InternalUser' |
    'ExternalUser' |
    'ServiceUser' |
    'Event' |
    'EventSource' |
    'EventPayload' |
    'PayoutChange' |
    'PayoutCreated' |
    'Payout' |
    'PayoutStatus' |
    'PayoutUnpaid' |
    'PayoutPaid' |
    'PaidDetails' |
    'CardPaidDetails' |
    'ProviderDetails' |
    'AccountPaidDetails' |
    'PayoutCancelled' |
    'PayoutConfirmed' |
    'PayoutType' |
    'CardPayout' |
    'AccountPayout' |
    'PayoutStatusChanged' |
    'EventRange' |
    'Pay2CardParams' |
    'TimeRange' |
    'GeneratePayoutParams'.

-type exception_name() ::
    'NoLastEvent' |
    'EventNotFound' |
    'InsufficientFunds' |
    'LimitExceeded'.

%% struct 'UserInfo'
-type 'UserInfo'() :: #'payout_processing_UserInfo'{}.

%% union 'UserType'
-type 'UserType'() ::
    {'internal_user', 'InternalUser'()} |
    {'external_user', 'ExternalUser'()} |
    {'service_user', 'ServiceUser'()}.

%% struct 'InternalUser'
-type 'InternalUser'() :: #'payout_processing_InternalUser'{}.

%% struct 'ExternalUser'
-type 'ExternalUser'() :: #'payout_processing_ExternalUser'{}.

%% struct 'ServiceUser'
-type 'ServiceUser'() :: #'payout_processing_ServiceUser'{}.

%% struct 'Event'
-type 'Event'() :: #'payout_processing_Event'{}.

%% union 'EventSource'
-type 'EventSource'() ::
    {'payout_id', 'PayoutID'()}.

%% union 'EventPayload'
-type 'EventPayload'() ::
    {'payout_changes', ['PayoutChange'()]}.

%% union 'PayoutChange'
-type 'PayoutChange'() ::
    {'payout_created', 'PayoutCreated'()} |
    {'payout_status_changed', 'PayoutStatusChanged'()}.

%% struct 'PayoutCreated'
-type 'PayoutCreated'() :: #'payout_processing_PayoutCreated'{}.

%% struct 'Payout'
-type 'Payout'() :: #'payout_processing_Payout'{}.

%% union 'PayoutStatus'
-type 'PayoutStatus'() ::
    {'unpaid', 'PayoutUnpaid'()} |
    {'paid', 'PayoutPaid'()} |
    {'cancelled', 'PayoutCancelled'()} |
    {'confirmed', 'PayoutConfirmed'()}.

%% struct 'PayoutUnpaid'
-type 'PayoutUnpaid'() :: #'payout_processing_PayoutUnpaid'{}.

%% struct 'PayoutPaid'
-type 'PayoutPaid'() :: #'payout_processing_PayoutPaid'{}.

%% union 'PaidDetails'
-type 'PaidDetails'() ::
    {'card_details', 'CardPaidDetails'()} |
    {'account_details', 'AccountPaidDetails'()}.

%% struct 'CardPaidDetails'
-type 'CardPaidDetails'() :: #'payout_processing_CardPaidDetails'{}.

%% struct 'ProviderDetails'
-type 'ProviderDetails'() :: #'payout_processing_ProviderDetails'{}.

%% struct 'AccountPaidDetails'
-type 'AccountPaidDetails'() :: #'payout_processing_AccountPaidDetails'{}.

%% struct 'PayoutCancelled'
-type 'PayoutCancelled'() :: #'payout_processing_PayoutCancelled'{}.

%% struct 'PayoutConfirmed'
-type 'PayoutConfirmed'() :: #'payout_processing_PayoutConfirmed'{}.

%% union 'PayoutType'
-type 'PayoutType'() ::
    {'card_payout', 'CardPayout'()} |
    {'account_payout', 'AccountPayout'()}.

%% struct 'CardPayout'
-type 'CardPayout'() :: #'payout_processing_CardPayout'{}.

%% struct 'AccountPayout'
-type 'AccountPayout'() :: #'payout_processing_AccountPayout'{}.

%% struct 'PayoutStatusChanged'
-type 'PayoutStatusChanged'() :: #'payout_processing_PayoutStatusChanged'{}.

%% struct 'EventRange'
-type 'EventRange'() :: #'payout_processing_EventRange'{}.

%% struct 'Pay2CardParams'
-type 'Pay2CardParams'() :: #'payout_processing_Pay2CardParams'{}.

%% struct 'TimeRange'
-type 'TimeRange'() :: #'payout_processing_TimeRange'{}.

%% struct 'GeneratePayoutParams'
-type 'GeneratePayoutParams'() :: #'payout_processing_GeneratePayoutParams'{}.

%% exception 'NoLastEvent'
-type 'NoLastEvent'() :: #'payout_processing_NoLastEvent'{}.

%% exception 'EventNotFound'
-type 'EventNotFound'() :: #'payout_processing_EventNotFound'{}.

%% exception 'InsufficientFunds'
-type 'InsufficientFunds'() :: #'payout_processing_InsufficientFunds'{}.

%% exception 'LimitExceeded'
-type 'LimitExceeded'() :: #'payout_processing_LimitExceeded'{}.

%%
%% services and functions
%%
-type service_name() ::
    'EventSink' |
    'PayoutManagement'.

-type function_name() ::
    'EventSink_service_functions'() |
    'PayoutManagement_service_functions'().

-type 'EventSink_service_functions'() ::
    'GetEvents' |
    'GetLastEventID'.

-export_type(['EventSink_service_functions'/0]).

-type 'PayoutManagement_service_functions'() ::
    'GetFee' |
    'Pay2Card' |
    'GeneratePayout' |
    'ConfirmPayouts' |
    'CancelPayouts'.

-export_type(['PayoutManagement_service_functions'/0]).


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
        'PayoutID',
        'Events',
        'UserID'
    ].

-spec enums() -> [].

enums() ->
    [].

-spec structs() -> [struct_name()].

structs() ->
    [
        'UserInfo',
        'UserType',
        'InternalUser',
        'ExternalUser',
        'ServiceUser',
        'Event',
        'EventSource',
        'EventPayload',
        'PayoutChange',
        'PayoutCreated',
        'Payout',
        'PayoutStatus',
        'PayoutUnpaid',
        'PayoutPaid',
        'PaidDetails',
        'CardPaidDetails',
        'ProviderDetails',
        'AccountPaidDetails',
        'PayoutCancelled',
        'PayoutConfirmed',
        'PayoutType',
        'CardPayout',
        'AccountPayout',
        'PayoutStatusChanged',
        'EventRange',
        'Pay2CardParams',
        'TimeRange',
        'GeneratePayoutParams'
    ].

-spec services() -> [service_name()].

services() ->
    [
        'EventSink',
        'PayoutManagement'
    ].

-spec namespace() -> namespace().

namespace() ->
    'payout_processing'.

-spec typedef_info(typedef_name()) -> field_type() | no_return().

typedef_info('PayoutID') ->
    string;

typedef_info('Events') ->
    {list, {struct, struct, {dmsl_payout_processing_thrift, 'Event'}}};

typedef_info('UserID') ->
    string;

typedef_info(_) -> erlang:error(badarg).

-spec enum_info(_) -> no_return().

enum_info(_) -> erlang:error(badarg).

-spec struct_info(struct_name() | exception_name()) -> struct_info() | no_return().

struct_info('UserInfo') ->
    {struct, struct, [
    {1, required, string, 'id', undefined},
    {2, required, {struct, union, {dmsl_payout_processing_thrift, 'UserType'}}, 'type', undefined}
]};

struct_info('UserType') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_payout_processing_thrift, 'InternalUser'}}, 'internal_user', undefined},
    {2, optional, {struct, struct, {dmsl_payout_processing_thrift, 'ExternalUser'}}, 'external_user', undefined},
    {3, optional, {struct, struct, {dmsl_payout_processing_thrift, 'ServiceUser'}}, 'service_user', undefined}
]};

struct_info('InternalUser') ->
    {struct, struct, []};

struct_info('ExternalUser') ->
    {struct, struct, []};

struct_info('ServiceUser') ->
    {struct, struct, []};

struct_info('Event') ->
    {struct, struct, [
    {1, required, i64, 'id', undefined},
    {2, required, string, 'created_at', undefined},
    {3, required, {struct, union, {dmsl_payout_processing_thrift, 'EventSource'}}, 'source', undefined},
    {4, required, {struct, union, {dmsl_payout_processing_thrift, 'EventPayload'}}, 'payload', undefined}
]};

struct_info('EventSource') ->
    {struct, union, [
    {1, optional, string, 'payout_id', undefined}
]};

struct_info('EventPayload') ->
    {struct, union, [
    {1, optional, {list, {struct, union, {dmsl_payout_processing_thrift, 'PayoutChange'}}}, 'payout_changes', undefined}
]};

struct_info('PayoutChange') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_payout_processing_thrift, 'PayoutCreated'}}, 'payout_created', undefined},
    {2, optional, {struct, struct, {dmsl_payout_processing_thrift, 'PayoutStatusChanged'}}, 'payout_status_changed', undefined}
]};

struct_info('PayoutCreated') ->
    {struct, struct, [
    {1, required, {struct, struct, {dmsl_payout_processing_thrift, 'Payout'}}, 'payout', undefined},
    {2, required, {struct, struct, {dmsl_payout_processing_thrift, 'UserInfo'}}, 'initiator', undefined}
]};

struct_info('Payout') ->
    {struct, struct, [
    {1, required, string, 'id', undefined},
    {2, required, string, 'party_id', undefined},
    {3, required, string, 'shop_id', undefined},
    {4, required, string, 'created_at', undefined},
    {5, required, {struct, union, {dmsl_payout_processing_thrift, 'PayoutStatus'}}, 'status', undefined},
    {6, required, {list, {struct, struct, {dmsl_domain_thrift, 'FinalCashFlowPosting'}}}, 'payout_flow', undefined},
    {7, required, {struct, union, {dmsl_payout_processing_thrift, 'PayoutType'}}, 'payout_type', undefined}
]};

struct_info('PayoutStatus') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_payout_processing_thrift, 'PayoutUnpaid'}}, 'unpaid', undefined},
    {2, optional, {struct, struct, {dmsl_payout_processing_thrift, 'PayoutPaid'}}, 'paid', undefined},
    {3, optional, {struct, struct, {dmsl_payout_processing_thrift, 'PayoutCancelled'}}, 'cancelled', undefined},
    {4, optional, {struct, struct, {dmsl_payout_processing_thrift, 'PayoutConfirmed'}}, 'confirmed', undefined}
]};

struct_info('PayoutUnpaid') ->
    {struct, struct, []};

struct_info('PayoutPaid') ->
    {struct, struct, [
    {1, required, {struct, union, {dmsl_payout_processing_thrift, 'PaidDetails'}}, 'details', undefined}
]};

struct_info('PaidDetails') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_payout_processing_thrift, 'CardPaidDetails'}}, 'card_details', undefined},
    {2, optional, {struct, struct, {dmsl_payout_processing_thrift, 'AccountPaidDetails'}}, 'account_details', undefined}
]};

struct_info('CardPaidDetails') ->
    {struct, struct, [
    {1, required, string, 'mask_pan', undefined},
    {2, required, {struct, struct, {dmsl_payout_processing_thrift, 'ProviderDetails'}}, 'provider_details', undefined}
]};

struct_info('ProviderDetails') ->
    {struct, struct, [
    {1, required, string, 'name', undefined},
    {2, required, string, 'transaction_id', undefined}
]};

struct_info('AccountPaidDetails') ->
    {struct, struct, []};

struct_info('PayoutCancelled') ->
    {struct, struct, [
    {1, required, {struct, struct, {dmsl_payout_processing_thrift, 'UserInfo'}}, 'user_info', undefined},
    {2, required, string, 'details', undefined}
]};

struct_info('PayoutConfirmed') ->
    {struct, struct, [
    {1, required, {struct, struct, {dmsl_payout_processing_thrift, 'UserInfo'}}, 'user_info', undefined}
]};

struct_info('PayoutType') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_payout_processing_thrift, 'CardPayout'}}, 'card_payout', undefined},
    {2, optional, {struct, struct, {dmsl_payout_processing_thrift, 'AccountPayout'}}, 'account_payout', undefined}
]};

struct_info('CardPayout') ->
    {struct, struct, [
    {1, required, string, 'request_id', undefined},
    {2, optional, string, 'card_token', undefined}
]};

struct_info('AccountPayout') ->
    {struct, struct, [
    {1, required, string, 'account', undefined},
    {2, required, string, 'bank_corr_account', undefined},
    {3, required, string, 'bank_bik', undefined},
    {4, required, string, 'inn', undefined},
    {5, required, string, 'purpose', undefined}
]};

struct_info('PayoutStatusChanged') ->
    {struct, struct, [
    {1, required, {struct, union, {dmsl_payout_processing_thrift, 'PayoutStatus'}}, 'status', undefined}
]};

struct_info('EventRange') ->
    {struct, struct, [
    {1, optional, i64, 'after', undefined},
    {2, required, i32, 'limit', undefined}
]};

struct_info('Pay2CardParams') ->
    {struct, struct, [
    {1, required, {struct, struct, {dmsl_domain_thrift, 'BankCard'}}, 'bank_card', undefined},
    {2, required, string, 'party_id', undefined},
    {3, required, string, 'shop_id', undefined},
    {4, required, {struct, struct, {dmsl_domain_thrift, 'Cash'}}, 'sum', undefined}
]};

struct_info('TimeRange') ->
    {struct, struct, [
    {1, required, string, 'from_time', undefined},
    {2, optional, string, 'to_time', undefined}
]};

struct_info('GeneratePayoutParams') ->
    {struct, struct, [
    {1, required, {struct, struct, {dmsl_payout_processing_thrift, 'TimeRange'}}, 'time_range', undefined},
    {2, required, string, 'party_id', undefined},
    {3, required, string, 'shop_id', undefined}
]};

struct_info('NoLastEvent') ->
    {struct, exception, []};

struct_info('EventNotFound') ->
    {struct, exception, []};

struct_info('InsufficientFunds') ->
    {struct, exception, []};

struct_info('LimitExceeded') ->
    {struct, exception, []};

struct_info(_) -> erlang:error(badarg).

-spec record_name(struct_name() | exception_name()) -> atom() | no_return().

record_name('UserInfo') ->
    'payout_processing_UserInfo';

record_name('InternalUser') ->
    'payout_processing_InternalUser';

    record_name('ExternalUser') ->
    'payout_processing_ExternalUser';

    record_name('ServiceUser') ->
    'payout_processing_ServiceUser';

    record_name('Event') ->
    'payout_processing_Event';

    record_name('PayoutCreated') ->
    'payout_processing_PayoutCreated';

    record_name('Payout') ->
    'payout_processing_Payout';

    record_name('PayoutUnpaid') ->
    'payout_processing_PayoutUnpaid';

    record_name('PayoutPaid') ->
    'payout_processing_PayoutPaid';

    record_name('CardPaidDetails') ->
    'payout_processing_CardPaidDetails';

    record_name('ProviderDetails') ->
    'payout_processing_ProviderDetails';

    record_name('AccountPaidDetails') ->
    'payout_processing_AccountPaidDetails';

    record_name('PayoutCancelled') ->
    'payout_processing_PayoutCancelled';

    record_name('PayoutConfirmed') ->
    'payout_processing_PayoutConfirmed';

    record_name('CardPayout') ->
    'payout_processing_CardPayout';

    record_name('AccountPayout') ->
    'payout_processing_AccountPayout';

    record_name('PayoutStatusChanged') ->
    'payout_processing_PayoutStatusChanged';

    record_name('EventRange') ->
    'payout_processing_EventRange';

    record_name('Pay2CardParams') ->
    'payout_processing_Pay2CardParams';

    record_name('TimeRange') ->
    'payout_processing_TimeRange';

    record_name('GeneratePayoutParams') ->
    'payout_processing_GeneratePayoutParams';

    record_name('NoLastEvent') ->
    'payout_processing_NoLastEvent';

    record_name('EventNotFound') ->
    'payout_processing_EventNotFound';

    record_name('InsufficientFunds') ->
    'payout_processing_InsufficientFunds';

    record_name('LimitExceeded') ->
    'payout_processing_LimitExceeded';

    record_name(_) -> error(badarg).
    
    -spec functions(service_name()) -> [function_name()] | no_return().

functions('EventSink') ->
    [
        'GetEvents',
        'GetLastEventID'
    ];

functions('PayoutManagement') ->
    [
        'GetFee',
        'Pay2Card',
        'GeneratePayout',
        'ConfirmPayouts',
        'CancelPayouts'
    ];

functions(_) -> error(badarg).

-spec function_info(service_name(), function_name(), params_type | reply_type | exceptions) ->
    struct_info() | no_return().

function_info('EventSink', 'GetEvents', params_type) ->
    {struct, struct, [
    {1, undefined, {struct, struct, {dmsl_payout_processing_thrift, 'EventRange'}}, 'range', undefined}
]};
function_info('EventSink', 'GetEvents', reply_type) ->
        {list, {struct, struct, {dmsl_payout_processing_thrift, 'Event'}}};
    function_info('EventSink', 'GetEvents', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_payout_processing_thrift, 'EventNotFound'}}, 'ex1', undefined},
        {2, undefined, {struct, exception, {dmsl_base_thrift, 'InvalidRequest'}}, 'ex2', undefined}
    ]};
function_info('EventSink', 'GetLastEventID', params_type) ->
    {struct, struct, []};
function_info('EventSink', 'GetLastEventID', reply_type) ->
        i64;
    function_info('EventSink', 'GetLastEventID', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_payout_processing_thrift, 'NoLastEvent'}}, 'ex1', undefined}
    ]};

function_info('PayoutManagement', 'GetFee', params_type) ->
    {struct, struct, [
    {1, undefined, {struct, struct, {dmsl_payout_processing_thrift, 'Pay2CardParams'}}, 'params', undefined}
]};
function_info('PayoutManagement', 'GetFee', reply_type) ->
        {struct, struct, {dmsl_domain_thrift, 'Cash'}};
    function_info('PayoutManagement', 'GetFee', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_base_thrift, 'InvalidRequest'}}, 'ex1', undefined}
    ]};
function_info('PayoutManagement', 'Pay2Card', params_type) ->
    {struct, struct, [
    {1, required, string, 'request_id', undefined},
    {2, undefined, {struct, struct, {dmsl_payout_processing_thrift, 'Pay2CardParams'}}, 'params', undefined}
]};
function_info('PayoutManagement', 'Pay2Card', reply_type) ->
        string;
    function_info('PayoutManagement', 'Pay2Card', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_base_thrift, 'InvalidRequest'}}, 'ex1', undefined},
        {2, undefined, {struct, exception, {dmsl_payout_processing_thrift, 'InsufficientFunds'}}, 'ex2', undefined},
        {3, undefined, {struct, exception, {dmsl_payout_processing_thrift, 'LimitExceeded'}}, 'ex3', undefined}
    ]};
function_info('PayoutManagement', 'GeneratePayout', params_type) ->
    {struct, struct, [
    {1, undefined, {struct, struct, {dmsl_payout_processing_thrift, 'GeneratePayoutParams'}}, 'params', undefined}
]};
function_info('PayoutManagement', 'GeneratePayout', reply_type) ->
        string;
    function_info('PayoutManagement', 'GeneratePayout', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_base_thrift, 'InvalidRequest'}}, 'ex1', undefined}
    ]};
function_info('PayoutManagement', 'ConfirmPayouts', params_type) ->
    {struct, struct, [
    {1, undefined, {list, string}, 'payout_ids', undefined}
]};
function_info('PayoutManagement', 'ConfirmPayouts', reply_type) ->
        {list, string};
    function_info('PayoutManagement', 'ConfirmPayouts', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_base_thrift, 'InvalidRequest'}}, 'ex1', undefined}
    ]};
function_info('PayoutManagement', 'CancelPayouts', params_type) ->
    {struct, struct, [
    {1, undefined, {list, string}, 'payout_ids', undefined}
]};
function_info('PayoutManagement', 'CancelPayouts', reply_type) ->
        {list, string};
    function_info('PayoutManagement', 'CancelPayouts', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_base_thrift, 'InvalidRequest'}}, 'ex1', undefined}
    ]};

function_info(_Service, _Function, _InfoType) -> erlang:error(badarg).
