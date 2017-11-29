    include "domain.thrift"
    include "base.thrift"
    include "payment_processing.thrift"

    namespace java com.rbkmoney.damsel.walker
    namespace erlang walker

    typedef i64 ClaimID
    typedef domain.PartyID PartyID
    typedef domain.ShopID  ShopID



    //Контейнер для хранения всех ченжсетов
    struct PartyModificationUnit {
         1: required list<payment_processing.PartyModification> modifications
    }

    enum ActionType {
        assigned,
        comment,
        status_changed,
        claim_changed
    }

    struct ClaimInfo {
         // id мерчанта
         1: required string party_id
         // идентификатор заявки в рамках орги
         2: required ClaimID claim_id
         // статус Claim-a
         3: required string status
         // id пользователя на каторого назначенная заявка
         4: optional string assigned_user_id
         //текстовое описание заявки
         5: optional string description
         // причина отмены или отзыва завяки
         6: optional string reason
         // полный набор изменений Claim-a
         7: required PartyModificationUnit modifications
         // ревизия Claim-a
         8: required string revision
         // создан
         9: required string created_at
         // обновлен
         10: required string updated_at
    }

    struct ClaimSearchRequest {
        1: optional string party_id
        2: optional set<ClaimID> claim_id
        3: optional string contains
        4: optional string assigned_user_id
        5: optional string claim_status
    }

    struct Comment {
        1: required string text
        2: required string created_at
        3: required UserInformation user
    }

    /**
    * Действия связанные с клеймом - история событий
    **/
    struct Action {
        1: required string created_at
        2: required UserInformation user
        3: required ActionType type
        4: optional string before
        5: required string after
    }


    struct UserInformation{
        1: required string userID
        2: optional string user_name
        3: optional string email
    }

    exception ClaimNotFound {}
    exception InvalidClaimRevision {}
    exception ChangesetConflict{}
    exception InvalidClaimStatus {
        1: required string status
    }

     service Walker {
        /**
        * Подтвердить и применить заявку пользователя
        **/
        void AcceptClaim(1: string party_id, 2: ClaimID claim_id, 3: UserInformation user 4: i32 revision) throws (
            1: payment_processing.InvalidUser ex1,
            2: payment_processing.PartyNotFound ex2,
            3: ClaimNotFound ex3,
            4: InvalidClaimStatus ex4,
            5: InvalidClaimRevision ex5,
            6: payment_processing.InvalidChangeset ex6
        )
        /**
        * Отклонить заявку
        **/
        void DenyClaim(1: string party_id, 2: ClaimID claim_id, 3: UserInformation user, 4: string reason 5: i32 revision) throws (
            1: payment_processing.InvalidUser ex1,
            2: payment_processing.PartyNotFound ex2,
            3: ClaimNotFound ex3,
            4: InvalidClaimStatus ex4,
            5: InvalidClaimRevision ex5)
        /**
        * Получить информацию о заявке
        **/
        ClaimInfo GetClaim(1: string party_id, 2: ClaimID claim_id) throws (
            1: payment_processing.InvalidUser ex1,
            2: payment_processing.PartyNotFound ex2,
            3: ClaimNotFound ex3)

        /**
        * Создать заявку
        **/
        payment_processing.Claim CreateClaim (1: UserInformation user, 2: PartyID party_id, 3: PartyModificationUnit changeset) throws (
            1: payment_processing.InvalidUser ex1,
            2: payment_processing.PartyNotFound ex2,
            3: payment_processing.InvalidPartyStatus ex3,
            4: ChangesetConflict ex4,
            5: payment_processing.InvalidChangeset ex5,
            6: base.InvalidRequest ex6)

        /**
        * Передает список изменений для заявки
        **/
        void UpdateClaim(1: string party_id, 2: ClaimID claim_id, 3: UserInformation user, 4: PartyModificationUnit changeset, 5: i32 revision) throws (
            1: payment_processing.InvalidUser ex1,
            2: payment_processing.PartyNotFound ex2,
            3: payment_processing.InvalidPartyStatus ex3,
            4: ClaimNotFound ex4,
            5: InvalidClaimStatus ex5,
            6: InvalidClaimRevision ex6,
            7: ChangesetConflict ex7,
            8: payment_processing.InvalidChangeset ex8,
            9: base.InvalidRequest ex9
        )

        /**
        * Поиск заявки по атрибутам
        **/
        list<ClaimInfo> SearchClaims(1: ClaimSearchRequest request)

        /**
        * Добавить комментарий к заявке
        **/
        void AddComment(1: string party_id, 2: ClaimID claim_id,  3: UserInformation user, 4: string text)

        /**
        * Получить список комментариев к заявке
        **/
        list<Comment> GetComments(1: string party_id, 2: ClaimID claim_id)

        /**
        * Получитить историю событий связанных с заявкой
        **/
        list<Action> GetActions(1: string party_id, 2: ClaimID claim_id)
    }
