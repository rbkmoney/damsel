    include "domain.thrift"
    include "base.thrift"

    namespace java com.rbkmoney.damsel.walker
    namespace erlang walker

    typedef i64 ClaimID

    // *** Copy of Party Management ***
    typedef domain.PartyID PartyID
    typedef domain.ShopID  ShopID

    struct PartyParams {
        1: required domain.PartyContactInfo contact_info
    }

    struct PayoutToolParams {
        1: required domain.CurrencyRef currency
        2: required domain.PayoutToolInfo tool_info
    }

    struct ShopParams {
        6: required domain.ShopLocation location
        2: required domain.ShopDetails details
        3: required domain.ContractID contract_id
        4: required domain.PayoutToolID payout_tool_id
    }

    struct ShopAccountParams {
        1: required domain.CurrencyRef currency
    }

    struct ContractParams {
        1: required domain.Contractor contractor
        2: optional domain.ContractTemplateRef template
        3: required PayoutToolParams payout_tool_params
    }

    struct ContractAdjustmentParams {
        1: required domain.ContractTemplateRef template
    }

    union PartyModification {
        4: ContractModificationUnit contract_modification
        6: ShopModificationUnit shop_modification
    }

    struct ContractModificationUnit {
        1: required domain.ContractID id
        2: required ContractModification modification
    }

    union ContractModification {
        1: ContractParams creation
        2: ContractTermination termination
        3: ContractAdjustmentModificationUnit adjustment_modification
        4: PayoutToolModificationUnit payout_tool_modification
        5: domain.LegalAgreement legal_agreement_binding
    }

    struct ContractTermination {
        1: required string terminated_at
        2: optional string reason
    }

    struct ContractAdjustmentModificationUnit {
        1: required base.ID adjustment_id
        2: required ContractAdjustmentModification modification
    }

    union ContractAdjustmentModification {
        1: ContractAdjustmentParams creationContractAdjustmentID
    }

    struct PayoutToolModificationUnit {
        1: required domain.PayoutToolID payout_tool_id
        2: required PayoutToolModification modification
    }

    union PayoutToolModification {
        1: PayoutToolParams creation
    }

    struct ShopModificationUnit {
        1: required ShopID id
        2: required ShopModification modification
    }

    union ShopModification {
        5: ShopParams creation
        6: domain.CategoryRef category_modification
        7: domain.ShopDetails details_modification
        8: ShopContractModification contract_modification
        9: domain.PayoutToolID payout_tool_modification
        10: ProxyModification proxy_modification
        11: domain.ShopLocation location_modification
        12: ShopAccountParams shop_account_creation
    }

    struct ShopContractModification {
        1: required domain.ContractID contract_id
        2: required domain.PayoutToolID payout_tool_id
    }

    struct ProxyModification {
        1: optional domain.Proxy proxy
    }
    // *** end ***


    //Контейнер для хранения всех ченжсетов
    struct PartyModificationUnit {
         1: required list<PartyModification> modifications
    }

    union  ActionModification {
        1: StatusChanged status_changed
        2: Assigned assigned
        3: CommentAdded comment_added
        4: ClaimChengsest claim_chengsest
    }

    struct StatusChanged{
        1: optional string before
        2: required string after
    }

    struct Assigned{
        1: optional string before
        2: required string after
    }

    struct CommentAdded{
        1: required string text;
    }

    struct ClaimChengsest {
        1: optional  PartyModificationUnit before;
        2: required PartyModificationUnit after;

    }

    struct ClaimInfo {
         1: required ClaimID claimID
         2: required string status
         3: optional string assigned
         4: optional string description
         5: required PartyModificationUnit modifications
    }

    struct ClaimSearchRequest {
        1: required UserInfo user_info
        2: optional set<ClaimID> claimID
        3: optional string contains
        4: optional string assigned
    }

    struct Comment {
        1: required string text
        2: required string created_at
        3: required string user_id
    }

    /**
    * Действия связанные с клеймом - история событий
    **/
    struct Action {
        1: required string created_at
        2: required UserInfo user
        3: required ActionModification modifications
    }


    struct UserInfo{
        1: required string userID
        2: optional string user_name
        3: optional string email
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
        * Получить информацию о заявке
        **/
        ClaimInfo GetClaim(1: ClaimID claimID, 2: UserInfo user)

        /**
        * Создать заявку
        **/
        void CreateClaim (1: UserInfo user, 2: PartyID party_id, 3: PartyModificationUnit changeset)

        /**
        * Передает список изменений для заявки
        **/
        void UpdateClaim(1: ClaimID claimID, 2: UserInfo user, 3: PartyModificationUnit changeset)

        /**
        * Поиск заявки по атрибутам
        **/
        list<ClaimInfo> SearchClaims(1: ClaimSearchRequest request)

        /**
        * Добавить комментарий к заявке
        **/
        void AddComment(1: ClaimID claimId,  2: UserInfo user, 3: string text)

        /**
        * Получить список комментариев к заявке
        **/
        list<Comment> GetComments(1: ClaimID claimId, 2: UserInfo user)

        /**
        * Получитить историю событий связанных с заявкой
        **/
        list<Action> GetActions(1: ClaimID claimId, 2: UserInfo user)
    }
