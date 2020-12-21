%%
%% Autogenerated by Thrift Compiler (1.0.0-dev)
%%
%% DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
%%

-module(dmsl_proto_limiter_thrift).

-include("dmsl_proto_limiter_thrift.hrl").

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
    'LimitChangeID'/0,
    'LimitID'/0
]).
-export_type([
    'Limit'/0,
    'LimitChange'/0
]).
-export_type([
    'LimitNotFound'/0,
    'LimitChangeNotFound'/0,
    'InconsistentLimitCurrency'/0,
    'ForbiddenOperationAmount'/0
]).

-type namespace() :: 'proto_limiter'.

%%
%% typedefs
%%
-type typedef_name() ::
    'LimitChangeID' |
    'LimitID'.

-type 'LimitChangeID'() :: dmsl_base_thrift:'ID'().
-type 'LimitID'() :: dmsl_domain_thrift:'TurnoverLimitID'().

%%
%% enums
%%
-type enum_name() :: none().

%%
%% structs, unions and exceptions
%%
-type struct_name() ::
    'Limit' |
    'LimitChange'.

-type exception_name() ::
    'LimitNotFound' |
    'LimitChangeNotFound' |
    'InconsistentLimitCurrency' |
    'ForbiddenOperationAmount'.

%% struct 'Limit'
-type 'Limit'() :: #'proto_limiter_Limit'{}.

%% struct 'LimitChange'
-type 'LimitChange'() :: #'proto_limiter_LimitChange'{}.

%% exception 'LimitNotFound'
-type 'LimitNotFound'() :: #'proto_limiter_LimitNotFound'{}.

%% exception 'LimitChangeNotFound'
-type 'LimitChangeNotFound'() :: #'proto_limiter_LimitChangeNotFound'{}.

%% exception 'InconsistentLimitCurrency'
-type 'InconsistentLimitCurrency'() :: #'proto_limiter_InconsistentLimitCurrency'{}.

%% exception 'ForbiddenOperationAmount'
-type 'ForbiddenOperationAmount'() :: #'proto_limiter_ForbiddenOperationAmount'{}.

%%
%% services and functions
%%
-type service_name() ::
    'Limiter'.

-type function_name() ::
    'Limiter_service_functions'().

-type 'Limiter_service_functions'() ::
    'Get' |
    'Hold' |
    'Commit' |
    'PartialCommit' |
    'Rollback'.

-export_type(['Limiter_service_functions'/0]).


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
        'LimitChangeID',
        'LimitID'
    ].

-spec enums() -> [].

enums() ->
    [].

-spec structs() -> [struct_name()].

structs() ->
    [
        'Limit',
        'LimitChange'
    ].

-spec services() -> [service_name()].

services() ->
    [
        'Limiter'
    ].

-spec namespace() -> namespace().

namespace() ->
    'proto_limiter'.

-spec typedef_info(typedef_name()) -> field_type() | no_return().

typedef_info('LimitChangeID') ->
    string;

typedef_info('LimitID') ->
    string;

typedef_info(_) -> erlang:error(badarg).

-spec enum_info(_) -> no_return().

enum_info(_) -> erlang:error(badarg).

-spec struct_info(struct_name() | exception_name()) -> struct_info() | no_return().

struct_info('Limit') ->
    {struct, struct, [
        {1, required, string, 'id', undefined},
        {2, required, {struct, struct, {dmsl_domain_thrift, 'Cash'}}, 'cash', undefined},
        {3, optional, string, 'creation_time', undefined},
        {4, optional, string, 'reload_time', undefined},
        {5, optional, string, 'description', undefined}
    ]};

struct_info('LimitChange') ->
    {struct, struct, [
        {1, required, string, 'id', undefined},
        {2, required, string, 'change_id', undefined},
        {3, required, {struct, struct, {dmsl_domain_thrift, 'Cash'}}, 'cash', undefined},
        {4, required, string, 'operation_timestamp', undefined}
    ]};

struct_info('LimitNotFound') ->
    {struct, exception, []};

struct_info('LimitChangeNotFound') ->
    {struct, exception, []};

struct_info('InconsistentLimitCurrency') ->
    {struct, exception, [
        {1, required, string, 'limit_currency', undefined},
        {2, required, string, 'change_currency', undefined}
    ]};

struct_info('ForbiddenOperationAmount') ->
    {struct, exception, [
        {1, required, {struct, struct, {dmsl_domain_thrift, 'Cash'}}, 'amount', undefined},
        {2, required, {struct, struct, {dmsl_domain_thrift, 'CashRange'}}, 'allowed_range', undefined}
    ]};

struct_info(_) -> erlang:error(badarg).

-spec record_name(struct_name() | exception_name()) -> atom() | no_return().

record_name('Limit') ->
    'proto_limiter_Limit';

record_name('LimitChange') ->
    'proto_limiter_LimitChange';

record_name('LimitNotFound') ->
    'proto_limiter_LimitNotFound';

record_name('LimitChangeNotFound') ->
    'proto_limiter_LimitChangeNotFound';

record_name('InconsistentLimitCurrency') ->
    'proto_limiter_InconsistentLimitCurrency';

record_name('ForbiddenOperationAmount') ->
    'proto_limiter_ForbiddenOperationAmount';

record_name(_) -> error(badarg).

-spec functions(service_name()) -> [function_name()] | no_return().

functions('Limiter') ->
    [
        'Get',
        'Hold',
        'Commit',
        'PartialCommit',
        'Rollback'
    ];

functions(_) -> error(badarg).

-spec function_info(service_name(), function_name(), params_type | reply_type | exceptions) ->
    struct_info() | no_return().

function_info('Limiter', 'Get', params_type) ->
    {struct, struct, [
        {1, undefined, string, 'id', undefined},
        {2, undefined, string, 'timestamp', undefined}
    ]};
function_info('Limiter', 'Get', reply_type) ->
    {struct, struct, {dmsl_proto_limiter_thrift, 'Limit'}};
function_info('Limiter', 'Get', exceptions) ->
    {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_proto_limiter_thrift, 'LimitNotFound'}}, 'e1', undefined},
        {2, undefined, {struct, exception, {dmsl_base_thrift, 'InvalidRequest'}}, 'e3', undefined}
    ]};
function_info('Limiter', 'Hold', params_type) ->
    {struct, struct, [
        {1, undefined, {struct, struct, {dmsl_proto_limiter_thrift, 'LimitChange'}}, 'change', undefined}
    ]};
function_info('Limiter', 'Hold', reply_type) ->
    {struct, struct, []};
function_info('Limiter', 'Hold', exceptions) ->
    {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_proto_limiter_thrift, 'LimitNotFound'}}, 'e1', undefined},
        {2, undefined, {struct, exception, {dmsl_proto_limiter_thrift, 'InconsistentLimitCurrency'}}, 'e2', undefined},
        {3, undefined, {struct, exception, {dmsl_base_thrift, 'InvalidRequest'}}, 'e3', undefined}
    ]};
function_info('Limiter', 'Commit', params_type) ->
    {struct, struct, [
        {1, undefined, {struct, struct, {dmsl_proto_limiter_thrift, 'LimitChange'}}, 'change', undefined}
    ]};
function_info('Limiter', 'Commit', reply_type) ->
    {struct, struct, []};
function_info('Limiter', 'Commit', exceptions) ->
    {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_proto_limiter_thrift, 'LimitNotFound'}}, 'e1', undefined},
        {2, undefined, {struct, exception, {dmsl_proto_limiter_thrift, 'LimitChangeNotFound'}}, 'e2', undefined},
        {3, undefined, {struct, exception, {dmsl_base_thrift, 'InvalidRequest'}}, 'e3', undefined}
    ]};
function_info('Limiter', 'PartialCommit', params_type) ->
    {struct, struct, [
        {1, undefined, {struct, struct, {dmsl_proto_limiter_thrift, 'LimitChange'}}, 'change', undefined}
    ]};
function_info('Limiter', 'PartialCommit', reply_type) ->
    {struct, struct, []};
function_info('Limiter', 'PartialCommit', exceptions) ->
    {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_proto_limiter_thrift, 'LimitNotFound'}}, 'e1', undefined},
        {2, undefined, {struct, exception, {dmsl_proto_limiter_thrift, 'LimitChangeNotFound'}}, 'e2', undefined},
        {3, undefined, {struct, exception, {dmsl_proto_limiter_thrift, 'ForbiddenOperationAmount'}}, 'e3', undefined},
        {4, undefined, {struct, exception, {dmsl_base_thrift, 'InvalidRequest'}}, 'e4', undefined}
    ]};
function_info('Limiter', 'Rollback', params_type) ->
    {struct, struct, [
        {1, undefined, {struct, struct, {dmsl_proto_limiter_thrift, 'LimitChange'}}, 'change', undefined}
    ]};
function_info('Limiter', 'Rollback', reply_type) ->
    {struct, struct, []};
function_info('Limiter', 'Rollback', exceptions) ->
    {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_proto_limiter_thrift, 'LimitNotFound'}}, 'e1', undefined},
        {2, undefined, {struct, exception, {dmsl_proto_limiter_thrift, 'LimitChangeNotFound'}}, 'e2', undefined},
        {3, undefined, {struct, exception, {dmsl_base_thrift, 'InvalidRequest'}}, 'e3', undefined}
    ]};

function_info(_Service, _Function, _InfoType) -> erlang:error(badarg).
