include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.proxy_merch
namespace erlang proxy_merch

struct Secret {
    1: required string pubKey
    2: required string privKey
}

struct ShopOptions {
    1: required domain.ShopID shopId
    2: required string callbackUrl
    3: required Secret secret
}

service ConfigureMerchantProxy {
    ShopOptions createOptions(1: domain.ShopID shopId, 2: string callbackUrl)
    string renderOptions(1: ShopOptions options)
}

service MerchantProxy {
    void confirmPayment(1: ShopOptions options)
}