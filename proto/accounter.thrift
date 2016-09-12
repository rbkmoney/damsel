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

struct Account {
    1: required AccountID id
    2: required domain.Amount own_amount
    3: required domain.Amount available_amount
    4: required domain.CurrencyRef currency_ref
    5: optional string description
}

struct Posting {
    1: required AccountID from_id
    2: required AccountID to_id
    3: required domain.Amount amount
    4: required domain.CurrencyRef currency_ref
    5: required string description
}

struct PostingPlan {
    1: required PlanID id
    2: required list<Posting> batch
}

struct PostingLog {
    1: required PostingID id
    2: required PlanID plan_id
    3: required base.Timestamp created_at
    4: required PostingOperation operation
    5: required Posting posting
}

struct PostingPlanLog {
    1: required PlanID id
    2: required PostingLogs batch_log
    3: required map<AccountID, Account> affected_accounts
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
    PostingPlanLog HoldPlan(1: PostingPlan plan) throws (1:InvalidPostingParams e1, 2:base.InvalidRequest e2)
    PostingPlanLog CommitPlan(1: PostingPlan plan) throws (1:InvalidPostingParams e1, 2:base.InvalidRequest e2)
    PostingPlanLog RollbackPlan(1: PostingPlan plan) throws (1:InvalidPostingParams e1, 2:base.InvalidRequest e2)
    PostingLogs GetPostingLogs(1: PlanID id) throws (1: PlanNotFound e1, 2:base.InvalidRequest e2)
    AccountID CreateAccount(1: Account prototype) throws (1:base.InvalidRequest e1)
    Account GetAccountByID(1: AccountID id) throws (1:AccountNotFound ex)
}