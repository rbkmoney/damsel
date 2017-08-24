%%
%% Autogenerated by Thrift Compiler (1.0.0-dev)
%%
%% DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
%%

-module(dmsl_domain_config_thrift).

-include("dmsl_domain_config_thrift.hrl").

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
    'Version'/0,
    'History'/0
]).
-export_type([
    'Head'/0,
    'Reference'/0,
    'Snapshot'/0,
    'Commit'/0,
    'Operation'/0,
    'InsertOp'/0,
    'UpdateOp'/0,
    'RemoveOp'/0,
    'VersionedObject'/0,
    'Conflict'/0,
    'ObjectAlreadyExistsConflict'/0,
    'ObjectNotFoundConflict'/0,
    'ObjectReferenceMismatchConflict'/0,
    'ObjectsNotExistConflict'/0,
    'NonexistantObject'/0
]).
-export_type([
    'VersionNotFound'/0,
    'ObjectNotFound'/0,
    'OperationConflict'/0,
    'ObsoleteCommitVersion'/0
]).

-type namespace() :: ''.

%%
%% typedefs
%%
-type typedef_name() ::
    'Version' |
    'History'.

-type 'Version'() :: integer().
-type 'History'() :: #{'Version'() => 'Commit'()}.

%%
%% enums
%%
-type enum_name() :: none().

%%
%% structs, unions and exceptions
%%
-type struct_name() ::
    'Head' |
    'Reference' |
    'Snapshot' |
    'Commit' |
    'Operation' |
    'InsertOp' |
    'UpdateOp' |
    'RemoveOp' |
    'VersionedObject' |
    'Conflict' |
    'ObjectAlreadyExistsConflict' |
    'ObjectNotFoundConflict' |
    'ObjectReferenceMismatchConflict' |
    'ObjectsNotExistConflict' |
    'NonexistantObject'.

-type exception_name() ::
    'VersionNotFound' |
    'ObjectNotFound' |
    'OperationConflict' |
    'ObsoleteCommitVersion'.

%% struct 'Head'
-type 'Head'() :: #'Head'{}.

%% union 'Reference'
-type 'Reference'() ::
    {'version', 'Version'()} |
    {'head', 'Head'()}.

%% struct 'Snapshot'
-type 'Snapshot'() :: #'Snapshot'{}.

%% struct 'Commit'
-type 'Commit'() :: #'Commit'{}.

%% union 'Operation'
-type 'Operation'() ::
    {'insert', 'InsertOp'()} |
    {'update', 'UpdateOp'()} |
    {'remove', 'RemoveOp'()}.

%% struct 'InsertOp'
-type 'InsertOp'() :: #'InsertOp'{}.

%% struct 'UpdateOp'
-type 'UpdateOp'() :: #'UpdateOp'{}.

%% struct 'RemoveOp'
-type 'RemoveOp'() :: #'RemoveOp'{}.

%% struct 'VersionedObject'
-type 'VersionedObject'() :: #'VersionedObject'{}.

%% union 'Conflict'
-type 'Conflict'() ::
    {'object_already_exists', 'ObjectAlreadyExistsConflict'()} |
    {'object_not_found', 'ObjectNotFoundConflict'()} |
    {'object_reference_mismatch', 'ObjectReferenceMismatchConflict'()} |
    {'objects_not_exist', 'ObjectsNotExistConflict'()}.

%% struct 'ObjectAlreadyExistsConflict'
-type 'ObjectAlreadyExistsConflict'() :: #'ObjectAlreadyExistsConflict'{}.

%% struct 'ObjectNotFoundConflict'
-type 'ObjectNotFoundConflict'() :: #'ObjectNotFoundConflict'{}.

%% struct 'ObjectReferenceMismatchConflict'
-type 'ObjectReferenceMismatchConflict'() :: #'ObjectReferenceMismatchConflict'{}.

%% struct 'ObjectsNotExistConflict'
-type 'ObjectsNotExistConflict'() :: #'ObjectsNotExistConflict'{}.

%% struct 'NonexistantObject'
-type 'NonexistantObject'() :: #'NonexistantObject'{}.

%% exception 'VersionNotFound'
-type 'VersionNotFound'() :: #'VersionNotFound'{}.

%% exception 'ObjectNotFound'
-type 'ObjectNotFound'() :: #'ObjectNotFound'{}.

%% exception 'OperationConflict'
-type 'OperationConflict'() :: #'OperationConflict'{}.

%% exception 'ObsoleteCommitVersion'
-type 'ObsoleteCommitVersion'() :: #'ObsoleteCommitVersion'{}.

%%
%% services and functions
%%
-type service_name() ::
    'RepositoryClient' |
    'Repository'.

-type function_name() ::
    'RepositoryClient_service_functions'() |
    'Repository_service_functions'().

-type 'RepositoryClient_service_functions'() ::
    'checkoutObject'.

-export_type(['RepositoryClient_service_functions'/0]).

-type 'Repository_service_functions'() ::
    'Commit' |
    'Checkout' |
    'Pull'.

-export_type(['Repository_service_functions'/0]).


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
        'Version',
        'History'
    ].

-spec enums() -> [].

enums() ->
    [].

-spec structs() -> [struct_name()].

structs() ->
    [
        'Head',
        'Reference',
        'Snapshot',
        'Commit',
        'Operation',
        'InsertOp',
        'UpdateOp',
        'RemoveOp',
        'VersionedObject',
        'Conflict',
        'ObjectAlreadyExistsConflict',
        'ObjectNotFoundConflict',
        'ObjectReferenceMismatchConflict',
        'ObjectsNotExistConflict',
        'NonexistantObject'
    ].

-spec services() -> [service_name()].

services() ->
    [
        'RepositoryClient',
        'Repository'
    ].

-spec namespace() -> namespace().

namespace() ->
    ''.

-spec typedef_info(typedef_name()) -> field_type() | no_return().

typedef_info('Version') ->
    i64;

typedef_info('History') ->
    {map, i64, {struct, struct, {dmsl_domain_config_thrift, 'Commit'}}};

typedef_info(_) -> erlang:error(badarg).

-spec enum_info(_) -> no_return().

enum_info(_) -> erlang:error(badarg).

-spec struct_info(struct_name() | exception_name()) -> struct_info() | no_return().

struct_info('Head') ->
    {struct, struct, []};

struct_info('Reference') ->
    {struct, union, [
    {1, optional, i64, 'version', undefined},
    {2, optional, {struct, struct, {dmsl_domain_config_thrift, 'Head'}}, 'head', undefined}
]};

struct_info('Snapshot') ->
    {struct, struct, [
    {1, undefined, i64, 'version', undefined},
    {2, undefined, {map, {struct, union, {dmsl_domain_thrift, 'Reference'}}, {struct, union, {dmsl_domain_thrift, 'DomainObject'}}}, 'domain', undefined}
]};

struct_info('Commit') ->
    {struct, struct, [
    {1, required, {list, {struct, union, {dmsl_domain_config_thrift, 'Operation'}}}, 'ops', undefined}
]};

struct_info('Operation') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_domain_config_thrift, 'InsertOp'}}, 'insert', undefined},
    {2, optional, {struct, struct, {dmsl_domain_config_thrift, 'UpdateOp'}}, 'update', undefined},
    {3, optional, {struct, struct, {dmsl_domain_config_thrift, 'RemoveOp'}}, 'remove', undefined}
]};

struct_info('InsertOp') ->
    {struct, struct, [
    {1, required, {struct, union, {dmsl_domain_thrift, 'DomainObject'}}, 'object', undefined}
]};

struct_info('UpdateOp') ->
    {struct, struct, [
    {1, required, {struct, union, {dmsl_domain_thrift, 'DomainObject'}}, 'old_object', undefined},
    {2, required, {struct, union, {dmsl_domain_thrift, 'DomainObject'}}, 'new_object', undefined}
]};

struct_info('RemoveOp') ->
    {struct, struct, [
    {1, required, {struct, union, {dmsl_domain_thrift, 'DomainObject'}}, 'object', undefined}
]};

struct_info('VersionedObject') ->
    {struct, struct, [
    {1, undefined, i64, 'version', undefined},
    {2, undefined, {struct, union, {dmsl_domain_thrift, 'DomainObject'}}, 'object', undefined}
]};

struct_info('Conflict') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_domain_config_thrift, 'ObjectAlreadyExistsConflict'}}, 'object_already_exists', undefined},
    {2, optional, {struct, struct, {dmsl_domain_config_thrift, 'ObjectNotFoundConflict'}}, 'object_not_found', undefined},
    {3, optional, {struct, struct, {dmsl_domain_config_thrift, 'ObjectReferenceMismatchConflict'}}, 'object_reference_mismatch', undefined},
    {4, optional, {struct, struct, {dmsl_domain_config_thrift, 'ObjectsNotExistConflict'}}, 'objects_not_exist', undefined}
]};

struct_info('ObjectAlreadyExistsConflict') ->
    {struct, struct, [
    {1, required, {struct, union, {dmsl_domain_thrift, 'Reference'}}, 'object_ref', undefined}
]};

struct_info('ObjectNotFoundConflict') ->
    {struct, struct, [
    {1, required, {struct, union, {dmsl_domain_thrift, 'Reference'}}, 'object_ref', undefined}
]};

struct_info('ObjectReferenceMismatchConflict') ->
    {struct, struct, [
    {1, required, {struct, union, {dmsl_domain_thrift, 'Reference'}}, 'object_ref', undefined}
]};

struct_info('ObjectsNotExistConflict') ->
    {struct, struct, [
    {1, required, {list, {struct, struct, {dmsl_domain_config_thrift, 'NonexistantObject'}}}, 'object_refs', undefined}
]};

struct_info('NonexistantObject') ->
    {struct, struct, [
    {1, required, {struct, union, {dmsl_domain_thrift, 'Reference'}}, 'object_ref', undefined},
    {2, required, {list, {struct, union, {dmsl_domain_thrift, 'Reference'}}}, 'referenced_by', undefined}
]};

struct_info('VersionNotFound') ->
    {struct, exception, []};

struct_info('ObjectNotFound') ->
    {struct, exception, []};

struct_info('OperationConflict') ->
    {struct, exception, [
    {1, required, {struct, union, {dmsl_domain_config_thrift, 'Conflict'}}, 'conflict', undefined}
]};

struct_info('ObsoleteCommitVersion') ->
    {struct, exception, []};

struct_info(_) -> erlang:error(badarg).

-spec record_name(struct_name() | exception_name()) -> atom() | no_return().

record_name('Head') ->
    'Head';

record_name('Snapshot') ->
    'Snapshot';

    record_name('Commit') ->
    'Commit';

    record_name('InsertOp') ->
    'InsertOp';

    record_name('UpdateOp') ->
    'UpdateOp';

    record_name('RemoveOp') ->
    'RemoveOp';

    record_name('VersionedObject') ->
    'VersionedObject';

    record_name('ObjectAlreadyExistsConflict') ->
    'ObjectAlreadyExistsConflict';

    record_name('ObjectNotFoundConflict') ->
    'ObjectNotFoundConflict';

    record_name('ObjectReferenceMismatchConflict') ->
    'ObjectReferenceMismatchConflict';

    record_name('ObjectsNotExistConflict') ->
    'ObjectsNotExistConflict';

    record_name('NonexistantObject') ->
    'NonexistantObject';

    record_name('VersionNotFound') ->
    'VersionNotFound';

    record_name('ObjectNotFound') ->
    'ObjectNotFound';

    record_name('OperationConflict') ->
    'OperationConflict';

    record_name('ObsoleteCommitVersion') ->
    'ObsoleteCommitVersion';

    record_name(_) -> error(badarg).
    
    -spec functions(service_name()) -> [function_name()] | no_return().

functions('RepositoryClient') ->
    [
        'checkoutObject'
    ];

functions('Repository') ->
    [
        'Commit',
        'Checkout',
        'Pull'
    ];

functions(_) -> error(badarg).

-spec function_info(service_name(), function_name(), params_type | reply_type | exceptions) ->
    struct_info() | no_return().

function_info('RepositoryClient', 'checkoutObject', params_type) ->
    {struct, struct, [
    {1, undefined, {struct, union, {dmsl_domain_config_thrift, 'Reference'}}, 'version_ref', undefined},
    {2, undefined, {struct, union, {dmsl_domain_thrift, 'Reference'}}, 'object_ref', undefined}
]};
function_info('RepositoryClient', 'checkoutObject', reply_type) ->
        {struct, struct, {dmsl_domain_config_thrift, 'VersionedObject'}};
    function_info('RepositoryClient', 'checkoutObject', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_domain_config_thrift, 'VersionNotFound'}}, 'ex1', undefined},
        {2, undefined, {struct, exception, {dmsl_domain_config_thrift, 'ObjectNotFound'}}, 'ex2', undefined}
    ]};

function_info('Repository', 'Commit', params_type) ->
    {struct, struct, [
    {1, undefined, i64, 'version', undefined},
    {2, undefined, {struct, struct, {dmsl_domain_config_thrift, 'Commit'}}, 'commit', undefined}
]};
function_info('Repository', 'Commit', reply_type) ->
        i64;
    function_info('Repository', 'Commit', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_domain_config_thrift, 'VersionNotFound'}}, 'ex1', undefined},
        {2, undefined, {struct, exception, {dmsl_domain_config_thrift, 'OperationConflict'}}, 'ex2', undefined},
        {3, undefined, {struct, exception, {dmsl_domain_config_thrift, 'ObsoleteCommitVersion'}}, 'ex3', undefined}
    ]};
function_info('Repository', 'Checkout', params_type) ->
    {struct, struct, [
    {1, undefined, {struct, union, {dmsl_domain_config_thrift, 'Reference'}}, 'reference', undefined}
]};
function_info('Repository', 'Checkout', reply_type) ->
        {struct, struct, {dmsl_domain_config_thrift, 'Snapshot'}};
    function_info('Repository', 'Checkout', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_domain_config_thrift, 'VersionNotFound'}}, 'ex1', undefined}
    ]};
function_info('Repository', 'Pull', params_type) ->
    {struct, struct, [
    {1, undefined, i64, 'version', undefined}
]};
function_info('Repository', 'Pull', reply_type) ->
        {map, i64, {struct, struct, {dmsl_domain_config_thrift, 'Commit'}}};
    function_info('Repository', 'Pull', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_domain_config_thrift, 'VersionNotFound'}}, 'ex1', undefined}
    ]};

function_info(_Service, _Function, _InfoType) -> erlang:error(badarg).
