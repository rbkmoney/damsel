%%
%% Autogenerated by Thrift Compiler (1.0.0-dev)
%%
%% DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
%%

-module(dmsl_payment_processing_errors_thrift).

-include("dmsl_payment_processing_errors_thrift.hrl").

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
    'PaymentFailure'/0,
    'AuthorizationFailure'/0,
    'LimitExceeded'/0,
    'PaymentToolReject'/0,
    'BankCardReject'/0,
    'GeneralFailure'/0
]).

-type namespace() :: 'payprocerr'.

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
    'PaymentFailure' |
    'AuthorizationFailure' |
    'LimitExceeded' |
    'PaymentToolReject' |
    'BankCardReject' |
    'GeneralFailure'.

-type exception_name() :: none().

%% union 'PaymentFailure'
-type 'PaymentFailure'() ::
    {'rejected_by_inspector', 'GeneralFailure'()} |
    {'preauthorization_failed', 'GeneralFailure'()} |
    {'authorization_failed', 'AuthorizationFailure'()}.

%% union 'AuthorizationFailure'
-type 'AuthorizationFailure'() ::
    {'unknown', 'GeneralFailure'()} |
    {'merchant_blocked', 'GeneralFailure'()} |
    {'operation_blocked', 'GeneralFailure'()} |
    {'account_not_found', 'GeneralFailure'()} |
    {'account_blocked', 'GeneralFailure'()} |
    {'account_stolen', 'GeneralFailure'()} |
    {'insufficient_funds', 'GeneralFailure'()} |
    {'account_limit_exceeded', 'LimitExceeded'()} |
    {'provider_limit_exceeded', 'LimitExceeded'()} |
    {'payment_tool_rejected', 'PaymentToolReject'()} |
    {'security_policy_violated', 'GeneralFailure'()} |
    {'temporarily_unavailable', 'GeneralFailure'()} |
    {'rejected_by_issuer', 'GeneralFailure'()}.

%% union 'LimitExceeded'
-type 'LimitExceeded'() ::
    {'unknown', 'GeneralFailure'()} |
    {'amount', 'GeneralFailure'()} |
    {'number', 'GeneralFailure'()}.

%% union 'PaymentToolReject'
-type 'PaymentToolReject'() ::
    {'unknown', 'GeneralFailure'()} |
    {'bank_card_rejected', 'BankCardReject'()}.

%% union 'BankCardReject'
-type 'BankCardReject'() ::
    {'unknown', 'GeneralFailure'()} |
    {'card_number_invalid', 'GeneralFailure'()} |
    {'card_expired', 'GeneralFailure'()} |
    {'card_holder_invalid', 'GeneralFailure'()} |
    {'cvv_invalid', 'GeneralFailure'()} |
    {'issuer_not_found', 'GeneralFailure'()}.

%% struct 'GeneralFailure'
-type 'GeneralFailure'() :: #'payprocerr_GeneralFailure'{}.

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
        'PaymentFailure',
        'AuthorizationFailure',
        'LimitExceeded',
        'PaymentToolReject',
        'BankCardReject',
        'GeneralFailure'
    ].

-spec services() -> [].

services() ->
    [].

-spec namespace() -> namespace().

namespace() ->
    'payprocerr'.

-spec typedef_info(_) -> no_return().

typedef_info(_) -> erlang:error(badarg).

-spec enum_info(_) -> no_return().

enum_info(_) -> erlang:error(badarg).

-spec struct_info(struct_name() | exception_name()) -> struct_info() | no_return().

struct_info('PaymentFailure') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_payment_processing_errors_thrift, 'GeneralFailure'}}, 'rejected_by_inspector', undefined},
    {2, optional, {struct, struct, {dmsl_payment_processing_errors_thrift, 'GeneralFailure'}}, 'preauthorization_failed', undefined},
    {3, optional, {struct, union, {dmsl_payment_processing_errors_thrift, 'AuthorizationFailure'}}, 'authorization_failed', undefined}
]};

struct_info('AuthorizationFailure') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_payment_processing_errors_thrift, 'GeneralFailure'}}, 'unknown', undefined},
    {2, optional, {struct, struct, {dmsl_payment_processing_errors_thrift, 'GeneralFailure'}}, 'merchant_blocked', undefined},
    {3, optional, {struct, struct, {dmsl_payment_processing_errors_thrift, 'GeneralFailure'}}, 'operation_blocked', undefined},
    {4, optional, {struct, struct, {dmsl_payment_processing_errors_thrift, 'GeneralFailure'}}, 'account_not_found', undefined},
    {5, optional, {struct, struct, {dmsl_payment_processing_errors_thrift, 'GeneralFailure'}}, 'account_blocked', undefined},
    {6, optional, {struct, struct, {dmsl_payment_processing_errors_thrift, 'GeneralFailure'}}, 'account_stolen', undefined},
    {7, optional, {struct, struct, {dmsl_payment_processing_errors_thrift, 'GeneralFailure'}}, 'insufficient_funds', undefined},
    {8, optional, {struct, union, {dmsl_payment_processing_errors_thrift, 'LimitExceeded'}}, 'account_limit_exceeded', undefined},
    {9, optional, {struct, union, {dmsl_payment_processing_errors_thrift, 'LimitExceeded'}}, 'provider_limit_exceeded', undefined},
    {10, optional, {struct, union, {dmsl_payment_processing_errors_thrift, 'PaymentToolReject'}}, 'payment_tool_rejected', undefined},
    {11, optional, {struct, struct, {dmsl_payment_processing_errors_thrift, 'GeneralFailure'}}, 'security_policy_violated', undefined},
    {12, optional, {struct, struct, {dmsl_payment_processing_errors_thrift, 'GeneralFailure'}}, 'temporarily_unavailable', undefined},
    {13, optional, {struct, struct, {dmsl_payment_processing_errors_thrift, 'GeneralFailure'}}, 'rejected_by_issuer', undefined}
]};

struct_info('LimitExceeded') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_payment_processing_errors_thrift, 'GeneralFailure'}}, 'unknown', undefined},
    {2, optional, {struct, struct, {dmsl_payment_processing_errors_thrift, 'GeneralFailure'}}, 'amount', undefined},
    {3, optional, {struct, struct, {dmsl_payment_processing_errors_thrift, 'GeneralFailure'}}, 'number', undefined}
]};

struct_info('PaymentToolReject') ->
    {struct, union, [
    {2, optional, {struct, struct, {dmsl_payment_processing_errors_thrift, 'GeneralFailure'}}, 'unknown', undefined},
    {1, optional, {struct, union, {dmsl_payment_processing_errors_thrift, 'BankCardReject'}}, 'bank_card_rejected', undefined}
]};

struct_info('BankCardReject') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_payment_processing_errors_thrift, 'GeneralFailure'}}, 'unknown', undefined},
    {2, optional, {struct, struct, {dmsl_payment_processing_errors_thrift, 'GeneralFailure'}}, 'card_number_invalid', undefined},
    {3, optional, {struct, struct, {dmsl_payment_processing_errors_thrift, 'GeneralFailure'}}, 'card_expired', undefined},
    {4, optional, {struct, struct, {dmsl_payment_processing_errors_thrift, 'GeneralFailure'}}, 'card_holder_invalid', undefined},
    {5, optional, {struct, struct, {dmsl_payment_processing_errors_thrift, 'GeneralFailure'}}, 'cvv_invalid', undefined},
    {7, optional, {struct, struct, {dmsl_payment_processing_errors_thrift, 'GeneralFailure'}}, 'issuer_not_found', undefined}
]};

struct_info('GeneralFailure') ->
    {struct, struct, []};

struct_info(_) -> erlang:error(badarg).

-spec record_name(struct_name() | exception_name()) -> atom() | no_return().

record_name('GeneralFailure') ->
    'payprocerr_GeneralFailure';

record_name(_) -> error(badarg).
    
    -spec functions(_) -> no_return().

functions(_) -> error(badarg).

-spec function_info(_,_,_) -> no_return().

function_info(_Service, _Function, _InfoType) -> erlang:error(badarg).
