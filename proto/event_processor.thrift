include "base.thrift"
include "domain.thrift"
include "payment_processing.thrift"

namespace java com.rbkmoney.damsel.event_processor

struct EventInfo{
    1: required payment_processing.Event event
    2: required domain.Party party
    3: required domain.ProxyOptions options = []
}

service EventProcessor {
    void Process (1: EventInfo event_info)
        throws (1: base.TryLater ex1)
}
