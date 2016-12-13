include "domain.thrift"
include "proxy_provider.thrift"

namespace java com.rbkmoney.damsel.proxy_merch
namespace erlang proxy_merch

service MerchantProxy {
    void sendCallback(1: domain.ProxyOptions proxyOptions, 2: proxy_provider.Context context)
}