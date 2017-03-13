    include "domain.thrift"
    include "payment_processing.thrift"

    namespace java com.rbkmoney.damsel.walker
    namespace erlang walker

    typedef i64 ClaimID

    struct ClaimInfo {
         1: required ClaimID claimID
         2: required payment_processing.ClaimStatus status
    }

    struct ClaimSearchRequest {
        1: required UserInfo userInfo
        2: optional set<ClaimID> claimID
        3: optional string contains
        4: optional string assigned

    }

    struct Comment {
        1: string text
        2: string createdAt
        3: string userId
    }

   struct Modification {
        1: string fieldName
        2: string valueFrom
        3: string valueTo
    }

    struct Event {
        1: string createdAt
        2: string userId
        3: string userName
        4: list<Modification> modifications
    }

    struct UserInfo{
        1: string userID
        2: string userName
        3: string email
    }


     service Walker {

           /**
           * Подтвердить и применить заявку пользователя
           **/
           void ApproveClaim(1: ClaimID claimID)

           /**
           * Отклонить заявку
           **/
           void DeclineClaim(1: ClaimID claimID, 2: UserInfo user, 3: string reason)

           /**
           * Передает список изменений для заявки
           **/
           void UpdateClaim(1: ClaimID claimID, 2: UserInfo user, 3: string changeset)

           /**
            * Получить информацию о заявке
            **/
           ClaimInfo GetClaim(1: ClaimID claimID, 2: UserInfo user)

           /**
           * Поиск заявки по атрибутам
           **/
           list<ClaimInfo> searchClaims(ClaimSearchRequest request)

           /**
           * Добавить комментарий к заявке
           **/
           void AddComment(1: ClaimID claimId,  2: UserInfo user, 2: String text)

           /**
           * Получить список комментариев к заявке
           **/
           list<Comment> GetComments(1: ClaimID claimId, 2: UserInfo user)

           /**
           * Получитить историю событий связанных с заявкой
           **/
           list<Event> getEvents(1: ClaimID claimId, 2: UserInfo user)

    }
