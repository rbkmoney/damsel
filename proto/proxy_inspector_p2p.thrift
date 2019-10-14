include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.p2p_insp
namespace erlang p2p_insp

typedef base.ID ContractID
typedef base.ID ProviderID
typedef base.ID ClassID
typedef base.ID LevelID

/**
 * Набор данных для взаимодействия с инспекторским прокси.
 */
struct Context {
    1: required Info info
    2: optional domain.ProxyOptions options = {}
}

/**
 * Данные перевода, необходимые для инспекции перевода.
 */
struct Info {
    1: required Identity identity
    2: required Transfer transfer
}

struct Identity {
    1: required base.ID identity_id
    2: required ProviderID provider_id
    3: required ClassID class_id
    4: optional LevelID level_id
    5: optional ContractID contract_id
}

struct Transfer {
    1: required base.ID id
    2: required base.Timestamp created_at
    3: required Payer sender
    4: required Payer receiver
    5: required domain.Cash cost
}

union Payer {
    1: Raw raw
}

struct Raw {
    1: required domain.Payer payer
}

struct InspectResult {
    1: required map<domain.ScoreID, domain.RiskScore> scores
}

service InspectorProxy {
    InspectResult InspectTransfer (1: Context context, 2: list<domain.ScoreID> risk_types)
        throws (1: base.InvalidRequest ex1)
}
