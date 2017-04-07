    include "domain.thrift"
    include "base.thrift"

    namespace java com.rbkmoney.damsel.walker
    namespace erlang walker

    typedef i64 ClaimID

    // *** Copy of Party Management ***
    typedef domain.PartyID PartyID
    typedef domain.ShopID  ShopID

    /* В эластико нет Party с таким идентификатором */
    exception PartyNotFound {}

     service Elastico {
        /**
        * Получить информацию об организации по ее идентификатору
        **/
        domain.Party getPartyById(1: String partyId) throws (1: PartyNotFound ex1)

        /**
        * Возвращает список организаций содержащих в описнаии или любых других поля данный текст.
        **/
        List<domain.Party> searchParty(1: String text)
    }
