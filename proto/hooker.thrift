include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.hooker
namespace erlang hooker

typedef string Url

struct WebHook {
    1: required ConsumerEvent consumer_event
    2: required Url url
}

/**
* Вебхуки могут быть отправлены магазину или участнику
**/
union ConsumerEvent {
    1: ShopEvent shop_event
    2: PartyEvent party_event
}

struct ShopEvent {
    1: required domain.ShopID shop_id
    2: required ShopEventType shop_event_type
}

/*
    Типы событий для магазина
 */
enum ShopEventType {
    invoice_created
    invoice_paid
}

struct PartyEvent {
    1: required domain.PartyID party_id
    2: required PartyEventType party_event_type
}

/**
    Типы событий для участника
 */
enum PartyEventType {
    shop_created
}

service Hooker {
    list<WebHook> GetShopWebHooks(1: domain.ShopID id)
    list<WebHook> GetPartyWebHooks(1: domain.PartyID id)
    void CreateHook(1: WebHook web_hook)
    void DeleteHook(1: WebHook web_hook)
}
