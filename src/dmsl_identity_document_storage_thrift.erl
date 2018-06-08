%%
%% Autogenerated by Thrift Compiler (1.0.0-dev)
%%
%% DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
%%

-module(dmsl_identity_document_storage_thrift).

-include("dmsl_identity_document_storage_thrift.hrl").

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
    'IdentityDocumentToken'/0
]).
-export_type([
    'IdentityDocument'/0,
    'RussianDomesticPassport'/0,
    'RussianRetireeInsuranceCertificate'/0,
    'SafeIdentityDocumentData'/0,
    'SafeIdentityDocument'/0,
    'SafeRussianDomesticPassport'/0,
    'SafeRussianRetireeInsuranceCertificate'/0
]).
-export_type([
    'IdentityDocumentNotFound'/0
]).

-type namespace() :: 'ident_doc_store'.

%%
%% typedefs
%%
-type typedef_name() ::
    'IdentityDocumentToken'.

-type 'IdentityDocumentToken'() :: binary().

%%
%% enums
%%
-type enum_name() :: none().

%%
%% structs, unions and exceptions
%%
-type struct_name() ::
    'IdentityDocument' |
    'RussianDomesticPassport' |
    'RussianRetireeInsuranceCertificate' |
    'SafeIdentityDocumentData' |
    'SafeIdentityDocument' |
    'SafeRussianDomesticPassport' |
    'SafeRussianRetireeInsuranceCertificate'.

-type exception_name() ::
    'IdentityDocumentNotFound'.

%% union 'IdentityDocument'
-type 'IdentityDocument'() ::
    {'russian_domestic_passport', 'RussianDomesticPassport'()} |
    {'russian_retiree_insurance_certificate', 'RussianRetireeInsuranceCertificate'()}.

%% struct 'RussianDomesticPassport'
-type 'RussianDomesticPassport'() :: #'ident_doc_store_RussianDomesticPassport'{}.

%% struct 'RussianRetireeInsuranceCertificate'
-type 'RussianRetireeInsuranceCertificate'() :: #'ident_doc_store_RussianRetireeInsuranceCertificate'{}.

%% struct 'SafeIdentityDocumentData'
-type 'SafeIdentityDocumentData'() :: #'ident_doc_store_SafeIdentityDocumentData'{}.

%% union 'SafeIdentityDocument'
-type 'SafeIdentityDocument'() ::
    {'safe_russian_domestic_passport', 'SafeRussianDomesticPassport'()} |
    {'safe_russian_retiree_insurance_certificate', 'SafeRussianRetireeInsuranceCertificate'()}.

%% struct 'SafeRussianDomesticPassport'
-type 'SafeRussianDomesticPassport'() :: #'ident_doc_store_SafeRussianDomesticPassport'{}.

%% struct 'SafeRussianRetireeInsuranceCertificate'
-type 'SafeRussianRetireeInsuranceCertificate'() :: #'ident_doc_store_SafeRussianRetireeInsuranceCertificate'{}.

%% exception 'IdentityDocumentNotFound'
-type 'IdentityDocumentNotFound'() :: #'ident_doc_store_IdentityDocumentNotFound'{}.

%%
%% services and functions
%%
-type service_name() ::
    'IdentityDocumentStorage'.

-type function_name() ::
    'IdentityDocumentStorage_service_functions'().

-type 'IdentityDocumentStorage_service_functions'() ::
    'Put' |
    'Get'.

-export_type(['IdentityDocumentStorage_service_functions'/0]).


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
        'IdentityDocumentToken'
    ].

-spec enums() -> [].

enums() ->
    [].

-spec structs() -> [struct_name()].

structs() ->
    [
        'IdentityDocument',
        'RussianDomesticPassport',
        'RussianRetireeInsuranceCertificate',
        'SafeIdentityDocumentData',
        'SafeIdentityDocument',
        'SafeRussianDomesticPassport',
        'SafeRussianRetireeInsuranceCertificate'
    ].

-spec services() -> [service_name()].

services() ->
    [
        'IdentityDocumentStorage'
    ].

-spec namespace() -> namespace().

namespace() ->
    'ident_doc_store'.

-spec typedef_info(typedef_name()) -> field_type() | no_return().

typedef_info('IdentityDocumentToken') ->
    string;

typedef_info(_) -> erlang:error(badarg).

-spec enum_info(_) -> no_return().

enum_info(_) -> erlang:error(badarg).

-spec struct_info(struct_name() | exception_name()) -> struct_info() | no_return().

struct_info('IdentityDocument') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_identity_document_storage_thrift, 'RussianDomesticPassport'}}, 'russian_domestic_passport', undefined},
    {2, optional, {struct, struct, {dmsl_identity_document_storage_thrift, 'RussianRetireeInsuranceCertificate'}}, 'russian_retiree_insurance_certificate', undefined}
]};

struct_info('RussianDomesticPassport') ->
    {struct, struct, [
    {1, required, string, 'series', undefined},
    {2, required, string, 'number', undefined},
    {3, required, string, 'issuer', undefined},
    {4, required, string, 'issuer_code', undefined},
    {5, required, string, 'issued_at', undefined},
    {6, required, string, 'family_name', undefined},
    {7, required, string, 'first_name', undefined},
    {8, optional, string, 'patronymic', undefined},
    {9, required, string, 'birth_date', undefined},
    {10, required, string, 'birth_place', undefined}
]};

struct_info('RussianRetireeInsuranceCertificate') ->
    {struct, struct, [
    {1, required, string, 'number', undefined}
]};

struct_info('SafeIdentityDocumentData') ->
    {struct, struct, [
    {1, required, string, 'token', undefined},
    {2, required, {struct, union, {dmsl_identity_document_storage_thrift, 'SafeIdentityDocument'}}, 'safe_identity_document', undefined}
]};

struct_info('SafeIdentityDocument') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_identity_document_storage_thrift, 'SafeRussianDomesticPassport'}}, 'safe_russian_domestic_passport', undefined},
    {2, optional, {struct, struct, {dmsl_identity_document_storage_thrift, 'SafeRussianRetireeInsuranceCertificate'}}, 'safe_russian_retiree_insurance_certificate', undefined}
]};

struct_info('SafeRussianDomesticPassport') ->
    {struct, struct, [
    {1, required, string, 'series_masked', undefined},
    {2, required, string, 'number_masked', undefined},
    {3, required, string, 'fullname_masked', undefined}
]};

struct_info('SafeRussianRetireeInsuranceCertificate') ->
    {struct, struct, [
    {1, required, string, 'number_masked', undefined}
]};

struct_info('IdentityDocumentNotFound') ->
    {struct, exception, []};

struct_info(_) -> erlang:error(badarg).

-spec record_name(struct_name() | exception_name()) -> atom() | no_return().

record_name('RussianDomesticPassport') ->
    'ident_doc_store_RussianDomesticPassport';

record_name('RussianRetireeInsuranceCertificate') ->
    'ident_doc_store_RussianRetireeInsuranceCertificate';

    record_name('SafeIdentityDocumentData') ->
    'ident_doc_store_SafeIdentityDocumentData';

    record_name('SafeRussianDomesticPassport') ->
    'ident_doc_store_SafeRussianDomesticPassport';

    record_name('SafeRussianRetireeInsuranceCertificate') ->
    'ident_doc_store_SafeRussianRetireeInsuranceCertificate';

    record_name('IdentityDocumentNotFound') ->
    'ident_doc_store_IdentityDocumentNotFound';

    record_name(_) -> error(badarg).
    
    -spec functions(service_name()) -> [function_name()] | no_return().

functions('IdentityDocumentStorage') ->
    [
        'Put',
        'Get'
    ];

functions(_) -> error(badarg).

-spec function_info(service_name(), function_name(), params_type | reply_type | exceptions) ->
    struct_info() | no_return().

function_info('IdentityDocumentStorage', 'Put', params_type) ->
    {struct, struct, [
    {1, undefined, {struct, union, {dmsl_identity_document_storage_thrift, 'IdentityDocument'}}, 'identity_document', undefined}
]};
function_info('IdentityDocumentStorage', 'Put', reply_type) ->
        {struct, struct, {dmsl_identity_document_storage_thrift, 'SafeIdentityDocumentData'}};
    function_info('IdentityDocumentStorage', 'Put', exceptions) ->
        {struct, struct, []};
function_info('IdentityDocumentStorage', 'Get', params_type) ->
    {struct, struct, [
    {1, undefined, string, 'token', undefined}
]};
function_info('IdentityDocumentStorage', 'Get', reply_type) ->
        {struct, union, {dmsl_identity_document_storage_thrift, 'IdentityDocument'}};
    function_info('IdentityDocumentStorage', 'Get', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_identity_document_storage_thrift, 'IdentityDocumentNotFound'}}, 'not_found', undefined}
    ]};

function_info(_Service, _Function, _InfoType) -> erlang:error(badarg).
