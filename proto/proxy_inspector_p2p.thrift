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
    1: required TransferInfo info
    2: optional domain.ProxyOptions options = {}
}

/**
 * Данные перевода, необходимые для инспекции перевода.
 */
struct TransferInfo {
    1: required Transfer transfer
}

struct Transfer {
    1: required base.ID id
    2: required Identity identity
    3: required base.Timestamp created_at
    4: required Payer sender
    5: required Payer receiver
    6: required domain.Cash cost
}

struct Identity {
    1: required base.ID id
}

union Payer {
    /**
    *   Данные плательщика полученные на старте операции и не привязанные к сущностям системы
    */
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
