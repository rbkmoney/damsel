include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.proxy_merch
namespace erlang proxy_merch

struct Secret {
    1: required binary pub_key
    2: required binary priv_key
}

struct ShopOptions {
    1: required domain.ShopID shop_id
    2: required String callback_url
    3: required Secret secret
}

service ConfigureMerchantProxy {
    ShopOptions createOptions(domain.ShopID shop_id, String callback_url)
    String renderOptions(ShopOptions options)
}

service MerchantProxy {
    void confirmPayment(ShopOptions options)
}