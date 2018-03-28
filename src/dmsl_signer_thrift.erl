%%
%% Autogenerated by Thrift Compiler (1.0.0-dev)
%%
%% DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
%%

-module(dmsl_signer_thrift).

-include("dmsl_signer_thrift.hrl").

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


-type namespace() :: 'signer'.

%%
%% typedefs
%%
-type typedef_name() :: none().


%%
%% enums
%%
-type enum_name() :: none().

%%
%% structs, unions and exceptions
%%
-type struct_name() :: none().

-type exception_name() :: none().

%%
%% services and functions
%%
-type service_name() ::
    'Signer'.

-type function_name() ::
    'Signer_service_functions'().

-type 'Signer_service_functions'() ::
    'sign'.

-export_type(['Signer_service_functions'/0]).


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

-spec typedefs() -> [].

typedefs() ->
    [].

-spec enums() -> [].

enums() ->
    [].

-spec structs() -> [].

structs() ->
    [].

-spec services() -> [service_name()].

services() ->
    [
        'Signer'
    ].

-spec namespace() -> namespace().

namespace() ->
    'signer'.

-spec typedef_info(_) -> no_return().

typedef_info(_) -> erlang:error(badarg).

-spec enum_info(_) -> no_return().

enum_info(_) -> erlang:error(badarg).

-spec struct_info(_) -> no_return().

struct_info(_) -> erlang:error(badarg).

-spec record_name(_) -> no_return().

record_name(_) -> error(badarg).

-spec functions(service_name()) -> [function_name()] | no_return().

functions('Signer') ->
    [
        'sign'
    ];

functions(_) -> error(badarg).

-spec function_info(service_name(), function_name(), params_type | reply_type | exceptions) ->
    struct_info() | no_return().

function_info('Signer', 'sign', params_type) ->
    {struct, struct, [
    {1, undefined, string, 'data', undefined}
]};
function_info('Signer', 'sign', reply_type) ->
        string;
    function_info('Signer', 'sign', exceptions) ->
        {struct, struct, []};

function_info(_Service, _Function, _InfoType) -> erlang:error(badarg).
