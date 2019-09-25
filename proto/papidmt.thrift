include "domain_config.thrift"

namespace java com.rbkmoney.damsel.papidmt
namespace erlang papidmt

struct HistoryWrapper {
    1: required domain_config.History history
}
