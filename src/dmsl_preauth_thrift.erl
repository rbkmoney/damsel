%%
%% Autogenerated by Thrift Compiler (1.0.0-dev)
%%
%% DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
%%

-module(dmsl_preauth_thrift).

-include("dmsl_preauth_thrift.hrl").

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
    'Status'/0,
    'Granted'/0,
    'Denied'/0,
    'Unavailable'/0,
    'State'/0,
    'State3DSecure'/0
]).

-type namespace() :: 'preauth'.

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
-type struct_name() ::
    'Status' |
    'Granted' |
    'Denied' |
    'Unavailable' |
    'State' |
    'State3DSecure'.

-type exception_name() :: none().

%% union 'Status'
-type 'Status'() ::
    {'granted', 'Granted'()} |
    {'denied', 'Denied'()} |
    {'unavailable', 'Unavailable'()}.

%% struct 'Granted'
-type 'Granted'() :: #'preauth_Granted'{}.

%% struct 'Denied'
-type 'Denied'() :: #'preauth_Denied'{}.

%% struct 'Unavailable'
-type 'Unavailable'() :: #'preauth_Unavailable'{}.

%% union 'State'
-type 'State'() ::
    {'state_3dsecure', 'State3DSecure'()}.

%% struct 'State3DSecure'
-type 'State3DSecure'() :: #'preauth_State3DSecure'{}.

%%
%% services and functions
%%
-type service_name() :: none().

-type function_name() :: none().


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

-spec structs() -> [struct_name()].

structs() ->
    [
        'Status',
        'Granted',
        'Denied',
        'Unavailable',
        'State',
        'State3DSecure'
    ].

-spec services() -> [].

services() ->
    [].

-spec namespace() -> namespace().

namespace() ->
    'preauth'.

-spec typedef_info(_) -> no_return().

typedef_info(_) -> erlang:error(badarg).

-spec enum_info(_) -> no_return().

enum_info(_) -> erlang:error(badarg).

-spec struct_info(struct_name() | exception_name()) -> struct_info() | no_return().

struct_info('Status') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_preauth_thrift, 'Granted'}}, 'granted', undefined},
    {2, optional, {struct, struct, {dmsl_preauth_thrift, 'Denied'}}, 'denied', undefined},
    {3, optional, {struct, struct, {dmsl_preauth_thrift, 'Unavailable'}}, 'unavailable', undefined}
]};

struct_info('Granted') ->
    {struct, struct, [
    {1, required, {struct, union, {dmsl_preauth_thrift, 'State'}}, 'state', undefined}
]};

struct_info('Denied') ->
    {struct, struct, [
    {1, required, {struct, union, {dmsl_preauth_thrift, 'State'}}, 'state', undefined}
]};

struct_info('Unavailable') ->
    {struct, struct, [
    {1, required, {struct, union, {dmsl_preauth_thrift, 'State'}}, 'state', undefined}
]};

struct_info('State') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_preauth_thrift, 'State3DSecure'}}, 'state_3dsecure', undefined}
]};

struct_info('State3DSecure') ->
    {struct, struct, [
    {1, optional, byte, 'eci', undefined},
    {2, optional, string, 'cavv', undefined},
    {3, optional, byte, 'cavv_algo', undefined},
    {4, optional, string, 'xid', undefined}
]};

struct_info(_) -> erlang:error(badarg).

-spec record_name(struct_name() | exception_name()) -> atom() | no_return().

record_name('Granted') ->
    'preauth_Granted';

record_name('Denied') ->
    'preauth_Denied';

    record_name('Unavailable') ->
    'preauth_Unavailable';

    record_name('State3DSecure') ->
    'preauth_State3DSecure';

    record_name(_) -> error(badarg).
    
    -spec functions(_) -> no_return().

functions(_) -> error(badarg).

-spec function_info(_,_,_) -> no_return().

function_info(_Service, _Function, _InfoType) -> erlang:error(badarg).