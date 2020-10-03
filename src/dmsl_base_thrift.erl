%%
%% Autogenerated by Thrift Compiler (1.0.0-dev)
%%
%% DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
%%

-module(dmsl_base_thrift).

-include("dmsl_base_thrift.hrl").

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
    'ID'/0,
    'EventID'/0,
    'SequenceID'/0,
    'Opaque'/0,
    'Timestamp'/0,
    'Year'/0,
    'DayOfMonth'/0,
    'Timezone'/0,
    'StringMap'/0,
    'Timeout'/0,
    'Tag'/0
]).
-export_type([
    'BoundType'/0,
    'DayOfWeek'/0,
    'Month'/0
]).
-export_type([
    'Content'/0,
    'TimestampInterval'/0,
    'TimestampIntervalBound'/0,
    'TimeSpan'/0,
    'Schedule'/0,
    'ScheduleEvery'/0,
    'ScheduleFragment'/0,
    'ScheduleDayOfWeek'/0,
    'ScheduleMonth'/0,
    'ScheduleYear'/0,
    'Rational'/0,
    'Timer'/0
]).
-export_type([
    'InvalidRequest'/0
]).

-type namespace() :: ''.

%%
%% typedefs
%%
-type typedef_name() ::
    'ID' |
    'EventID' |
    'SequenceID' |
    'Opaque' |
    'Timestamp' |
    'Year' |
    'DayOfMonth' |
    'Timezone' |
    'StringMap' |
    'Timeout' |
    'Tag'.

-type 'ID'() :: binary().
-type 'EventID'() :: integer().
-type 'SequenceID'() :: integer().
-type 'Opaque'() :: binary().
-type 'Timestamp'() :: binary().
-type 'Year'() :: integer().
-type 'DayOfMonth'() :: integer().
-type 'Timezone'() :: binary().
-type 'StringMap'() :: #{binary() => binary()}.
-type 'Timeout'() :: integer().
-type 'Tag'() :: binary().

%%
%% enums
%%
-type enum_name() ::
    'BoundType' |
    'DayOfWeek' |
    'Month'.

%% enum 'BoundType'
-type 'BoundType'() ::
    'inclusive' |
    'exclusive'.

%% enum 'DayOfWeek'
-type 'DayOfWeek'() ::
    'mon' |
    'tue' |
    'wed' |
    'thu' |
    'fri' |
    'sat' |
    'sun'.

%% enum 'Month'
-type 'Month'() ::
    'jan' |
    'feb' |
    'mar' |
    'apr' |
    'may' |
    'jun' |
    'jul' |
    'aug' |
    'sep' |
    'oct' |
    'nov' |
    'dec'.

%%
%% structs, unions and exceptions
%%
-type struct_name() ::
    'Content' |
    'TimestampInterval' |
    'TimestampIntervalBound' |
    'TimeSpan' |
    'Schedule' |
    'ScheduleEvery' |
    'ScheduleFragment' |
    'ScheduleDayOfWeek' |
    'ScheduleMonth' |
    'ScheduleYear' |
    'Rational' |
    'Timer'.

-type exception_name() ::
    'InvalidRequest'.

%% struct 'Content'
-type 'Content'() :: #'Content'{}.

%% struct 'TimestampInterval'
-type 'TimestampInterval'() :: #'TimestampInterval'{}.

%% struct 'TimestampIntervalBound'
-type 'TimestampIntervalBound'() :: #'TimestampIntervalBound'{}.

%% struct 'TimeSpan'
-type 'TimeSpan'() :: #'TimeSpan'{}.

%% struct 'Schedule'
-type 'Schedule'() :: #'Schedule'{}.

%% struct 'ScheduleEvery'
-type 'ScheduleEvery'() :: #'ScheduleEvery'{}.

%% union 'ScheduleFragment'
-type 'ScheduleFragment'() ::
    {'every', 'ScheduleEvery'()} |
    {'on', ordsets:ordset(integer())}.

%% union 'ScheduleDayOfWeek'
-type 'ScheduleDayOfWeek'() ::
    {'every', 'ScheduleEvery'()} |
    {'on', ordsets:ordset(atom())}.

%% union 'ScheduleMonth'
-type 'ScheduleMonth'() ::
    {'every', 'ScheduleEvery'()} |
    {'on', ordsets:ordset(atom())}.

%% union 'ScheduleYear'
-type 'ScheduleYear'() ::
    {'every', 'ScheduleEvery'()} |
    {'on', ordsets:ordset('Year'())}.

%% struct 'Rational'
-type 'Rational'() :: #'Rational'{}.

%% union 'Timer'
-type 'Timer'() ::
    {'timeout', 'Timeout'()} |
    {'deadline', 'Timestamp'()}.

%% exception 'InvalidRequest'
-type 'InvalidRequest'() :: #'InvalidRequest'{}.

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

-type enum_choice() ::
    'BoundType'() |
    'DayOfWeek'() |
    'Month'().

-type enum_field_info() ::
    {enum_choice(), integer()}.
-type enum_info() ::
    {enum, [enum_field_info()]}.

-spec typedefs() -> [typedef_name()].

typedefs() ->
    [
        'ID',
        'EventID',
        'SequenceID',
        'Opaque',
        'Timestamp',
        'Year',
        'DayOfMonth',
        'Timezone',
        'StringMap',
        'Timeout',
        'Tag'
    ].

-spec enums() -> [enum_name()].

enums() ->
    [
        'BoundType',
        'DayOfWeek',
        'Month'
    ].

-spec structs() -> [struct_name()].

structs() ->
    [
        'Content',
        'TimestampInterval',
        'TimestampIntervalBound',
        'TimeSpan',
        'Schedule',
        'ScheduleEvery',
        'ScheduleFragment',
        'ScheduleDayOfWeek',
        'ScheduleMonth',
        'ScheduleYear',
        'Rational',
        'Timer'
    ].

-spec services() -> [].

services() ->
    [].

-spec namespace() -> namespace().

namespace() ->
    ''.

-spec typedef_info(typedef_name()) -> field_type() | no_return().

typedef_info('ID') ->
    string;

typedef_info('EventID') ->
    i64;

typedef_info('SequenceID') ->
    i32;

typedef_info('Opaque') ->
    string;

typedef_info('Timestamp') ->
    string;

typedef_info('Year') ->
    i32;

typedef_info('DayOfMonth') ->
    byte;

typedef_info('Timezone') ->
    string;

typedef_info('StringMap') ->
    {map, string, string};

typedef_info('Timeout') ->
    i32;

typedef_info('Tag') ->
    string;

typedef_info(_) -> erlang:error(badarg).

-spec enum_info(enum_name()) -> enum_info() | no_return().

enum_info('BoundType') ->
    {enum, [
        {'inclusive', 0},
        {'exclusive', 1}
    ]};

enum_info('DayOfWeek') ->
    {enum, [
        {'mon', 1},
        {'tue', 2},
        {'wed', 3},
        {'thu', 4},
        {'fri', 5},
        {'sat', 6},
        {'sun', 7}
    ]};

enum_info('Month') ->
    {enum, [
        {'jan', 1},
        {'feb', 2},
        {'mar', 3},
        {'apr', 4},
        {'may', 5},
        {'jun', 6},
        {'jul', 7},
        {'aug', 8},
        {'sep', 9},
        {'oct', 10},
        {'nov', 11},
        {'dec', 12}
    ]};

enum_info(_) -> erlang:error(badarg).

-spec struct_info(struct_name() | exception_name()) -> struct_info() | no_return().

struct_info('Content') ->
    {struct, struct, [
        {1, required, string, 'type', undefined},
        {2, required, string, 'data', undefined}
    ]};

struct_info('TimestampInterval') ->
    {struct, struct, [
        {1, optional, {struct, struct, {dmsl_base_thrift, 'TimestampIntervalBound'}}, 'lower_bound', undefined},
        {2, optional, {struct, struct, {dmsl_base_thrift, 'TimestampIntervalBound'}}, 'upper_bound', undefined}
    ]};

struct_info('TimestampIntervalBound') ->
    {struct, struct, [
        {1, required, {enum, {dmsl_base_thrift, 'BoundType'}}, 'bound_type', undefined},
        {2, required, string, 'bound_time', undefined}
    ]};

struct_info('TimeSpan') ->
    {struct, struct, [
        {1, optional, i16, 'years', undefined},
        {2, optional, i16, 'months', undefined},
        {4, optional, i16, 'days', undefined},
        {5, optional, i16, 'hours', undefined},
        {6, optional, i16, 'minutes', undefined},
        {7, optional, i16, 'seconds', undefined}
    ]};

struct_info('Schedule') ->
    {struct, struct, [
        {1, required, {struct, union, {dmsl_base_thrift, 'ScheduleYear'}}, 'year', undefined},
        {2, required, {struct, union, {dmsl_base_thrift, 'ScheduleMonth'}}, 'month', undefined},
        {3, required, {struct, union, {dmsl_base_thrift, 'ScheduleFragment'}}, 'day_of_month', undefined},
        {4, required, {struct, union, {dmsl_base_thrift, 'ScheduleDayOfWeek'}}, 'day_of_week', undefined},
        {5, required, {struct, union, {dmsl_base_thrift, 'ScheduleFragment'}}, 'hour', undefined},
        {6, required, {struct, union, {dmsl_base_thrift, 'ScheduleFragment'}}, 'minute', undefined},
        {7, required, {struct, union, {dmsl_base_thrift, 'ScheduleFragment'}}, 'second', undefined}
    ]};

struct_info('ScheduleEvery') ->
    {struct, struct, [
        {1, optional, byte, 'nth', undefined}
    ]};

struct_info('ScheduleFragment') ->
    {struct, union, [
        {1, optional, {struct, struct, {dmsl_base_thrift, 'ScheduleEvery'}}, 'every', undefined},
        {2, optional, {set, byte}, 'on', undefined}
    ]};

struct_info('ScheduleDayOfWeek') ->
    {struct, union, [
        {1, optional, {struct, struct, {dmsl_base_thrift, 'ScheduleEvery'}}, 'every', undefined},
        {2, optional, {set, {enum, {dmsl_base_thrift, 'DayOfWeek'}}}, 'on', undefined}
    ]};

struct_info('ScheduleMonth') ->
    {struct, union, [
        {1, optional, {struct, struct, {dmsl_base_thrift, 'ScheduleEvery'}}, 'every', undefined},
        {2, optional, {set, {enum, {dmsl_base_thrift, 'Month'}}}, 'on', undefined}
    ]};

struct_info('ScheduleYear') ->
    {struct, union, [
        {1, optional, {struct, struct, {dmsl_base_thrift, 'ScheduleEvery'}}, 'every', undefined},
        {2, optional, {set, i32}, 'on', undefined}
    ]};

struct_info('Rational') ->
    {struct, struct, [
        {1, required, i64, 'p', undefined},
        {2, required, i64, 'q', undefined}
    ]};

struct_info('Timer') ->
    {struct, union, [
        {1, optional, i32, 'timeout', undefined},
        {2, optional, string, 'deadline', undefined}
    ]};

struct_info('InvalidRequest') ->
    {struct, exception, [
        {1, required, {list, string}, 'errors', undefined}
    ]};

struct_info(_) -> erlang:error(badarg).

-spec record_name(struct_name() | exception_name()) -> atom() | no_return().

record_name('Content') ->
    'Content';

record_name('TimestampInterval') ->
    'TimestampInterval';

record_name('TimestampIntervalBound') ->
    'TimestampIntervalBound';

record_name('TimeSpan') ->
    'TimeSpan';

record_name('Schedule') ->
    'Schedule';

record_name('ScheduleEvery') ->
    'ScheduleEvery';

record_name('Rational') ->
    'Rational';

record_name('InvalidRequest') ->
    'InvalidRequest';

record_name(_) -> error(badarg).

-spec functions(_) -> no_return().

functions(_) -> error(badarg).

-spec function_info(_,_,_) -> no_return().

function_info(_Service, _Function, _InfoType) -> erlang:error(badarg).
