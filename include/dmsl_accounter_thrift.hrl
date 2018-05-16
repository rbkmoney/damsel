-ifndef(dmsl_accounter_thrift_included__).
-define(dmsl_accounter_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_domain_thrift.hrl").



%% struct 'AccountPrototype'
-record('accounter_AccountPrototype', {
    'currency_sym_code' :: dmsl_domain_thrift:'CurrencySymbolicCode'(),
    'description' :: binary() | undefined,
    'creation_time' :: dmsl_base_thrift:'Timestamp'() | undefined
}).

%% struct 'Account'
-record('accounter_Account', {
    'id' :: dmsl_accounter_thrift:'AccountID'(),
    'own_amount' :: dmsl_domain_thrift:'Amount'(),
    'max_available_amount' :: dmsl_domain_thrift:'Amount'(),
    'min_available_amount' :: dmsl_domain_thrift:'Amount'(),
    'currency_sym_code' :: dmsl_domain_thrift:'CurrencySymbolicCode'(),
    'description' :: binary() | undefined,
    'creation_time' :: dmsl_base_thrift:'Timestamp'() | undefined
}).

%% struct 'Posting'
-record('accounter_Posting', {
    'from_id' :: dmsl_accounter_thrift:'AccountID'(),
    'to_id' :: dmsl_accounter_thrift:'AccountID'(),
    'amount' :: dmsl_domain_thrift:'Amount'(),
    'currency_sym_code' :: dmsl_domain_thrift:'CurrencySymbolicCode'(),
    'description' :: binary()
}).

%% struct 'PostingBatch'
-record('accounter_PostingBatch', {
    'id' :: dmsl_accounter_thrift:'BatchID'(),
    'postings' :: [dmsl_accounter_thrift:'Posting'()]
}).

%% struct 'PostingPlan'
-record('accounter_PostingPlan', {
    'id' :: dmsl_accounter_thrift:'PlanID'(),
    'batch_list' :: [dmsl_accounter_thrift:'PostingBatch'()]
}).

%% struct 'PostingPlanChange'
-record('accounter_PostingPlanChange', {
    'id' :: dmsl_accounter_thrift:'PlanID'(),
    'batch' :: dmsl_accounter_thrift:'PostingBatch'()
}).

%% struct 'PostingPlanLog'
-record('accounter_PostingPlanLog', {
    'affected_accounts' :: #{dmsl_accounter_thrift:'AccountID'() => dmsl_accounter_thrift:'Account'()}
}).

%% exception 'AccountNotFound'
-record('accounter_AccountNotFound', {
    'account_id' :: dmsl_accounter_thrift:'AccountID'()
}).

%% exception 'PlanNotFound'
-record('accounter_PlanNotFound', {
    'plan_id' :: dmsl_accounter_thrift:'PlanID'()
}).

%% exception 'InvalidPostingParams'
-record('accounter_InvalidPostingParams', {
    'wrong_postings' :: #{dmsl_accounter_thrift:'Posting'() => binary()}
}).

-endif.
