    include "domain.thrift"
    include "base.thrift"

    namespace java com.rbkmoney.damsel.elastico
    namespace erlang elastico

    typedef domain.PartyID PartyID
    typedef domain.ShopID  ShopID

    /* В эластико нет Party с таким идентификатором */
    exception PartyNotFound {}

     service Elastico {
        /**
        * Получить информацию об организации по ее идентификатору
        **/
        domain.Party getPartyById(1: string partyId) throws (1: PartyNotFound ex1)

        /**
        * Возвращает список организаций содержащих в описании или любых других полях данный текст.
        **/
        list<domain.Party> searchParty(1: string text)
    }
