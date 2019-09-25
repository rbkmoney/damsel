%%
%% Autogenerated by Thrift Compiler (1.0.0-dev)
%%
%% DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
%%

-module(dmsl_walker_thrift).

-include("dmsl_walker_thrift.hrl").

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
    'ClaimID'/0,
    'PartyID'/0,
    'ShopID'/0,
    'InvalidUser'/0,
    'InvalidChangeset'/0,
    'PartyNotFound'/0,
    'InvalidPartyStatus'/0,
    'ClaimNotFound'/0,
    'InvalidClaimRevision'/0,
    'ChangesetConflict'/0,
    'InvalidClaimStatus'/0
]).
-export_type([
    'ActionType'/0
]).
-export_type([
    'PartyModificationUnit'/0,
    'ClaimInfo'/0,
    'ClaimSearchRequest'/0,
    'Comment'/0,
    'Action'/0,
    'UserInformation'/0
]).

-type namespace() :: 'walker'.

%%
%% typedefs
%%
-type typedef_name() ::
    'ClaimID' |
    'PartyID' |
    'ShopID' |
    'InvalidUser' |
    'InvalidChangeset' |
    'PartyNotFound' |
    'InvalidPartyStatus' |
    'ClaimNotFound' |
    'InvalidClaimRevision' |
    'ChangesetConflict' |
    'InvalidClaimStatus'.

-type 'ClaimID'() :: integer().
-type 'PartyID'() :: dmsl_domain_thrift:'PartyID'().
-type 'ShopID'() :: dmsl_domain_thrift:'ShopID'().
-type 'InvalidUser'() :: dmsl_payment_processing_thrift:'InvalidUser'().
-type 'InvalidChangeset'() :: dmsl_payment_processing_thrift:'InvalidChangeset'().
-type 'PartyNotFound'() :: dmsl_payment_processing_thrift:'PartyNotFound'().
-type 'InvalidPartyStatus'() :: dmsl_payment_processing_thrift:'InvalidPartyStatus'().
-type 'ClaimNotFound'() :: dmsl_payment_processing_thrift:'ClaimNotFound'().
-type 'InvalidClaimRevision'() :: dmsl_payment_processing_thrift:'InvalidClaimRevision'().
-type 'ChangesetConflict'() :: dmsl_payment_processing_thrift:'ChangesetConflict'().
-type 'InvalidClaimStatus'() :: dmsl_payment_processing_thrift:'InvalidClaimStatus'().

%%
%% enums
%%
-type enum_name() ::
    'ActionType'.

%% enum 'ActionType'
-type 'ActionType'() ::
    'assigned' |
    'comment' |
    'status_changed' |
    'claim_changed'.

%%
%% structs, unions and exceptions
%%
-type struct_name() ::
    'PartyModificationUnit' |
    'ClaimInfo' |
    'ClaimSearchRequest' |
    'Comment' |
    'Action' |
    'UserInformation'.

-type exception_name() :: none().

%% struct 'PartyModificationUnit'
-type 'PartyModificationUnit'() :: #'walker_PartyModificationUnit'{}.

%% struct 'ClaimInfo'
-type 'ClaimInfo'() :: #'walker_ClaimInfo'{}.

%% struct 'ClaimSearchRequest'
-type 'ClaimSearchRequest'() :: #'walker_ClaimSearchRequest'{}.

%% struct 'Comment'
-type 'Comment'() :: #'walker_Comment'{}.

%% struct 'Action'
-type 'Action'() :: #'walker_Action'{}.

%% struct 'UserInformation'
-type 'UserInformation'() :: #'walker_UserInformation'{}.

%%
%% services and functions
%%
-type service_name() ::
    'Walker'.

-type function_name() ::
    'Walker_service_functions'().

-type 'Walker_service_functions'() ::
    'AcceptClaim' |
    'DenyClaim' |
    'GetClaim' |
    'CreateClaim' |
    'UpdateClaim' |
    'SearchClaims' |
    'AddComment' |
    'GetComments' |
    'GetActions'.

-export_type(['Walker_service_functions'/0]).


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
    'ActionType'().

-type enum_field_info() ::
    {enum_choice(), integer()}.
-type enum_info() ::
    {enum, [enum_field_info()]}.

-spec typedefs() -> [typedef_name()].

typedefs() ->
    [
        'ClaimID',
        'PartyID',
        'ShopID',
        'InvalidUser',
        'InvalidChangeset',
        'PartyNotFound',
        'InvalidPartyStatus',
        'ClaimNotFound',
        'InvalidClaimRevision',
        'ChangesetConflict',
        'InvalidClaimStatus'
    ].

-spec enums() -> [enum_name()].

enums() ->
    [
        'ActionType'
    ].

-spec structs() -> [struct_name()].

structs() ->
    [
        'PartyModificationUnit',
        'ClaimInfo',
        'ClaimSearchRequest',
        'Comment',
        'Action',
        'UserInformation'
    ].

-spec services() -> [service_name()].

services() ->
    [
        'Walker'
    ].

-spec namespace() -> namespace().

namespace() ->
    'walker'.

-spec typedef_info(typedef_name()) -> field_type() | no_return().

typedef_info('ClaimID') ->
    i64;

typedef_info('PartyID') ->
    string;

typedef_info('ShopID') ->
    string;

typedef_info('InvalidUser') ->
    {struct, exception, {dmsl_payment_processing_thrift, 'InvalidUser'}};

typedef_info('InvalidChangeset') ->
    {struct, exception, {dmsl_payment_processing_thrift, 'InvalidChangeset'}};

typedef_info('PartyNotFound') ->
    {struct, exception, {dmsl_payment_processing_thrift, 'PartyNotFound'}};

typedef_info('InvalidPartyStatus') ->
    {struct, exception, {dmsl_payment_processing_thrift, 'InvalidPartyStatus'}};

typedef_info('ClaimNotFound') ->
    {struct, exception, {dmsl_payment_processing_thrift, 'ClaimNotFound'}};

typedef_info('InvalidClaimRevision') ->
    {struct, exception, {dmsl_payment_processing_thrift, 'InvalidClaimRevision'}};

typedef_info('ChangesetConflict') ->
    {struct, exception, {dmsl_payment_processing_thrift, 'ChangesetConflict'}};

typedef_info('InvalidClaimStatus') ->
    {struct, exception, {dmsl_payment_processing_thrift, 'InvalidClaimStatus'}};

typedef_info(_) -> erlang:error(badarg).

-spec enum_info(enum_name()) -> enum_info() | no_return().

enum_info('ActionType') ->
    {enum, [
        {'assigned', 0},
        {'comment', 1},
        {'status_changed', 2},
        {'claim_changed', 3}
    ]};

enum_info(_) -> erlang:error(badarg).

-spec struct_info(struct_name() | exception_name()) -> struct_info() | no_return().

struct_info('PartyModificationUnit') ->
    {struct, struct, [
    {1, required, {list, {struct, union, {dmsl_payment_processing_thrift, 'PartyModification'}}}, 'modifications', undefined}
]};

struct_info('ClaimInfo') ->
    {struct, struct, [
    {1, required, string, 'party_id', undefined},
    {2, required, i64, 'claim_id', undefined},
    {3, required, string, 'status', undefined},
    {4, optional, string, 'assigned_user_id', undefined},
    {5, optional, string, 'description', undefined},
    {6, optional, string, 'reason', undefined},
    {7, required, {struct, struct, {dmsl_walker_thrift, 'PartyModificationUnit'}}, 'modifications', undefined},
    {8, required, string, 'revision', undefined},
    {9, required, string, 'created_at', undefined},
    {10, required, string, 'updated_at', undefined}
]};

struct_info('ClaimSearchRequest') ->
    {struct, struct, [
    {1, optional, string, 'party_id', undefined},
    {2, optional, {set, i64}, 'claim_id', undefined},
    {3, optional, string, 'contains', undefined},
    {4, optional, string, 'assigned_user_id', undefined},
    {5, optional, string, 'claim_status', undefined}
]};

struct_info('Comment') ->
    {struct, struct, [
    {1, required, string, 'text', undefined},
    {2, required, string, 'created_at', undefined},
    {3, required, {struct, struct, {dmsl_walker_thrift, 'UserInformation'}}, 'user', undefined}
]};

struct_info('Action') ->
    {struct, struct, [
    {1, required, string, 'created_at', undefined},
    {2, required, {struct, struct, {dmsl_walker_thrift, 'UserInformation'}}, 'user', undefined},
    {3, required, {enum, {dmsl_walker_thrift, 'ActionType'}}, 'type', undefined},
    {4, optional, string, 'before', undefined},
    {5, required, string, 'after', undefined}
]};

struct_info('UserInformation') ->
    {struct, struct, [
    {1, required, string, 'userID', undefined},
    {2, optional, string, 'user_name', undefined},
    {3, optional, string, 'email', undefined}
]};

struct_info(_) -> erlang:error(badarg).

-spec record_name(struct_name() | exception_name()) -> atom() | no_return().

record_name('PartyModificationUnit') ->
    'walker_PartyModificationUnit';

record_name('ClaimInfo') ->
    'walker_ClaimInfo';

    record_name('ClaimSearchRequest') ->
    'walker_ClaimSearchRequest';

    record_name('Comment') ->
    'walker_Comment';

    record_name('Action') ->
    'walker_Action';

    record_name('UserInformation') ->
    'walker_UserInformation';

    record_name(_) -> error(badarg).
    
    -spec functions(service_name()) -> [function_name()] | no_return().

functions('Walker') ->
    [
        'AcceptClaim',
        'DenyClaim',
        'GetClaim',
        'CreateClaim',
        'UpdateClaim',
        'SearchClaims',
        'AddComment',
        'GetComments',
        'GetActions'
    ];

functions(_) -> error(badarg).

-spec function_info(service_name(), function_name(), params_type | reply_type | exceptions) ->
    struct_info() | no_return().

function_info('Walker', 'AcceptClaim', params_type) ->
    {struct, struct, [
    {1, undefined, string, 'party_id', undefined},
    {2, undefined, i64, 'claim_id', undefined},
    {3, undefined, {struct, struct, {dmsl_walker_thrift, 'UserInformation'}}, 'user', undefined},
    {4, undefined, i32, 'revision', undefined}
]};
function_info('Walker', 'AcceptClaim', reply_type) ->
        {struct, struct, []};
    function_info('Walker', 'AcceptClaim', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_payment_processing_thrift, 'InvalidUser'}}, 'ex1', undefined},
        {2, undefined, {struct, exception, {dmsl_payment_processing_thrift, 'PartyNotFound'}}, 'ex2', undefined},
        {3, undefined, {struct, exception, {dmsl_payment_processing_thrift, 'ClaimNotFound'}}, 'ex3', undefined},
        {4, undefined, {struct, exception, {dmsl_payment_processing_thrift, 'InvalidClaimStatus'}}, 'ex4', undefined},
        {5, undefined, {struct, exception, {dmsl_payment_processing_thrift, 'InvalidClaimRevision'}}, 'ex5', undefined},
        {6, undefined, {struct, exception, {dmsl_payment_processing_thrift, 'InvalidChangeset'}}, 'ex6', undefined}
    ]};
function_info('Walker', 'DenyClaim', params_type) ->
    {struct, struct, [
    {1, undefined, string, 'party_id', undefined},
    {2, undefined, i64, 'claim_id', undefined},
    {3, undefined, {struct, struct, {dmsl_walker_thrift, 'UserInformation'}}, 'user', undefined},
    {4, undefined, string, 'reason', undefined},
    {5, undefined, i32, 'revision', undefined}
]};
function_info('Walker', 'DenyClaim', reply_type) ->
        {struct, struct, []};
    function_info('Walker', 'DenyClaim', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_payment_processing_thrift, 'InvalidUser'}}, 'ex1', undefined},
        {2, undefined, {struct, exception, {dmsl_payment_processing_thrift, 'PartyNotFound'}}, 'ex2', undefined},
        {3, undefined, {struct, exception, {dmsl_payment_processing_thrift, 'ClaimNotFound'}}, 'ex3', undefined},
        {4, undefined, {struct, exception, {dmsl_payment_processing_thrift, 'InvalidClaimStatus'}}, 'ex4', undefined},
        {5, undefined, {struct, exception, {dmsl_payment_processing_thrift, 'InvalidClaimRevision'}}, 'ex5', undefined}
    ]};
function_info('Walker', 'GetClaim', params_type) ->
    {struct, struct, [
    {1, undefined, string, 'party_id', undefined},
    {2, undefined, i64, 'claim_id', undefined}
]};
function_info('Walker', 'GetClaim', reply_type) ->
        {struct, struct, {dmsl_walker_thrift, 'ClaimInfo'}};
    function_info('Walker', 'GetClaim', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_payment_processing_thrift, 'ClaimNotFound'}}, 'ex1', undefined}
    ]};
function_info('Walker', 'CreateClaim', params_type) ->
    {struct, struct, [
    {1, undefined, {struct, struct, {dmsl_walker_thrift, 'UserInformation'}}, 'user', undefined},
    {2, undefined, string, 'party_id', undefined},
    {3, undefined, {struct, struct, {dmsl_walker_thrift, 'PartyModificationUnit'}}, 'changeset', undefined}
]};
function_info('Walker', 'CreateClaim', reply_type) ->
        {struct, struct, {dmsl_payment_processing_thrift, 'Claim'}};
    function_info('Walker', 'CreateClaim', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_payment_processing_thrift, 'InvalidUser'}}, 'ex1', undefined},
        {2, undefined, {struct, exception, {dmsl_payment_processing_thrift, 'PartyNotFound'}}, 'ex2', undefined},
        {3, undefined, {struct, exception, {dmsl_payment_processing_thrift, 'InvalidPartyStatus'}}, 'ex3', undefined},
        {4, undefined, {struct, exception, {dmsl_payment_processing_thrift, 'ChangesetConflict'}}, 'ex4', undefined},
        {5, undefined, {struct, exception, {dmsl_payment_processing_thrift, 'InvalidChangeset'}}, 'ex5', undefined},
        {6, undefined, {struct, exception, {dmsl_base_thrift, 'InvalidRequest'}}, 'ex6', undefined}
    ]};
function_info('Walker', 'UpdateClaim', params_type) ->
    {struct, struct, [
    {1, undefined, string, 'party_id', undefined},
    {2, undefined, i64, 'claim_id', undefined},
    {3, undefined, {struct, struct, {dmsl_walker_thrift, 'UserInformation'}}, 'user', undefined},
    {4, undefined, {struct, struct, {dmsl_walker_thrift, 'PartyModificationUnit'}}, 'changeset', undefined},
    {5, undefined, i32, 'revision', undefined}
]};
function_info('Walker', 'UpdateClaim', reply_type) ->
        {struct, struct, []};
    function_info('Walker', 'UpdateClaim', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_payment_processing_thrift, 'InvalidUser'}}, 'ex1', undefined},
        {2, undefined, {struct, exception, {dmsl_payment_processing_thrift, 'PartyNotFound'}}, 'ex2', undefined},
        {3, undefined, {struct, exception, {dmsl_payment_processing_thrift, 'InvalidPartyStatus'}}, 'ex3', undefined},
        {4, undefined, {struct, exception, {dmsl_payment_processing_thrift, 'ClaimNotFound'}}, 'ex4', undefined},
        {5, undefined, {struct, exception, {dmsl_payment_processing_thrift, 'InvalidClaimStatus'}}, 'ex5', undefined},
        {6, undefined, {struct, exception, {dmsl_payment_processing_thrift, 'InvalidClaimRevision'}}, 'ex6', undefined},
        {7, undefined, {struct, exception, {dmsl_payment_processing_thrift, 'ChangesetConflict'}}, 'ex7', undefined},
        {8, undefined, {struct, exception, {dmsl_payment_processing_thrift, 'InvalidChangeset'}}, 'ex8', undefined},
        {9, undefined, {struct, exception, {dmsl_base_thrift, 'InvalidRequest'}}, 'ex9', undefined}
    ]};
function_info('Walker', 'SearchClaims', params_type) ->
    {struct, struct, [
    {1, undefined, {struct, struct, {dmsl_walker_thrift, 'ClaimSearchRequest'}}, 'request', undefined}
]};
function_info('Walker', 'SearchClaims', reply_type) ->
        {list, {struct, struct, {dmsl_walker_thrift, 'ClaimInfo'}}};
    function_info('Walker', 'SearchClaims', exceptions) ->
        {struct, struct, []};
function_info('Walker', 'AddComment', params_type) ->
    {struct, struct, [
    {1, undefined, string, 'party_id', undefined},
    {2, undefined, i64, 'claim_id', undefined},
    {3, undefined, {struct, struct, {dmsl_walker_thrift, 'UserInformation'}}, 'user', undefined},
    {4, undefined, string, 'text', undefined}
]};
function_info('Walker', 'AddComment', reply_type) ->
        {struct, struct, []};
    function_info('Walker', 'AddComment', exceptions) ->
        {struct, struct, []};
function_info('Walker', 'GetComments', params_type) ->
    {struct, struct, [
    {1, undefined, string, 'party_id', undefined},
    {2, undefined, i64, 'claim_id', undefined}
]};
function_info('Walker', 'GetComments', reply_type) ->
        {list, {struct, struct, {dmsl_walker_thrift, 'Comment'}}};
    function_info('Walker', 'GetComments', exceptions) ->
        {struct, struct, []};
function_info('Walker', 'GetActions', params_type) ->
    {struct, struct, [
    {1, undefined, string, 'party_id', undefined},
    {2, undefined, i64, 'claim_id', undefined}
]};
function_info('Walker', 'GetActions', reply_type) ->
        {list, {struct, struct, {dmsl_walker_thrift, 'Action'}}};
    function_info('Walker', 'GetActions', exceptions) ->
        {struct, struct, []};

function_info(_Service, _Function, _InfoType) -> erlang:error(badarg).
