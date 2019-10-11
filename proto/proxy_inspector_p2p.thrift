include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.proxy_inspector_p2p
namespace erlang proxy_inspector_p2p

/**
 * Набор данных для взаимодействия с инспекторским прокси.
 */
struct Context {
    1: required P2PInfo p2p
    2: optional domain.ProxyOptions options = {}
}

/**
 * Данные перевода, необходимые для инспекции перевода.
 */
struct P2PInfo {
    1: required Identity identity
    2: required P2P p2p
}

struct Identity {
    1: required base.ID identity_id
}

struct P2P {
    1: required base.ID id
    2: required base.Timestamp created_at
    3: required P2PPayer payer_from
    4: required P2PPayer payer_to
    5: required domain.Cash cost
}

union P2PPayer {
    1: P2PInstrument instrument
    2: P2PRaw raw
}

struct P2PInstrument {
    1: required base.ID instrument_id
    2: required base.Timestamp created_at
    3: required domain.Payer payer
    4: required P2PInstrumentStatus status
}

union P2PInstrumentStatus {
    1: Authorized       authorized
    2: Unauthorized     unauthorized
}

struct Authorized {}
struct Unauthorized {}

struct P2PRaw {
    1: required domain.Payer payer
}

struct InspectResult {
    1: required map<domain.RiskType, domain.RiskScore> scores
}

service InspectorProxy {
    InspectResult InspectPayment (1: Context context, 2: list<domain.RiskType> risk_types)
        throws (1: base.InvalidRequest ex1)
}
