    include "domain.thrift"

    namespace java com.rbkmoney.damsel.walker
    namespace erlang walker

    typedef i64 ClaimID

    // -- Copy of Party Management
    typedef list<PartyModification> PartyChangeset
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
        1: optional domain.CategoryRef category
        2: required domain.ShopDetails details
        6: required domain.ShopLocation location
        3: required domain.ContractID contract_id
        4: required domain.PayoutToolID payout_tool_id
        5: optional domain.Proxy proxy
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
        5: ContractParams creation
        1: ContractTermination termination
        2: domain.ContractAdjustment adjustment_creation
        3: domain.PayoutTool payout_tool_creation
        4: domain.LegalAgreement legal_agreement_binding
    }

    struct ContractTermination {
        1: required string terminated_at
        2: optional string reason
    }


    struct ShopModificationUnit {
        1: required ShopID id
        2: required ShopModification modification
    }

    union ShopModification {
        5: ShopParams creation
        6: domain.CategoryRef category
        7: domain.ShopDetails details
        8: domain.ContractID contract_id
        9: domain.PayoutToolID payout_tool_id
        10: domain.Proxy proxy
        11: domain.ShopLocation location
        4: domain.ShopAccount account_creation
    }
    // -- end --

    struct ClaimInfo {
         1: required ClaimID claimID
         2: required string status
         3: required PartyChangeset changeset
    }

    struct ClaimSearchRequest {
        1: required UserInfo user_info
        2: optional set<ClaimID> claimID
        3: optional string contains
        4: optional string assigned
    }

    struct Comment {
        1: string text
        2: string created_at
        3: string user_id
    }

    /**
    * Действия связанные с клеймом - история событий
    **/
    struct Action {
        1: string created_at
        2: string user_id
        3: string userName
        4: list<Modification> modifications
    }

     struct Modification {
            1: string before
            2: string after
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
           void UpdateClaim(1: ClaimID claimID, 2: UserInfo user, 3: PartyChangeset changeset)

           /**
            * Получить информацию о заявке
            **/
           ClaimInfo GetClaim(1: ClaimID claimID, 2: UserInfo user)

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
           list<Action> GetEvents(1: ClaimID claimId, 2: UserInfo user)
    }
