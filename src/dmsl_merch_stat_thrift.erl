%%
%% Autogenerated by Thrift Compiler (1.0.0-dev)
%%
%% DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
%%

-module(dmsl_merch_stat_thrift).

-include("dmsl_merch_stat_thrift.hrl").

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
    'DigitalWalletID'/0,
    'PayoutID'/0,
    'CashFlowDescriptions'/0,
    'StatInfo'/0,
    'InvalidRequest'/0
]).
-export_type([
    'OnHoldExpiration'/0,
    'TerminalPaymentProvider'/0,
    'DigitalWalletProvider'/0,
    'CashFlowType'/0
]).
-export_type([
    'StatPayment'/0,
    'Payer'/0,
    'PaymentResourcePayer'/0,
    'CustomerPayer'/0,
    'InvoicePaymentFlow'/0,
    'InvoicePaymentFlowInstant'/0,
    'InvoicePaymentFlowHold'/0,
    'OperationFailure'/0,
    'OperationTimeout'/0,
    'ExternalFailure'/0,
    'InvoicePaymentPending'/0,
    'InvoicePaymentProcessed'/0,
    'InvoicePaymentCaptured'/0,
    'InvoicePaymentCancelled'/0,
    'InvoicePaymentRefunded'/0,
    'InvoicePaymentFailed'/0,
    'InvoicePaymentStatus'/0,
    'PaymentTool'/0,
    'BankCard'/0,
    'PaymentTerminal'/0,
    'DigitalWallet'/0,
    'RussianBankAccount'/0,
    'InternationalBankAccount'/0,
    'StatInvoice'/0,
    'InvoiceUnpaid'/0,
    'InvoicePaid'/0,
    'InvoiceCancelled'/0,
    'InvoiceFulfilled'/0,
    'InvoiceStatus'/0,
    'StatCustomer'/0,
    'StatPayout'/0,
    'CashFlowDescription'/0,
    'PayoutType'/0,
    'PayoutCard'/0,
    'PayoutAccount'/0,
    'RussianPayoutAccount'/0,
    'InternationalPayoutAccount'/0,
    'PayoutStatus'/0,
    'PayoutUnpaid'/0,
    'PayoutPaid'/0,
    'PayoutCancelled'/0,
    'PayoutConfirmed'/0,
    'StatRequest'/0,
    'StatResponse'/0,
    'StatResponseData'/0
]).
-export_type([
    'DatasetTooBig'/0
]).

-type namespace() :: 'merchstat'.

%%
%% typedefs
%%
-type typedef_name() ::
    'DigitalWalletID' |
    'PayoutID' |
    'CashFlowDescriptions' |
    'StatInfo' |
    'InvalidRequest'.

-type 'DigitalWalletID'() :: binary().
-type 'PayoutID'() :: dmsl_base_thrift:'ID'().
-type 'CashFlowDescriptions'() :: ['CashFlowDescription'()].
-type 'StatInfo'() :: #{binary() => binary()}.
-type 'InvalidRequest'() :: dmsl_base_thrift:'InvalidRequest'().

%%
%% enums
%%
-type enum_name() ::
    'OnHoldExpiration' |
    'TerminalPaymentProvider' |
    'DigitalWalletProvider' |
    'CashFlowType'.

%% enum 'OnHoldExpiration'
-type 'OnHoldExpiration'() ::
    'cancel' |
    'capture'.

%% enum 'TerminalPaymentProvider'
-type 'TerminalPaymentProvider'() ::
    'euroset'.

%% enum 'DigitalWalletProvider'
-type 'DigitalWalletProvider'() ::
    'qiwi'.

%% enum 'CashFlowType'
-type 'CashFlowType'() ::
    'payment' |
    'refund'.

%%
%% structs, unions and exceptions
%%
-type struct_name() ::
    'StatPayment' |
    'Payer' |
    'PaymentResourcePayer' |
    'CustomerPayer' |
    'InvoicePaymentFlow' |
    'InvoicePaymentFlowInstant' |
    'InvoicePaymentFlowHold' |
    'OperationFailure' |
    'OperationTimeout' |
    'ExternalFailure' |
    'InvoicePaymentPending' |
    'InvoicePaymentProcessed' |
    'InvoicePaymentCaptured' |
    'InvoicePaymentCancelled' |
    'InvoicePaymentRefunded' |
    'InvoicePaymentFailed' |
    'InvoicePaymentStatus' |
    'PaymentTool' |
    'BankCard' |
    'PaymentTerminal' |
    'DigitalWallet' |
    'RussianBankAccount' |
    'InternationalBankAccount' |
    'StatInvoice' |
    'InvoiceUnpaid' |
    'InvoicePaid' |
    'InvoiceCancelled' |
    'InvoiceFulfilled' |
    'InvoiceStatus' |
    'StatCustomer' |
    'StatPayout' |
    'CashFlowDescription' |
    'PayoutType' |
    'PayoutCard' |
    'PayoutAccount' |
    'RussianPayoutAccount' |
    'InternationalPayoutAccount' |
    'PayoutStatus' |
    'PayoutUnpaid' |
    'PayoutPaid' |
    'PayoutCancelled' |
    'PayoutConfirmed' |
    'StatRequest' |
    'StatResponse' |
    'StatResponseData'.

-type exception_name() ::
    'DatasetTooBig'.

%% struct 'StatPayment'
-type 'StatPayment'() :: #'merchstat_StatPayment'{}.

%% union 'Payer'
-type 'Payer'() ::
    {'payment_resource', 'PaymentResourcePayer'()} |
    {'customer', 'CustomerPayer'()}.

%% struct 'PaymentResourcePayer'
-type 'PaymentResourcePayer'() :: #'merchstat_PaymentResourcePayer'{}.

%% struct 'CustomerPayer'
-type 'CustomerPayer'() :: #'merchstat_CustomerPayer'{}.

%% union 'InvoicePaymentFlow'
-type 'InvoicePaymentFlow'() ::
    {'instant', 'InvoicePaymentFlowInstant'()} |
    {'hold', 'InvoicePaymentFlowHold'()}.

%% struct 'InvoicePaymentFlowInstant'
-type 'InvoicePaymentFlowInstant'() :: #'merchstat_InvoicePaymentFlowInstant'{}.

%% struct 'InvoicePaymentFlowHold'
-type 'InvoicePaymentFlowHold'() :: #'merchstat_InvoicePaymentFlowHold'{}.

%% union 'OperationFailure'
-type 'OperationFailure'() ::
    {'operation_timeout', 'OperationTimeout'()} |
    {'external_failure', 'ExternalFailure'()}.

%% struct 'OperationTimeout'
-type 'OperationTimeout'() :: #'merchstat_OperationTimeout'{}.

%% struct 'ExternalFailure'
-type 'ExternalFailure'() :: #'merchstat_ExternalFailure'{}.

%% struct 'InvoicePaymentPending'
-type 'InvoicePaymentPending'() :: #'merchstat_InvoicePaymentPending'{}.

%% struct 'InvoicePaymentProcessed'
-type 'InvoicePaymentProcessed'() :: #'merchstat_InvoicePaymentProcessed'{}.

%% struct 'InvoicePaymentCaptured'
-type 'InvoicePaymentCaptured'() :: #'merchstat_InvoicePaymentCaptured'{}.

%% struct 'InvoicePaymentCancelled'
-type 'InvoicePaymentCancelled'() :: #'merchstat_InvoicePaymentCancelled'{}.

%% struct 'InvoicePaymentRefunded'
-type 'InvoicePaymentRefunded'() :: #'merchstat_InvoicePaymentRefunded'{}.

%% struct 'InvoicePaymentFailed'
-type 'InvoicePaymentFailed'() :: #'merchstat_InvoicePaymentFailed'{}.

%% union 'InvoicePaymentStatus'
-type 'InvoicePaymentStatus'() ::
    {'pending', 'InvoicePaymentPending'()} |
    {'processed', 'InvoicePaymentProcessed'()} |
    {'captured', 'InvoicePaymentCaptured'()} |
    {'cancelled', 'InvoicePaymentCancelled'()} |
    {'refunded', 'InvoicePaymentRefunded'()} |
    {'failed', 'InvoicePaymentFailed'()}.

%% union 'PaymentTool'
-type 'PaymentTool'() ::
    {'bank_card', 'BankCard'()} |
    {'payment_terminal', 'PaymentTerminal'()} |
    {'digital_wallet', 'DigitalWallet'()}.

%% struct 'BankCard'
-type 'BankCard'() :: #'merchstat_BankCard'{}.

%% struct 'PaymentTerminal'
-type 'PaymentTerminal'() :: #'merchstat_PaymentTerminal'{}.

%% struct 'DigitalWallet'
-type 'DigitalWallet'() :: #'merchstat_DigitalWallet'{}.

%% struct 'RussianBankAccount'
-type 'RussianBankAccount'() :: #'merchstat_RussianBankAccount'{}.

%% struct 'InternationalBankAccount'
-type 'InternationalBankAccount'() :: #'merchstat_InternationalBankAccount'{}.

%% struct 'StatInvoice'
-type 'StatInvoice'() :: #'merchstat_StatInvoice'{}.

%% struct 'InvoiceUnpaid'
-type 'InvoiceUnpaid'() :: #'merchstat_InvoiceUnpaid'{}.

%% struct 'InvoicePaid'
-type 'InvoicePaid'() :: #'merchstat_InvoicePaid'{}.

%% struct 'InvoiceCancelled'
-type 'InvoiceCancelled'() :: #'merchstat_InvoiceCancelled'{}.

%% struct 'InvoiceFulfilled'
-type 'InvoiceFulfilled'() :: #'merchstat_InvoiceFulfilled'{}.

%% union 'InvoiceStatus'
-type 'InvoiceStatus'() ::
    {'unpaid', 'InvoiceUnpaid'()} |
    {'paid', 'InvoicePaid'()} |
    {'cancelled', 'InvoiceCancelled'()} |
    {'fulfilled', 'InvoiceFulfilled'()}.

%% struct 'StatCustomer'
-type 'StatCustomer'() :: #'merchstat_StatCustomer'{}.

%% struct 'StatPayout'
-type 'StatPayout'() :: #'merchstat_StatPayout'{}.

%% struct 'CashFlowDescription'
-type 'CashFlowDescription'() :: #'merchstat_CashFlowDescription'{}.

%% union 'PayoutType'
-type 'PayoutType'() ::
    {'bank_card', 'PayoutCard'()} |
    {'bank_account', 'PayoutAccount'()}.

%% struct 'PayoutCard'
-type 'PayoutCard'() :: #'merchstat_PayoutCard'{}.

%% union 'PayoutAccount'
-type 'PayoutAccount'() ::
    {'russian_payout_account', 'RussianPayoutAccount'()} |
    {'international_payout_account', 'InternationalPayoutAccount'()}.

%% struct 'RussianPayoutAccount'
-type 'RussianPayoutAccount'() :: #'merchstat_RussianPayoutAccount'{}.

%% struct 'InternationalPayoutAccount'
-type 'InternationalPayoutAccount'() :: #'merchstat_InternationalPayoutAccount'{}.

%% union 'PayoutStatus'
-type 'PayoutStatus'() ::
    {'unpaid', 'PayoutUnpaid'()} |
    {'paid', 'PayoutPaid'()} |
    {'cancelled', 'PayoutCancelled'()} |
    {'confirmed', 'PayoutConfirmed'()}.

%% struct 'PayoutUnpaid'
-type 'PayoutUnpaid'() :: #'merchstat_PayoutUnpaid'{}.

%% struct 'PayoutPaid'
-type 'PayoutPaid'() :: #'merchstat_PayoutPaid'{}.

%% struct 'PayoutCancelled'
-type 'PayoutCancelled'() :: #'merchstat_PayoutCancelled'{}.

%% struct 'PayoutConfirmed'
-type 'PayoutConfirmed'() :: #'merchstat_PayoutConfirmed'{}.

%% struct 'StatRequest'
-type 'StatRequest'() :: #'merchstat_StatRequest'{}.

%% struct 'StatResponse'
-type 'StatResponse'() :: #'merchstat_StatResponse'{}.

%% union 'StatResponseData'
-type 'StatResponseData'() ::
    {'payments', ['StatPayment'()]} |
    {'invoices', ['StatInvoice'()]} |
    {'customers', ['StatCustomer'()]} |
    {'records', ['StatInfo'()]} |
    {'payouts', ['StatPayout'()]}.

%% exception 'DatasetTooBig'
-type 'DatasetTooBig'() :: #'merchstat_DatasetTooBig'{}.

%%
%% services and functions
%%
-type service_name() ::
    'MerchantStatistics'.

-type function_name() ::
    'MerchantStatistics_service_functions'().

-type 'MerchantStatistics_service_functions'() ::
    'GetPayments' |
    'GetInvoices' |
    'GetCustomers' |
    'GetPayouts' |
    'GetStatistics'.

-export_type(['MerchantStatistics_service_functions'/0]).


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
    'OnHoldExpiration'() |
    'TerminalPaymentProvider'() |
    'DigitalWalletProvider'() |
    'CashFlowType'().

-type enum_field_info() ::
    {enum_choice(), integer()}.
-type enum_info() ::
    {enum, [enum_field_info()]}.

-spec typedefs() -> [typedef_name()].

typedefs() ->
    [
        'DigitalWalletID',
        'PayoutID',
        'CashFlowDescriptions',
        'StatInfo',
        'InvalidRequest'
    ].

-spec enums() -> [enum_name()].

enums() ->
    [
        'OnHoldExpiration',
        'TerminalPaymentProvider',
        'DigitalWalletProvider',
        'CashFlowType'
    ].

-spec structs() -> [struct_name()].

structs() ->
    [
        'StatPayment',
        'Payer',
        'PaymentResourcePayer',
        'CustomerPayer',
        'InvoicePaymentFlow',
        'InvoicePaymentFlowInstant',
        'InvoicePaymentFlowHold',
        'OperationFailure',
        'OperationTimeout',
        'ExternalFailure',
        'InvoicePaymentPending',
        'InvoicePaymentProcessed',
        'InvoicePaymentCaptured',
        'InvoicePaymentCancelled',
        'InvoicePaymentRefunded',
        'InvoicePaymentFailed',
        'InvoicePaymentStatus',
        'PaymentTool',
        'BankCard',
        'PaymentTerminal',
        'DigitalWallet',
        'RussianBankAccount',
        'InternationalBankAccount',
        'StatInvoice',
        'InvoiceUnpaid',
        'InvoicePaid',
        'InvoiceCancelled',
        'InvoiceFulfilled',
        'InvoiceStatus',
        'StatCustomer',
        'StatPayout',
        'CashFlowDescription',
        'PayoutType',
        'PayoutCard',
        'PayoutAccount',
        'RussianPayoutAccount',
        'InternationalPayoutAccount',
        'PayoutStatus',
        'PayoutUnpaid',
        'PayoutPaid',
        'PayoutCancelled',
        'PayoutConfirmed',
        'StatRequest',
        'StatResponse',
        'StatResponseData'
    ].

-spec services() -> [service_name()].

services() ->
    [
        'MerchantStatistics'
    ].

-spec namespace() -> namespace().

namespace() ->
    'merchstat'.

-spec typedef_info(typedef_name()) -> field_type() | no_return().

typedef_info('DigitalWalletID') ->
    string;

typedef_info('PayoutID') ->
    string;

typedef_info('CashFlowDescriptions') ->
    {list, {struct, struct, {dmsl_merch_stat_thrift, 'CashFlowDescription'}}};

typedef_info('StatInfo') ->
    {map, string, string};

typedef_info('InvalidRequest') ->
    {struct, exception, {dmsl_base_thrift, 'InvalidRequest'}};

typedef_info(_) -> erlang:error(badarg).

-spec enum_info(enum_name()) -> enum_info() | no_return().

enum_info('OnHoldExpiration') ->
    {enum, [
        {'cancel', 0},
        {'capture', 1}
    ]};

enum_info('TerminalPaymentProvider') ->
    {enum, [
        {'euroset', 0}
    ]};

enum_info('DigitalWalletProvider') ->
    {enum, [
        {'qiwi', 0}
    ]};

enum_info('CashFlowType') ->
    {enum, [
        {'payment', 0},
        {'refund', 1}
    ]};

enum_info(_) -> erlang:error(badarg).

-spec struct_info(struct_name() | exception_name()) -> struct_info() | no_return().

struct_info('StatPayment') ->
    {struct, struct, [
    {1, required, string, 'id', undefined},
    {2, required, string, 'invoice_id', undefined},
    {3, required, string, 'owner_id', undefined},
    {4, required, string, 'shop_id', undefined},
    {5, required, string, 'created_at', undefined},
    {6, required, {struct, union, {dmsl_merch_stat_thrift, 'InvoicePaymentStatus'}}, 'status', undefined},
    {7, required, i64, 'amount', undefined},
    {8, required, i64, 'fee', undefined},
    {9, required, string, 'currency_symbolic_code', undefined},
    {10, required, {struct, union, {dmsl_merch_stat_thrift, 'Payer'}}, 'payer', undefined},
    {12, optional, {struct, struct, {dmsl_base_thrift, 'Content'}}, 'context', undefined},
    {13, optional, {struct, struct, {dmsl_geo_ip_thrift, 'LocationInfo'}}, 'location_info', undefined},
    {14, required, {struct, union, {dmsl_merch_stat_thrift, 'InvoicePaymentFlow'}}, 'flow', undefined}
]};

struct_info('Payer') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_merch_stat_thrift, 'PaymentResourcePayer'}}, 'payment_resource', undefined},
    {2, optional, {struct, struct, {dmsl_merch_stat_thrift, 'CustomerPayer'}}, 'customer', undefined}
]};

struct_info('PaymentResourcePayer') ->
    {struct, struct, [
    {1, required, {struct, union, {dmsl_merch_stat_thrift, 'PaymentTool'}}, 'payment_tool', undefined},
    {2, optional, string, 'ip_address', undefined},
    {3, optional, string, 'fingerprint', undefined},
    {4, optional, string, 'phone_number', undefined},
    {5, optional, string, 'email', undefined},
    {6, required, string, 'session_id', undefined}
]};

struct_info('CustomerPayer') ->
    {struct, struct, [
    {1, required, string, 'customer_id', undefined}
]};

struct_info('InvoicePaymentFlow') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_merch_stat_thrift, 'InvoicePaymentFlowInstant'}}, 'instant', undefined},
    {2, optional, {struct, struct, {dmsl_merch_stat_thrift, 'InvoicePaymentFlowHold'}}, 'hold', undefined}
]};

struct_info('InvoicePaymentFlowInstant') ->
    {struct, struct, []};

struct_info('InvoicePaymentFlowHold') ->
    {struct, struct, [
    {1, required, {enum, {dmsl_merch_stat_thrift, 'OnHoldExpiration'}}, 'on_hold_expiration', undefined},
    {2, required, string, 'held_until', undefined}
]};

struct_info('OperationFailure') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_merch_stat_thrift, 'OperationTimeout'}}, 'operation_timeout', undefined},
    {2, optional, {struct, struct, {dmsl_merch_stat_thrift, 'ExternalFailure'}}, 'external_failure', undefined}
]};

struct_info('OperationTimeout') ->
    {struct, struct, []};

struct_info('ExternalFailure') ->
    {struct, struct, [
    {1, required, string, 'code', undefined},
    {2, optional, string, 'description', undefined}
]};

struct_info('InvoicePaymentPending') ->
    {struct, struct, []};

struct_info('InvoicePaymentProcessed') ->
    {struct, struct, []};

struct_info('InvoicePaymentCaptured') ->
    {struct, struct, []};

struct_info('InvoicePaymentCancelled') ->
    {struct, struct, []};

struct_info('InvoicePaymentRefunded') ->
    {struct, struct, []};

struct_info('InvoicePaymentFailed') ->
    {struct, struct, [
    {1, required, {struct, union, {dmsl_merch_stat_thrift, 'OperationFailure'}}, 'failure', undefined}
]};

struct_info('InvoicePaymentStatus') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_merch_stat_thrift, 'InvoicePaymentPending'}}, 'pending', undefined},
    {4, optional, {struct, struct, {dmsl_merch_stat_thrift, 'InvoicePaymentProcessed'}}, 'processed', undefined},
    {2, optional, {struct, struct, {dmsl_merch_stat_thrift, 'InvoicePaymentCaptured'}}, 'captured', undefined},
    {5, optional, {struct, struct, {dmsl_merch_stat_thrift, 'InvoicePaymentCancelled'}}, 'cancelled', undefined},
    {6, optional, {struct, struct, {dmsl_merch_stat_thrift, 'InvoicePaymentRefunded'}}, 'refunded', undefined},
    {3, optional, {struct, struct, {dmsl_merch_stat_thrift, 'InvoicePaymentFailed'}}, 'failed', undefined}
]};

struct_info('PaymentTool') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_merch_stat_thrift, 'BankCard'}}, 'bank_card', undefined},
    {2, optional, {struct, struct, {dmsl_merch_stat_thrift, 'PaymentTerminal'}}, 'payment_terminal', undefined},
    {3, optional, {struct, struct, {dmsl_merch_stat_thrift, 'DigitalWallet'}}, 'digital_wallet', undefined}
]};

struct_info('BankCard') ->
    {struct, struct, [
    {1, required, string, 'token', undefined},
    {2, required, {enum, {dmsl_domain_thrift, 'BankCardPaymentSystem'}}, 'payment_system', undefined},
    {3, required, string, 'bin', undefined},
    {4, required, string, 'masked_pan', undefined}
]};

struct_info('PaymentTerminal') ->
    {struct, struct, [
    {1, required, {enum, {dmsl_merch_stat_thrift, 'TerminalPaymentProvider'}}, 'terminal_type', undefined}
]};

struct_info('DigitalWallet') ->
    {struct, struct, [
    {1, required, {enum, {dmsl_merch_stat_thrift, 'DigitalWalletProvider'}}, 'provider', undefined},
    {2, required, string, 'id', undefined}
]};

struct_info('RussianBankAccount') ->
    {struct, struct, [
    {1, required, string, 'account', undefined},
    {2, required, string, 'bank_name', undefined},
    {3, required, string, 'bank_post_account', undefined},
    {4, required, string, 'bank_bik', undefined}
]};

struct_info('InternationalBankAccount') ->
    {struct, struct, [
    {1, required, string, 'account_holder', undefined},
    {2, required, string, 'bank_name', undefined},
    {3, required, string, 'bank_address', undefined},
    {4, required, string, 'iban', undefined},
    {5, required, string, 'bic', undefined},
    {6, optional, string, 'local_bank_code', undefined}
]};

struct_info('StatInvoice') ->
    {struct, struct, [
    {1, required, string, 'id', undefined},
    {2, required, string, 'owner_id', undefined},
    {3, required, string, 'shop_id', undefined},
    {4, required, string, 'created_at', undefined},
    {5, required, {struct, union, {dmsl_merch_stat_thrift, 'InvoiceStatus'}}, 'status', undefined},
    {6, required, string, 'product', undefined},
    {7, optional, string, 'description', undefined},
    {8, required, string, 'due', undefined},
    {9, required, i64, 'amount', undefined},
    {10, required, string, 'currency_symbolic_code', undefined},
    {11, optional, {struct, struct, {dmsl_base_thrift, 'Content'}}, 'context', undefined},
    {12, optional, {struct, struct, {dmsl_domain_thrift, 'InvoiceCart'}}, 'cart', undefined}
]};

struct_info('InvoiceUnpaid') ->
    {struct, struct, []};

struct_info('InvoicePaid') ->
    {struct, struct, []};

struct_info('InvoiceCancelled') ->
    {struct, struct, [
    {1, required, string, 'details', undefined}
]};

struct_info('InvoiceFulfilled') ->
    {struct, struct, [
    {1, required, string, 'details', undefined}
]};

struct_info('InvoiceStatus') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_merch_stat_thrift, 'InvoiceUnpaid'}}, 'unpaid', undefined},
    {2, optional, {struct, struct, {dmsl_merch_stat_thrift, 'InvoicePaid'}}, 'paid', undefined},
    {3, optional, {struct, struct, {dmsl_merch_stat_thrift, 'InvoiceCancelled'}}, 'cancelled', undefined},
    {4, optional, {struct, struct, {dmsl_merch_stat_thrift, 'InvoiceFulfilled'}}, 'fulfilled', undefined}
]};

struct_info('StatCustomer') ->
    {struct, struct, [
    {1, required, string, 'id', undefined},
    {2, required, string, 'created_at', undefined}
]};

struct_info('StatPayout') ->
    {struct, struct, [
    {1, required, string, 'id', undefined},
    {2, required, string, 'party_id', undefined},
    {3, required, string, 'shop_id', undefined},
    {4, required, string, 'created_at', undefined},
    {5, required, {struct, union, {dmsl_merch_stat_thrift, 'PayoutStatus'}}, 'status', undefined},
    {6, required, i64, 'amount', undefined},
    {7, required, i64, 'fee', undefined},
    {8, required, string, 'currency_symbolic_code', undefined},
    {9, required, {struct, union, {dmsl_merch_stat_thrift, 'PayoutType'}}, 'type', undefined},
    {10, optional, {list, {struct, struct, {dmsl_merch_stat_thrift, 'CashFlowDescription'}}}, 'cash_flow_descriptions', undefined}
]};

struct_info('CashFlowDescription') ->
    {struct, struct, [
    {1, required, {struct, struct, {dmsl_domain_thrift, 'Cash'}}, 'cash', undefined},
    {2, optional, {struct, struct, {dmsl_domain_thrift, 'Cash'}}, 'fee', undefined},
    {3, required, string, 'from_time', undefined},
    {4, required, string, 'to_time', undefined},
    {5, required, {enum, {dmsl_merch_stat_thrift, 'CashFlowType'}}, 'cash_flow_type', undefined},
    {6, required, i32, 'count', undefined}
]};

struct_info('PayoutType') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_merch_stat_thrift, 'PayoutCard'}}, 'bank_card', undefined},
    {2, optional, {struct, union, {dmsl_merch_stat_thrift, 'PayoutAccount'}}, 'bank_account', undefined}
]};

struct_info('PayoutCard') ->
    {struct, struct, [
    {1, required, {struct, struct, {dmsl_merch_stat_thrift, 'BankCard'}}, 'card', undefined}
]};

struct_info('PayoutAccount') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_merch_stat_thrift, 'RussianPayoutAccount'}}, 'russian_payout_account', undefined},
    {2, optional, {struct, struct, {dmsl_merch_stat_thrift, 'InternationalPayoutAccount'}}, 'international_payout_account', undefined}
]};

struct_info('RussianPayoutAccount') ->
    {struct, struct, [
    {1, required, {struct, struct, {dmsl_merch_stat_thrift, 'RussianBankAccount'}}, 'bank_account', undefined},
    {2, required, string, 'inn', undefined},
    {3, required, string, 'purpose', undefined}
]};

struct_info('InternationalPayoutAccount') ->
    {struct, struct, [
    {1, required, {struct, struct, {dmsl_merch_stat_thrift, 'InternationalBankAccount'}}, 'bank_account', undefined},
    {2, required, string, 'purpose', undefined}
]};

struct_info('PayoutStatus') ->
    {struct, union, [
    {1, optional, {struct, struct, {dmsl_merch_stat_thrift, 'PayoutUnpaid'}}, 'unpaid', undefined},
    {2, optional, {struct, struct, {dmsl_merch_stat_thrift, 'PayoutPaid'}}, 'paid', undefined},
    {3, optional, {struct, struct, {dmsl_merch_stat_thrift, 'PayoutCancelled'}}, 'cancelled', undefined},
    {4, optional, {struct, struct, {dmsl_merch_stat_thrift, 'PayoutConfirmed'}}, 'confirmed', undefined}
]};

struct_info('PayoutUnpaid') ->
    {struct, struct, []};

struct_info('PayoutPaid') ->
    {struct, struct, []};

struct_info('PayoutCancelled') ->
    {struct, struct, [
    {1, required, string, 'details', undefined}
]};

struct_info('PayoutConfirmed') ->
    {struct, struct, []};

struct_info('StatRequest') ->
    {struct, struct, [
    {1, required, string, 'dsl', undefined}
]};

struct_info('StatResponse') ->
    {struct, struct, [
    {1, required, {struct, union, {dmsl_merch_stat_thrift, 'StatResponseData'}}, 'data', undefined},
    {2, optional, i32, 'total_count', undefined}
]};

struct_info('StatResponseData') ->
    {struct, union, [
    {1, optional, {list, {struct, struct, {dmsl_merch_stat_thrift, 'StatPayment'}}}, 'payments', undefined},
    {2, optional, {list, {struct, struct, {dmsl_merch_stat_thrift, 'StatInvoice'}}}, 'invoices', undefined},
    {3, optional, {list, {struct, struct, {dmsl_merch_stat_thrift, 'StatCustomer'}}}, 'customers', undefined},
    {4, optional, {list, {map, string, string}}, 'records', undefined},
    {5, optional, {list, {struct, struct, {dmsl_merch_stat_thrift, 'StatPayout'}}}, 'payouts', undefined}
]};

struct_info('DatasetTooBig') ->
    {struct, exception, [
    {1, undefined, i32, 'limit', undefined}
]};

struct_info(_) -> erlang:error(badarg).

-spec record_name(struct_name() | exception_name()) -> atom() | no_return().

record_name('StatPayment') ->
    'merchstat_StatPayment';

record_name('PaymentResourcePayer') ->
    'merchstat_PaymentResourcePayer';

    record_name('CustomerPayer') ->
    'merchstat_CustomerPayer';

    record_name('InvoicePaymentFlowInstant') ->
    'merchstat_InvoicePaymentFlowInstant';

    record_name('InvoicePaymentFlowHold') ->
    'merchstat_InvoicePaymentFlowHold';

    record_name('OperationTimeout') ->
    'merchstat_OperationTimeout';

    record_name('ExternalFailure') ->
    'merchstat_ExternalFailure';

    record_name('InvoicePaymentPending') ->
    'merchstat_InvoicePaymentPending';

    record_name('InvoicePaymentProcessed') ->
    'merchstat_InvoicePaymentProcessed';

    record_name('InvoicePaymentCaptured') ->
    'merchstat_InvoicePaymentCaptured';

    record_name('InvoicePaymentCancelled') ->
    'merchstat_InvoicePaymentCancelled';

    record_name('InvoicePaymentRefunded') ->
    'merchstat_InvoicePaymentRefunded';

    record_name('InvoicePaymentFailed') ->
    'merchstat_InvoicePaymentFailed';

    record_name('BankCard') ->
    'merchstat_BankCard';

    record_name('PaymentTerminal') ->
    'merchstat_PaymentTerminal';

    record_name('DigitalWallet') ->
    'merchstat_DigitalWallet';

    record_name('RussianBankAccount') ->
    'merchstat_RussianBankAccount';

    record_name('InternationalBankAccount') ->
    'merchstat_InternationalBankAccount';

    record_name('StatInvoice') ->
    'merchstat_StatInvoice';

    record_name('InvoiceUnpaid') ->
    'merchstat_InvoiceUnpaid';

    record_name('InvoicePaid') ->
    'merchstat_InvoicePaid';

    record_name('InvoiceCancelled') ->
    'merchstat_InvoiceCancelled';

    record_name('InvoiceFulfilled') ->
    'merchstat_InvoiceFulfilled';

    record_name('StatCustomer') ->
    'merchstat_StatCustomer';

    record_name('StatPayout') ->
    'merchstat_StatPayout';

    record_name('CashFlowDescription') ->
    'merchstat_CashFlowDescription';

    record_name('PayoutCard') ->
    'merchstat_PayoutCard';

    record_name('RussianPayoutAccount') ->
    'merchstat_RussianPayoutAccount';

    record_name('InternationalPayoutAccount') ->
    'merchstat_InternationalPayoutAccount';

    record_name('PayoutUnpaid') ->
    'merchstat_PayoutUnpaid';

    record_name('PayoutPaid') ->
    'merchstat_PayoutPaid';

    record_name('PayoutCancelled') ->
    'merchstat_PayoutCancelled';

    record_name('PayoutConfirmed') ->
    'merchstat_PayoutConfirmed';

    record_name('StatRequest') ->
    'merchstat_StatRequest';

    record_name('StatResponse') ->
    'merchstat_StatResponse';

    record_name('DatasetTooBig') ->
    'merchstat_DatasetTooBig';

    record_name(_) -> error(badarg).
    
    -spec functions(service_name()) -> [function_name()] | no_return().

functions('MerchantStatistics') ->
    [
        'GetPayments',
        'GetInvoices',
        'GetCustomers',
        'GetPayouts',
        'GetStatistics'
    ];

functions(_) -> error(badarg).

-spec function_info(service_name(), function_name(), params_type | reply_type | exceptions) ->
    struct_info() | no_return().

function_info('MerchantStatistics', 'GetPayments', params_type) ->
    {struct, struct, [
    {1, undefined, {struct, struct, {dmsl_merch_stat_thrift, 'StatRequest'}}, 'req', undefined}
]};
function_info('MerchantStatistics', 'GetPayments', reply_type) ->
        {struct, struct, {dmsl_merch_stat_thrift, 'StatResponse'}};
    function_info('MerchantStatistics', 'GetPayments', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_base_thrift, 'InvalidRequest'}}, 'ex1', undefined},
        {2, undefined, {struct, exception, {dmsl_merch_stat_thrift, 'DatasetTooBig'}}, 'ex2', undefined}
    ]};
function_info('MerchantStatistics', 'GetInvoices', params_type) ->
    {struct, struct, [
    {1, undefined, {struct, struct, {dmsl_merch_stat_thrift, 'StatRequest'}}, 'req', undefined}
]};
function_info('MerchantStatistics', 'GetInvoices', reply_type) ->
        {struct, struct, {dmsl_merch_stat_thrift, 'StatResponse'}};
    function_info('MerchantStatistics', 'GetInvoices', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_base_thrift, 'InvalidRequest'}}, 'ex1', undefined},
        {2, undefined, {struct, exception, {dmsl_merch_stat_thrift, 'DatasetTooBig'}}, 'ex2', undefined}
    ]};
function_info('MerchantStatistics', 'GetCustomers', params_type) ->
    {struct, struct, [
    {1, undefined, {struct, struct, {dmsl_merch_stat_thrift, 'StatRequest'}}, 'req', undefined}
]};
function_info('MerchantStatistics', 'GetCustomers', reply_type) ->
        {struct, struct, {dmsl_merch_stat_thrift, 'StatResponse'}};
    function_info('MerchantStatistics', 'GetCustomers', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_base_thrift, 'InvalidRequest'}}, 'ex1', undefined},
        {2, undefined, {struct, exception, {dmsl_merch_stat_thrift, 'DatasetTooBig'}}, 'ex2', undefined}
    ]};
function_info('MerchantStatistics', 'GetPayouts', params_type) ->
    {struct, struct, [
    {1, undefined, {struct, struct, {dmsl_merch_stat_thrift, 'StatRequest'}}, 'req', undefined}
]};
function_info('MerchantStatistics', 'GetPayouts', reply_type) ->
        {struct, struct, {dmsl_merch_stat_thrift, 'StatResponse'}};
    function_info('MerchantStatistics', 'GetPayouts', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_base_thrift, 'InvalidRequest'}}, 'ex1', undefined},
        {2, undefined, {struct, exception, {dmsl_merch_stat_thrift, 'DatasetTooBig'}}, 'ex2', undefined}
    ]};
function_info('MerchantStatistics', 'GetStatistics', params_type) ->
    {struct, struct, [
    {1, undefined, {struct, struct, {dmsl_merch_stat_thrift, 'StatRequest'}}, 'req', undefined}
]};
function_info('MerchantStatistics', 'GetStatistics', reply_type) ->
        {struct, struct, {dmsl_merch_stat_thrift, 'StatResponse'}};
    function_info('MerchantStatistics', 'GetStatistics', exceptions) ->
        {struct, struct, [
        {1, undefined, {struct, exception, {dmsl_base_thrift, 'InvalidRequest'}}, 'ex1', undefined},
        {2, undefined, {struct, exception, {dmsl_merch_stat_thrift, 'DatasetTooBig'}}, 'ex2', undefined}
    ]};

function_info(_Service, _Function, _InfoType) -> erlang:error(badarg).
