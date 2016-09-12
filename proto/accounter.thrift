include 'base.thrift'
include 'domain.thrift'

namespace java com.rbkmoney.damsel.accounter
namespace erlang accounter
typedef base.ID PlanID
typedef i64 PostingID
typedef i64 AccountID
typedef list<PostingLog> PostingLogs

enum PostingOperation {
    HOLD,
    COMMIT,
    ROLLBACK
}

struct AccountPrototype {
    1: required domain.CurrencyID currency_id
    2: optional string description
}

struct Account {
    1: required AccountID id
    2: required domain.Amount own_amount
    3: required domain.Amount available_amount
    4: required domain.CurrencyID currency_id
    5: optional string description
}

struct Posting {
    1: required PostingID id
    2: required AccountID from_id
    3: required AccountID to_id
    4: required domain.Amount amount
    5: required domain.CurrencyID currency_id
    6: required PostingOperation operation
    8: required string description
}

struct PostingPlan {
    1: required PlanID id
    2: required list<Posting> batch
}

struct PostingLog {
    1: required base.Timestamp created_at
    2: required Posting posting
}

struct PostingPlanLog {
    4: required PostingPlan plan
    5: optional map<AccountID, Account> affected_accounts
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
    PostingPlanLog Hold(1: PostingPlan plan) throws (1:InvalidPostingParams e1, 2:base.InvalidRequest e2)
    PostingPlanLog CommitPlan(1: PostingPlan plan) throws (1:InvalidPostingParams e1, 2:base.InvalidRequest e2)
    PostingPlanLog RollbackPlan(1: PostingPlan plan) throws (1:InvalidPostingParams e1, 2:base.InvalidRequest e2)
    PostingPlan GetPlan(1: PlanID id) throws (1: PlanNotFound e1, 2:base.InvalidRequest e2)
    AccountID CreateAccount(1: AccountPrototype prototype) throws (1:base.InvalidRequest e1)
    Account GetAccountByID(1: AccountID id) throws (1:AccountNotFound ex)
}