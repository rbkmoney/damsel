include 'base.thrift'
include 'domain.thrift'

namespace java com.rbkmoney.damsel.accounter
namespace erlang accounter
typedef i64 PlanId
typedef i64 PostingId
typedef i64 AccountId
typedef list<PostingLog> PostingLogs

enum PostingOperation {
    HOLD,
    COMMIT,
    ROLLBACK
}

struct Account {
1: required AccountId id
2: required domain.Amount amount
3: required domain.CurrencyRef currency_ref
4: optional string description
}

struct Posting {
1: required AccountId from
2: required AccountId to
3: required domain.Amount amount
4: required domain.CurrencyRef currency_ref
5: required string description
}

struct PostingPlan {
1: required PlanId id
2: required list<Posting> batch
}

struct PostingLog {
1: required PostingId id
2: required PlanId plan_id
3: required base.Timestamp created_at
4: required PostingOperation operation
5: required Posting posting
}

struct PostingPlanLog {
1: required PlanId id
2: required PostingLogs batch_log
3: required map<AccountId, Account> affected_accounts
}

exception NoSuchAccount {
 1: required AccountId account_id
 }

exception NoSuchPlan {
1: required PlanId plan_id
}

/**
* Возникает в случае, если переданы некорректные параметры в одной или нескольких проводках
*/
exception WrongPostingParams {
1: required map<Posting, string> wrong_postings
2: optional string reason;
}


service Accounter {
PostingPlanLog HoldPlan(1: PostingPlan plan) throws (1:WrongPostingParams e1, 4:base.InvalidRequest e2)
PostingPlanLog CommitPlan(1: PostingPlan plan) throws (1:WrongPostingParams e1, 4:base.InvalidRequest e2)
PostingPlanLog RollbackPlan(1: PostingPlan plan) throws (1:WrongPostingParams e1, 4:base.InvalidRequest e2)
PostingLogs getPostingLogs(1: PlanId id) throws (1: NoSuchPlan e1, 2:base.InvalidRequest e2)

AccountId createAccount(1: Account prototype) throws (1:base.InvalidRequest e1)
Account getAccountById(1: AccountId id) throws (1:NoSuchAccount ex)

}