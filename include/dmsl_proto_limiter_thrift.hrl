-ifndef(dmsl_proto_limiter_thrift_included__).
-define(dmsl_proto_limiter_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_domain_thrift.hrl").



%% struct 'Limit'
-record('proto_limiter_Limit', {
    'id' :: dmsl_proto_limiter_thrift:'LimitID'(),
    'cash' :: dmsl_domain_thrift:'Cash'(),
    'creation_time' :: dmsl_base_thrift:'Timestamp'() | undefined,
    'reload_time' :: dmsl_base_thrift:'Timestamp'() | undefined,
    'description' :: binary() | undefined
}).

%% struct 'LimitChange'
-record('proto_limiter_LimitChange', {
    'id' :: dmsl_proto_limiter_thrift:'LimitID'(),
    'change_id' :: dmsl_proto_limiter_thrift:'LimitChangeID'(),
    'cash' :: dmsl_domain_thrift:'Cash'(),
    'operation_timestamp' :: dmsl_base_thrift:'Timestamp'()
}).

%% exception 'LimitNotFound'
-record('proto_limiter_LimitNotFound', {}).

%% exception 'LimitChangeNotFound'
-record('proto_limiter_LimitChangeNotFound', {}).

%% exception 'InconsistentLimitCurrency'
-record('proto_limiter_InconsistentLimitCurrency', {
    'limit_currency' :: dmsl_domain_thrift:'CurrencySymbolicCode'(),
    'change_currency' :: dmsl_domain_thrift:'CurrencySymbolicCode'()
}).

%% exception 'ForbiddenOperationAmount'
-record('proto_limiter_ForbiddenOperationAmount', {
    'amount' :: dmsl_domain_thrift:'Cash'(),
    'allowed_range' :: dmsl_domain_thrift:'CashRange'()
}).

-endif.
