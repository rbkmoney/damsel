include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.proxy_merch_config
namespace erlang proxy_merch_config

struct MerchantProxyParams {
    1: required string callback_url
}

struct MerchantProxyConfiguration {
    1: required string callback_url
    2: required string pub_key
}

service ConfigureMerchantProxy {
    domain.ProxyOptions CreateOptions(1: MerchantProxyParams merchant_proxy_params) throws (1: base.InvalidRequest ex1)
    MerchantProxyConfiguration RenderOptions(1: domain.ProxyOptions proxy_options) throws (1: base.InvalidRequest ex1)
}