include 'base.thrift'
include 'domain.thrift'

namespace java com.rbkmoney.damsel.accounter
namespace erlang accounter
typedef base.ID PlanID
typedef i64 BatchID
typedef i64 AccountID

struct AccountPrototype {
    1: required domain.CurrencySymbolicCode currency_sym_code
    2: optional string description
}

struct Account {
    1: required AccountID id
    2: required domain.Amount own_amount
    3: required domain.Amount max_available_amount
    4: required domain.Amount min_available_amount
    5: required domain.CurrencySymbolicCode currency_sym_code
    6: optional string description
}

struct Posting {
    1: required AccountID from_id
    2: required AccountID to_id
    3: required domain.Amount amount
    4: required domain.CurrencySymbolicCode currency_sym_code
    5: required string description
}

struct PostingBatch {
    1: required BatchID id
    2: required list<Posting> postings
}

struct PostingPlan {
    1: required PlanID id
    2: required list<PostingBatch> batchList
}

struct PostingPlanChange {
   1: required PlanID id
   2: required PostingBatch batch
}

struct PostingPlanLog {
    1: required PostingPlanChange planChange
    2: optional map<AccountID, Account> affected_accounts
}

exception AccountNotFound {
    1: required AccountID account_id
}

exception PlanNotFound {
    1: required PlanID plan_id
}

/**
* Возникает в случае, если переданы некорректные параметры в одной или нескольких проводках
*/
exception InvalidPostingParams {
    1: required map<Posting, string> wrong_postings
}

service Accounter {
    PostingPlanLog Hold(1: PostingPlanChange planChange) throws (1:InvalidPostingParams e1, 2:base.InvalidRequest e2)
    PostingPlanLog CommitPlan(1: PostingPlan plan) throws (1:InvalidPostingParams e1, 2:base.InvalidRequest e2)
    PostingPlanLog RollbackPlan(1: PostingPlan plan) throws (1:InvalidPostingParams e1, 2:base.InvalidRequest e2)
    PostingPlan GetPlan(1: PlanID id) throws (1: PlanNotFound e1)
    Account GetAccountByID(1: AccountID id) throws (1:AccountNotFound ex)
    AccountID CreateAccount(1: AccountPrototype prototype) throws (1:base.InvalidRequest e1)
}