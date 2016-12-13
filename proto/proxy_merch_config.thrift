include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.proxy_merch
namespace erlang proxy_merch

struct MerchantProxyParams {
    1: required string callback_url
}

struct MerchantProxyConfiguration {
    1: required string callback_url
    2: required string pub_key
}

service ConfigureMerchantProxy {
    domain.ProxyOptions createOptions(1: MerchantProxyParams merchant_proxy_params)
    MerchantProxyConfiguration renderOptions(1: domain.ProxyOptions proxy_options)
}