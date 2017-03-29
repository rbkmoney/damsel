include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.webhooker
namespace erlang webhooker

typedef string Url

struct Webhook {
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

service Webhooker {
    list<Webhook> GetShopWebhooks(1: domain.ShopID id)
    list<Webhook> GetPartyWebhooks(1: domain.PartyID id)
    void CreateHook(1: Webhook web_hook)
    void DeleteHook(1: Webhook web_hook)
}
