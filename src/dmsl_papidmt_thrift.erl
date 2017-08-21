%%
%% Autogenerated by Thrift Compiler (1.0.0-dev)
%%
%% DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
%%

-module(dmsl_papidmt_thrift).

-include("dmsl_papidmt_thrift.hrl").

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
    'HistoryWrapper'/0
]).

-type namespace() :: 'papidmt'.

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
    'HistoryWrapper'.

-type exception_name() :: none().

%% struct 'HistoryWrapper'
-type 'HistoryWrapper'() :: #'papidmt_HistoryWrapper'{}.

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
        'HistoryWrapper'
    ].

-spec services() -> [].

services() ->
    [].

-spec namespace() -> namespace().

namespace() ->
    'papidmt'.

-spec typedef_info(_) -> no_return().

typedef_info(_) -> erlang:error(badarg).

-spec enum_info(_) -> no_return().

enum_info(_) -> erlang:error(badarg).

-spec struct_info(struct_name() | exception_name()) -> struct_info() | no_return().

struct_info('HistoryWrapper') ->
    {struct, struct, [
    {1, required, {map, i64, {struct, struct, {dmsl_domain_config_thrift, 'Commit'}}}, 'history', undefined}
]};

struct_info(_) -> erlang:error(badarg).

-spec record_name(struct_name() | exception_name()) -> atom() | no_return().

record_name('HistoryWrapper') ->
    'papidmt_HistoryWrapper';

record_name(_) -> error(badarg).
    
    -spec functions(_) -> no_return().

functions(_) -> error(badarg).

-spec function_info(_,_,_) -> no_return().

function_info(_Service, _Function, _InfoType) -> erlang:error(badarg).
