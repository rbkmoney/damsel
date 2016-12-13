include "domain.thrift"
include "proxy_provider.thrift"

namespace java com.rbkmoney.damsel.proxy_merch
namespace erlang proxy_merch

struct ShopOptions {
    1: required string callback_url
    2: required string priv_key
}

service MerchantProxy {
    void sendCallback(1: domain.ProxyOptions proxyOptions, 2: proxy_provider.Context context)
}