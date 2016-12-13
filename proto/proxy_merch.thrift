include "domain.thrift"

namespace java com.rbkmoney.damsel.proxy_merch
namespace erlang proxy_merch

service MerchantProxy {
    void confirmPayment(1: domain.ProxyOptions options)
}