include "base.thrift"
include "payment_processing.thrift"

namespace java com.rbkmoney.damsel.proxy_merchant

service MerchantProxy {
    void ProcessEvent (1: payment_processing.Event event)
        throws (1: base.TryLater ex1)
}
