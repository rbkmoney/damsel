%%
%% Autogenerated by Thrift Compiler (1.0.0-dev)
%%
%% DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
%%

-module(dmsl_accounter_thrift).

-include("dmsl_accounter_thrift.hrl").

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
    'PlanID'/0,
    'BatchID'/0,
    'AccountID'/0
]).
-export_type([
    'AccountPrototype'/0,
    'Account'/0,
    'Posting'/0,
    'PostingBatch'/0,
    'PostingPlan'/0,
    'PostingPlanChange'/0,
    'PostingPlanLog'/0
]).
-export_type([
    'AccountNotFound'/0,
    'PlanNotFound'/0,
    'InvalidPostingParams'/0
]).

-type namespace() :: 'accounter'.

%%
%% typedefs
%%
-type typedef_name() ::
    'PlanID' |
    'BatchID' |
    'AccountID'.

-type 'PlanID'() :: dmsl_base_thrift:'ID'().
-type 'BatchID'() :: integer().
-type 'AccountID'() :: integer().

%%
%% enums
%%
-type enum_name() :: none().

%%
%% structs, unions and exceptions
%%
-type struct_name() ::
    'AccountPrototype' |
    'Account' |
    'Posting' |
    'PostingBatch' |
    'PostingPlan' |
    'PostingPlanChange' |
    'PostingPlanLog'.

-type exception_name() ::
    'AccountNotFound' |
    'PlanNotFound' |
    'InvalidPostingParams'.

%% struct 'AccountPrototype'
-type 'AccountPrototype'() :: #'accounter_AccountPrototype'{}.

%% struct 'Account'
-type 'Account'() :: #'accounter_Account'{}.

%% struct 'Posting'
-type 'Posting'() :: #'accounter_Posting'{}.

%% struct 'PostingBatch'
-type 'PostingBatch'() :: #'accounter_PostingBatch'{}.

%% struct 'PostingPlan'
-type 'PostingPlan'() :: #'accounter_PostingPlan'{}.

%% struct 'PostingPlanChange'
-type 'PostingPlanChange'() :: #'accounter_PostingPlanChange'{}.

%% struct 'PostingPlanLog'
-type 'PostingPlanLog'() :: #'accounter_PostingPlanLog'{}.

%% exception 'AccountNotFound'
-type 'AccountNotFound'() :: #'accounter_AccountNotFound'{}.

%% exception 'PlanNotFound'
-type 'PlanNotFound'() :: #'accounter_PlanNotFound'{}.

%% exception 'InvalidPostingParams'
-type 'InvalidPostingParams'() :: #'accounter_InvalidPostingParams'{}.

%%
%% services and functions
%%
-type service_name() ::
    'Accounter'.

-type function_name() ::
    'Accounter_service_functions'().

-type 'Accounter_service_functions'() ::
    'Hold' |
    'CommitPlan' |
    'RollbackPlan' |
    'GetPlan' |
    'GetAccountByID' |
    'CreateAccount'.

-export_type(['Accounter_service_functions'/0]).


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
        'PlanID',
        'BatchID',
        'AccountID'
    ].

-spec enums() -> [].

enums() ->
    [].

-spec structs() -> [struct_name()].

structs() ->
    [
        'AccountPrototype',
        'Account',
        'Posting',
        'PostingBatch',
        'PostingPlan',
        'PostingPlanChange',
        'PostingPlanLog'
    ].

-spec services() -> [service_name()].

services() ->
    [
        'Accounter'
    ].

-spec namespace() -> namespace().

namespace() ->
    'accounter'.

-spec typedef_info(typedef_name()) -> field_type() | no_return().

typedef_info('PlanID') ->
    string;

typedef_info('BatchID') ->
    i64;

typedef_info('AccountID') ->
    i64;

typedef_info(_) -> erlang:error(badarg).

-spec enum_info(_) -> no_return().

enum_info(_) -> erlang:error(badarg).

-spec struct_info(struct_name() | exception_name()) -> struct_info() | no_return().

struct_info('AccountPrototype') ->
    {struct, struct, [
    {1, required, string, 'currency_sym_code', undefined},
    {2, optional, string, 'description', undefined},
    {3, optional, string, 'creation_time', undefined}
]};

struct_info('Account') ->
    {struct, struct, [
    {1, required, i64, 'id', undefined},
    {2, required, i64, 'own_amount', undefined},
    {3, required, i64, 'max_available_amount', undefined},
    {4, required, i64, 'min_available_amount', undefined},
    {5, required, string, 'currency_sym_code', undefined},
    {6, optional, string, 'description', undefined},
    {7, optional, string, 'creation_time', undefined}
]};

struct_info('Posting') ->
    {struct, struct, [
    {1, required, i64, 'from_id', undefined},
    {2, required, i64, 'to_id', undefined},
    {3, required, i64, 'amount', undefined},
    {4, required, string, 'currency_sym_code', undefined},
    {5, required, string, 'description', undefined}
]};

struct_info('PostingBatch') ->
    {struct, struct, [
    {1, required, i64, 'id', undefined},
    {2, required, {list, {struct, struct, {dmsl_accounter_thrift, 'Posting'}}}, 'postings', undefined}
]};

struct_info('PostingPlan') ->
    {struct, struct, [
    {1, required, string, 'id', undefined},
    {2, required, {list, {struct, struct, {dmsl_accounter_thrift, 'PostingBatch'}}}, 'batch_list', undefined}
]};

struct_info('PostingPlanChange') ->
    {struct, struct, [
    {1, required, string, 'id', undefined},
    {2, required, {struct, struct, {dmsl_accounter_thrift, 'PostingBatch'}}, 'batch', undefined}
]};

struct_info('PostingPlanLog') ->
    {struct, struct, [
    {2, required, {map, i64, {struct, struct, {dmsl_accounter_thrift, 'Account'}}}, 'affected_accounts', undefined}
]};

struct_info('AccountNotFound') ->
    {struct, exception, [
    {1, required, i64, 'account_id', undefined}
]};

struct_info('PlanNotFound') ->
    {struct, exception, [
    {1, required, string, 'plan_id', undefined}
]};

struct_info('InvalidPostingParams') ->
    {struct, exception, [
    {1, required, {map, {struct, struct, {dmsl_accounter_thrift, 'Posting'}}, string}, 'wrong_postings', undefined}
]};

struct_info(_) -> erlang:error(badarg).

-spec record_name(struct_name() | exception_name()) -> atom() | no_return().

record_name('AccountPrototype') ->
    'accounter_AccountPrototype';

record_name('Account') ->
    'accounter_Account';

    record_name('Posting') ->
    'accounter_Posting';

    record_name('PostingBatch') ->
    'accounter_PostingBatch';

    record_name('PostingPlan') ->
    'accounter_PostingPlan';

    record_name('PostingPlanChange') ->
    'accounter_PostingPlanChange';

    record_name('PostingPlanLog') ->
    'accounter_PostingPlanLog';

    record_name('AccountNotFound') ->
    'accounter_AccountNotFound';

    record_name('PlanNotFound') ->
    'accounter_PlanNotFound';

    record_name('InvalidPostingParams') ->
    'accounter_InvalidPostingParams';

    record_name(_) -> error(badarg).
    
    -spec functions(service_name()) -> [function_name()] | no_return().

functions('Accounter') ->
    [
        'Hold',
        'CommitPlan',
        'RollbackPlan',
        'GetPlan',
        'GetAccountByID',
        'CreateAccount'
    ];

functions(_) -> error(badarg).

-spec function_info(service_name(), function_name(), params_type | reply_type | exceptions) ->
    struct_info() | no_return().

function_info('Accounter', 'Hold', params_type) ->
    {struct, struct, [
    {1, undefined, {struct, struct, {dmsl_accounter_thrift, 'PostingPlanChange'}}, 'plan_change', undefined}
]};
function_info('Accounter', 'Hold', reply_type) ->
        {struct, struct, {dmsl_accounter_thrift, 'PostingPlanLog'}};
    function_info('Accounter', 'Hold', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_accounter_thrift, 'InvalidPostingParams'}}, 'e1', undefined},
        {2, undefined, {struct, exception, {dmsl_base_thrift, 'InvalidRequest'}}, 'e2', undefined}
    ]};
function_info('Accounter', 'CommitPlan', params_type) ->
    {struct, struct, [
    {1, undefined, {struct, struct, {dmsl_accounter_thrift, 'PostingPlan'}}, 'plan', undefined}
]};
function_info('Accounter', 'CommitPlan', reply_type) ->
        {struct, struct, {dmsl_accounter_thrift, 'PostingPlanLog'}};
    function_info('Accounter', 'CommitPlan', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_accounter_thrift, 'InvalidPostingParams'}}, 'e1', undefined},
        {2, undefined, {struct, exception, {dmsl_base_thrift, 'InvalidRequest'}}, 'e2', undefined}
    ]};
function_info('Accounter', 'RollbackPlan', params_type) ->
    {struct, struct, [
    {1, undefined, {struct, struct, {dmsl_accounter_thrift, 'PostingPlan'}}, 'plan', undefined}
]};
function_info('Accounter', 'RollbackPlan', reply_type) ->
        {struct, struct, {dmsl_accounter_thrift, 'PostingPlanLog'}};
    function_info('Accounter', 'RollbackPlan', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_accounter_thrift, 'InvalidPostingParams'}}, 'e1', undefined},
        {2, undefined, {struct, exception, {dmsl_base_thrift, 'InvalidRequest'}}, 'e2', undefined}
    ]};
function_info('Accounter', 'GetPlan', params_type) ->
    {struct, struct, [
    {1, undefined, string, 'id', undefined}
]};
function_info('Accounter', 'GetPlan', reply_type) ->
        {struct, struct, {dmsl_accounter_thrift, 'PostingPlan'}};
    function_info('Accounter', 'GetPlan', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_accounter_thrift, 'PlanNotFound'}}, 'e1', undefined}
    ]};
function_info('Accounter', 'GetAccountByID', params_type) ->
    {struct, struct, [
    {1, undefined, i64, 'id', undefined}
]};
function_info('Accounter', 'GetAccountByID', reply_type) ->
        {struct, struct, {dmsl_accounter_thrift, 'Account'}};
    function_info('Accounter', 'GetAccountByID', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_accounter_thrift, 'AccountNotFound'}}, 'ex', undefined}
    ]};
function_info('Accounter', 'CreateAccount', params_type) ->
    {struct, struct, [
    {1, undefined, {struct, struct, {dmsl_accounter_thrift, 'AccountPrototype'}}, 'prototype', undefined}
]};
function_info('Accounter', 'CreateAccount', reply_type) ->
        i64;
    function_info('Accounter', 'CreateAccount', exceptions) ->
        {struct, struct, []};

function_info(_Service, _Function, _InfoType) -> erlang:error(badarg).
