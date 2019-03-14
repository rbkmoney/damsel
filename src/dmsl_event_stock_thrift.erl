%%
%% Autogenerated by Thrift Compiler (1.0.0-dev)
%%
%% DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
%%

-module(dmsl_event_stock_thrift).

-include("dmsl_event_stock_thrift.hrl").

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
    'StockEvents'/0,
    'EventID'/0,
    'Timestamp'/0,
    'InvalidRequest'/0
]).
-export_type([
    'SourceEvent'/0,
    'StockEvent'/0,
    'RawEvent'/0,
    'EventIDBound'/0,
    'EventIDRange'/0,
    'EventTimeBound'/0,
    'EventTimeRange'/0,
    'EventRange'/0,
    'EventConstraint'/0
]).
-export_type([
    'DatasetTooBig'/0,
    'NoStockEvent'/0
]).

-type namespace() :: 'event_stock'.

%%
%% typedefs
%%
-type typedef_name() ::
    'StockEvents' |
    'EventID' |
    'Timestamp' |
    'InvalidRequest'.

-type 'StockEvents'() :: ['StockEvent'()].
-type 'EventID'() :: dmsl_base_thrift:'EventID'().
-type 'Timestamp'() :: dmsl_base_thrift:'Timestamp'().
-type 'InvalidRequest'() :: dmsl_base_thrift:'InvalidRequest'().

%%
%% enums
%%
-type enum_name() :: none().

%%
%% structs, unions and exceptions
%%
-type struct_name() ::
    'SourceEvent' |
    'StockEvent' |
    'RawEvent' |
    'EventIDBound' |
    'EventIDRange' |
    'EventTimeBound' |
    'EventTimeRange' |
    'EventRange' |
    'EventConstraint'.

-type exception_name() ::
    'DatasetTooBig' |
    'NoStockEvent'.

%% union 'SourceEvent'
-type 'SourceEvent'() ::
    {'processing_event', dmsl_payment_processing_thrift:'Event'()} |
    {'payout_event', dmsl_payout_processing_thrift:'Event'()} |
    {'raw_event', 'RawEvent'()}.

%% struct 'StockEvent'
-type 'StockEvent'() :: #'event_stock_StockEvent'{}.

%% struct 'RawEvent'
-type 'RawEvent'() :: #'event_stock_RawEvent'{}.

%% union 'EventIDBound'
-type 'EventIDBound'() ::
    {'inclusive', 'EventID'()} |
    {'exclusive', 'EventID'()}.

%% struct 'EventIDRange'
-type 'EventIDRange'() :: #'event_stock_EventIDRange'{}.

%% union 'EventTimeBound'
-type 'EventTimeBound'() ::
    {'inclusive', 'Timestamp'()} |
    {'exclusive', 'Timestamp'()}.

%% struct 'EventTimeRange'
-type 'EventTimeRange'() :: #'event_stock_EventTimeRange'{}.

%% union 'EventRange'
-type 'EventRange'() ::
    {'id_range', 'EventIDRange'()} |
    {'time_range', 'EventTimeRange'()}.

%% struct 'EventConstraint'
-type 'EventConstraint'() :: #'event_stock_EventConstraint'{}.

%% exception 'DatasetTooBig'
-type 'DatasetTooBig'() :: #'event_stock_DatasetTooBig'{}.

%% exception 'NoStockEvent'
-type 'NoStockEvent'() :: #'event_stock_NoStockEvent'{}.

%%
%% services and functions
%%
-type service_name() ::
    'EventRepository'.

-type function_name() ::
    'EventRepository_service_functions'().

-type 'EventRepository_service_functions'() ::
    'GetEvents' |
    'GetLastEvent' |
    'GetFirstEvent'.

-export_type(['EventRepository_service_functions'/0]).


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
        'StockEvents',
        'EventID',
        'Timestamp',
        'InvalidRequest'
    ].

-spec enums() -> [].

enums() ->
    [].

-spec structs() -> [struct_name()].

structs() ->
    [
        'SourceEvent',
        'StockEvent',
        'RawEvent',
        'EventIDBound',
        'EventIDRange',
        'EventTimeBound',
        'EventTimeRange',
        'EventRange',
        'EventConstraint'
    ].

-spec services() -> [service_name()].

services() ->
    [
        'EventRepository'
    ].

-spec namespace() -> namespace().

namespace() ->
    'event_stock'.

-spec typedef_info(typedef_name()) -> field_type() | no_return().

typedef_info('StockEvents') ->
    {list, {struct, struct, {dmsl_event_stock_thrift, 'StockEvent'}}};

typedef_info('EventID') ->
    i64;

typedef_info('Timestamp') ->
    string;

typedef_info('InvalidRequest') ->
    {struct, exception, {dmsl_base_thrift, 'InvalidRequest'}};

typedef_info(_) -> erlang:error(badarg).

-spec enum_info(_) -> no_return().

enum_info(_) -> erlang:error(badarg).

-spec struct_info(struct_name() | exception_name()) -> struct_info() | no_return().

struct_info('SourceEvent') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_payment_processing_thrift, 'Event'}}, 'processing_event', undefined},
    {2, optional, {struct, struct, {dmsl_payout_processing_thrift, 'Event'}}, 'payout_event', undefined},
    {100, optional, {struct, struct, {dmsl_event_stock_thrift, 'RawEvent'}}, 'raw_event', undefined}
]};

struct_info('StockEvent') ->
    {struct, struct, [
    {1, required, {struct, union, {dmsl_event_stock_thrift, 'SourceEvent'}}, 'source_event', undefined},
    {2, optional, i64, 'id', undefined},
    {3, optional, string, 'time', undefined},
    {4, optional, string, 'version', undefined}
]};

struct_info('RawEvent') ->
    {struct, struct, [
    {4, required, {struct, struct, {dmsl_base_thrift, 'Content'}}, 'content', undefined}
]};

struct_info('EventIDBound') ->
    {struct, union, [
    {1, optional, i64, 'inclusive', undefined},
    {2, optional, i64, 'exclusive', undefined}
]};

struct_info('EventIDRange') ->
    {struct, struct, [
    {1, required, {struct, union, {dmsl_event_stock_thrift, 'EventIDBound'}}, 'from_id', undefined},
    {2, optional, {struct, union, {dmsl_event_stock_thrift, 'EventIDBound'}}, 'to_id', undefined}
]};

struct_info('EventTimeBound') ->
    {struct, union, [
    {1, optional, string, 'inclusive', undefined},
    {2, optional, string, 'exclusive', undefined}
]};

struct_info('EventTimeRange') ->
    {struct, struct, [
    {1, required, {struct, union, {dmsl_event_stock_thrift, 'EventTimeBound'}}, 'from_time', undefined},
    {2, optional, {struct, union, {dmsl_event_stock_thrift, 'EventTimeBound'}}, 'to_time', undefined}
]};

struct_info('EventRange') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_event_stock_thrift, 'EventIDRange'}}, 'id_range', undefined},
    {2, optional, {struct, struct, {dmsl_event_stock_thrift, 'EventTimeRange'}}, 'time_range', undefined}
]};

struct_info('EventConstraint') ->
    {struct, struct, [
    {1, required, {struct, union, {dmsl_event_stock_thrift, 'EventRange'}}, 'event_range', undefined},
    {3, required, i32, 'limit', undefined}
]};

struct_info('DatasetTooBig') ->
    {struct, exception, [
    {1, undefined, i32, 'limit', undefined}
]};

struct_info('NoStockEvent') ->
    {struct, exception, []};

struct_info(_) -> erlang:error(badarg).

-spec record_name(struct_name() | exception_name()) -> atom() | no_return().

record_name('StockEvent') ->
    'event_stock_StockEvent';

record_name('RawEvent') ->
    'event_stock_RawEvent';

    record_name('EventIDRange') ->
    'event_stock_EventIDRange';

    record_name('EventTimeRange') ->
    'event_stock_EventTimeRange';

    record_name('EventConstraint') ->
    'event_stock_EventConstraint';

    record_name('DatasetTooBig') ->
    'event_stock_DatasetTooBig';

    record_name('NoStockEvent') ->
    'event_stock_NoStockEvent';

    record_name(_) -> error(badarg).
    
    -spec functions(service_name()) -> [function_name()] | no_return().

functions('EventRepository') ->
    [
        'GetEvents',
        'GetLastEvent',
        'GetFirstEvent'
    ];

functions(_) -> error(badarg).

-spec function_info(service_name(), function_name(), params_type | reply_type | exceptions) ->
    struct_info() | no_return().

function_info('EventRepository', 'GetEvents', params_type) ->
    {struct, struct, [
    {1, undefined, {struct, struct, {dmsl_event_stock_thrift, 'EventConstraint'}}, 'constraint', undefined}
]};
function_info('EventRepository', 'GetEvents', reply_type) ->
        {list, {struct, struct, {dmsl_event_stock_thrift, 'StockEvent'}}};
    function_info('EventRepository', 'GetEvents', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_base_thrift, 'InvalidRequest'}}, 'ex1', undefined},
        {2, undefined, {struct, exception, {dmsl_event_stock_thrift, 'DatasetTooBig'}}, 'ex2', undefined}
    ]};
function_info('EventRepository', 'GetLastEvent', params_type) ->
    {struct, struct, []};
function_info('EventRepository', 'GetLastEvent', reply_type) ->
        {struct, struct, {dmsl_event_stock_thrift, 'StockEvent'}};
    function_info('EventRepository', 'GetLastEvent', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_event_stock_thrift, 'NoStockEvent'}}, 'ex1', undefined}
    ]};
function_info('EventRepository', 'GetFirstEvent', params_type) ->
    {struct, struct, []};
function_info('EventRepository', 'GetFirstEvent', reply_type) ->
        {struct, struct, {dmsl_event_stock_thrift, 'StockEvent'}};
    function_info('EventRepository', 'GetFirstEvent', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_event_stock_thrift, 'NoStockEvent'}}, 'ex1', undefined}
    ]};

function_info(_Service, _Function, _InfoType) -> erlang:error(badarg).
