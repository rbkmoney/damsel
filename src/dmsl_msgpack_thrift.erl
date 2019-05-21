%%
%% Autogenerated by Thrift Compiler (1.0.0-dev)
%%
%% DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
%%

-module(dmsl_msgpack_thrift).

-include("dmsl_msgpack_thrift.hrl").

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
    'Array'/0,
    'Object'/0
]).
-export_type([
    'Value'/0,
    'Nil'/0
]).

-type namespace() :: 'msgpack'.

%%
%% typedefs
%%
-type typedef_name() ::
    'Array' |
    'Object'.

-type 'Array'() :: ['Value'()].
-type 'Object'() :: #{'Value'() => 'Value'()}.

%%
%% enums
%%
-type enum_name() :: none().

%%
%% structs, unions and exceptions
%%
-type struct_name() ::
    'Value' |
    'Nil'.

-type exception_name() :: none().

%% union 'Value'
-type 'Value'() ::
    {'nl', 'Nil'()} |
    {'b', boolean()} |
    {'i', integer()} |
    {'flt', float()} |
    {'str', binary()} |
    {'bin', binary()} |
    {'obj', 'Object'()} |
    {'arr', 'Array'()}.

%% struct 'Nil'
-type 'Nil'() :: #'msgpack_Nil'{}.

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

-spec typedefs() -> [typedef_name()].

typedefs() ->
    [
        'Array',
        'Object'
    ].

-spec enums() -> [].

enums() ->
    [].

-spec structs() -> [struct_name()].

structs() ->
    [
        'Value',
        'Nil'
    ].

-spec services() -> [].

services() ->
    [].

-spec namespace() -> namespace().

namespace() ->
    'msgpack'.

-spec typedef_info(typedef_name()) -> field_type() | no_return().

typedef_info('Array') ->
    {list, {struct, union, {dmsl_msgpack_thrift, 'Value'}}};

typedef_info('Object') ->
    {map, {struct, union, {dmsl_msgpack_thrift, 'Value'}}, {struct, union, {dmsl_msgpack_thrift, 'Value'}}};

typedef_info(_) -> erlang:error(badarg).

-spec enum_info(_) -> no_return().

enum_info(_) -> erlang:error(badarg).

-spec struct_info(struct_name() | exception_name()) -> struct_info() | no_return().

struct_info('Value') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_msgpack_thrift, 'Nil'}}, 'nl', undefined},
    {2, optional, bool, 'b', undefined},
    {3, optional, i64, 'i', undefined},
    {4, optional, double, 'flt', undefined},
    {5, optional, string, 'str', undefined},
    {6, optional, string, 'bin', undefined},
    {7, optional, {map, {struct, union, {dmsl_msgpack_thrift, 'Value'}}, {struct, union, {dmsl_msgpack_thrift, 'Value'}}}, 'obj', undefined},
    {8, optional, {list, {struct, union, {dmsl_msgpack_thrift, 'Value'}}}, 'arr', undefined}
]};

struct_info('Nil') ->
    {struct, struct, []};

struct_info(_) -> erlang:error(badarg).

-spec record_name(struct_name() | exception_name()) -> atom() | no_return().

record_name('Nil') ->
    'msgpack_Nil';

record_name(_) -> error(badarg).
    
    -spec functions(_) -> no_return().

functions(_) -> error(badarg).

-spec function_info(_,_,_) -> no_return().

function_info(_Service, _Function, _InfoType) -> erlang:error(badarg).
