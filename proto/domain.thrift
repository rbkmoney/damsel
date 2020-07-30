/**
 * Определения предметной области.
 */

include "base.thrift"
include "msgpack.thrift"
include "json.thrift"

namespace java com.rbkmoney.damsel.domain
namespace erlang domain

typedef i64        DataRevision
typedef i32        ObjectID
typedef json.Value Metadata

/* Common */

/** Контактная информация. **/
struct ContactInfo {
    1: optional string phone_number
    2: optional string email
}

union OperationFailure {
    1: OperationTimeout operation_timeout
    2: Failure          failure
}

struct OperationTimeout {}

/**
 * "Динамическое" представление ошибки,
 * должно использоваться только для передачи,
 * для интерпретации нужно использовать конвертацию в типизированный вид.
 *
 * Если при попытке интерпретировать код через типизированный вид происходит ошибка (нет такого типа),
 * то это означает, что ошибка неизвестна, и такую ситуацию нужно уметь обрабатывать
 * (например просто отдать неизветсную ошибку наверх).
 *
 * Старые ошибки совместимы с новыми и будут читаться.
 * Структура осталась та же, только поле description переименовалось в reason,
 * и добавилось поле sub.
 * В результате для старых ошибок description будет в reason, а в code будет код ошибки
 * (который будет интропретирован как неизвестная ошибка).
 *
 */
struct Failure {
    1: required FailureCode     code;

    2: optional FailureReason   reason;
    3: optional SubFailure      sub;
}

typedef string FailureCode;
typedef string FailureReason; // причина возникшей ошибки и пояснение откуда она взялась

// возможность делать коды ошибок иерархическими
struct SubFailure {
    1: required FailureCode  code;
    2: optional SubFailure   sub;
}

/** Сумма в минимальных денежных единицах. */
typedef i64 Amount

/** Номер счёта. */
typedef i64 AccountID

/** Денежные средства, состоящие из суммы и валюты. */
struct Cash {
    1: required Amount amount
    2: required CurrencyRef currency
}

/* Contractor transactions */

struct TransactionInfo {
    1: required string id
    2: optional base.Timestamp timestamp
    3: required base.StringMap extra
    4: optional AdditionalTransactionInfo additional_info
}

struct AdditionalTransactionInfo {
    1: optional string rrn // Retrieval Reference Number
    2: optional string approval_code // Authorization Approval Code
    3: optional string acs_url // Issuer Access Control Server (ACS)
    4: optional string pareq // Payer Authentication Request (PAReq)
    5: optional string md // Merchant Data
    6: optional string term_url // Upon success term_url callback is called with following form encoded params
    7: optional string pares // Payer Authentication Response (PARes)
    8: optional string eci // Electronic Commerce Indicator
    9: optional string cavv // Cardholder Authentication Verification Value
    10: optional string xid // 3D Secure transaction identifier
    11: optional string cavv_algorithm // Indicates algorithm used to generate CAVV
    12: optional ThreeDsVerification three_ds_verification
}

/**
* Issuer Authentication Results Values
**/
enum ThreeDsVerification {
    authentication_successful // Y
    attempts_processing_performed // A
    authentication_failed // N
    authentication_could_not_be_performed // U
}

/* Invoices */

typedef base.ID InvoiceID
typedef base.ID InvoiceAdjustmentID
typedef base.ID InvoicePaymentID
typedef base.ID InvoicePaymentChargebackID
typedef base.ID InvoicePaymentRefundID
typedef base.ID InvoicePaymentAdjustmentID
typedef base.Content InvoiceContext
typedef base.Content InvoicePaymentContext
typedef base.Content InvoicePaymentChargebackContext
typedef string PaymentSessionID
typedef string Fingerprint
typedef string IPAddress
typedef string RecurrentPaymentToolDesc
typedef string RecurrentPaymentToolResourceID

struct Invoice {
    1 : required InvoiceID id
    2 : required PartyID owner_id
    13: optional PartyRevision party_revision
    3 : required ShopID shop_id
    4 : required base.Timestamp created_at
    6 : required InvoiceStatus status
    7 : required InvoiceDetails details
    8 : required base.Timestamp due
    10: required Cash cost
    11: optional InvoiceContext context
    12: optional InvoiceTemplateID template_id
    14: optional string external_id
}

struct InvoiceDetails {
    1: required string product
    2: optional string description
    3: optional InvoiceCart cart
}

struct InvoiceCart {
    1: required list<InvoiceLine> lines
}

struct InvoiceLine {
    1: required string product
    2: required i32 quantity
    3: required Cash price
    /* Taxes and other stuff goes here */
    4: required map<string, msgpack.Value> metadata
}

struct InvoiceUnpaid    {}
struct InvoicePaid      {}
struct InvoiceCancelled { 1: required string details }
struct InvoiceFulfilled { 1: required string details }

union InvoiceStatus {
    1: InvoiceUnpaid unpaid
    2: InvoicePaid paid
    3: InvoiceCancelled cancelled
    4: InvoiceFulfilled fulfilled
}

struct InvoicePayment {
    1:  required InvoicePaymentID id
    2:  required base.Timestamp created_at
    3:  required InvoicePaymentStatus status
    6:  optional InvoicePaymentContext context
    8:  required Cash cost
    10: required DataRevision domain_revision
    13: required InvoicePaymentFlow flow
    14: required Payer payer
    15: optional PartyRevision party_revision
    16: optional PartyID owner_id
    17: optional ShopID shop_id
    18: optional bool make_recurrent
    19: optional string external_id
    20: optional base.Timestamp processing_deadline
    21: optional RecurrentPaymentToolDesc rec_payment_tool_description
}

struct InvoicePaymentPending   {}
struct InvoicePaymentProcessed {}
struct InvoicePaymentCaptured  {
    1: optional string reason
    2: optional Cash cost
    3: optional InvoiceCart cart
}
struct InvoicePaymentCancelled { 1: optional string reason }
struct InvoicePaymentRefunded  {}
struct InvoicePaymentFailed    { 1: required OperationFailure failure }

struct InvoicePaymentChargedBack {}

/**
 * Шаблон инвойса.
 * Согласно https://github.com/rbkmoney/coredocs/blob/0a5ae1a79f977be3134c3b22028631da5225d407/docs/domain/entities/invoice.md#шаблон-инвойса
 */

typedef base.ID InvoiceTemplateID

struct InvoiceTemplate {
    1:  required InvoiceTemplateID id
    2:  required PartyID owner_id
    3:  required ShopID shop_id
    5:  required LifetimeInterval invoice_lifetime
    9:  required string product # for backward compatibility
    10: optional string description
    8:  required InvoiceTemplateDetails details
    7:  optional InvoiceContext context
}

union InvoiceTemplateDetails {
    1: InvoiceCart cart
    2: InvoiceTemplateProduct product
}

struct InvoiceTemplateProduct {
    1: required string product
    2: required InvoiceTemplateProductPrice price
    3: required map<string, msgpack.Value> metadata
}

union InvoiceTemplateProductPrice {
    1: Cash fixed
    2: CashRange range
    3: InvoiceTemplateCostUnlimited unlim
}

struct InvoiceTemplateCostUnlimited {}

/**
 * Статус платежа.
 */
union InvoicePaymentStatus {
    1: InvoicePaymentPending pending
    4: InvoicePaymentProcessed processed
    2: InvoicePaymentCaptured captured
    5: InvoicePaymentCancelled cancelled
    6: InvoicePaymentRefunded refunded
    3: InvoicePaymentFailed failed
    7: InvoicePaymentChargedBack charged_back
}

/**
 * Целевое значение статуса платежа.
 */
union TargetInvoicePaymentStatus {

    /**
     * Платёж обработан.
     *
     * При достижении платежом этого статуса процессинг должен обладать:
     *  - фактом того, что провайдер _по крайней мере_ авторизовал списание денежных средств в
     *    пользу системы;
     *  - данными транзакции провайдера.
     */
    1: InvoicePaymentProcessed processed

    /**
     * Платёж подтверждён.
     *
     * При достижении платежом этого статуса процессинг должен быть уверен в том, что провайдер
     * _по крайней мере_ подтвердил финансовые обязательства перед системой.
     */
    2: InvoicePaymentCaptured captured

    /**
     * Платёж отменён.
     *
     * При достижении платежом этого статуса процессинг должен быть уверен в том, что провайдер
     * аннулировал неподтверждённое списание денежных средств.
     *
     * В случае, если в рамках сессии проведения платежа провайдер авторизовал, но _ещё не
     * подтвердил_ списание средств, эта цель является обратной цели `processed`. В ином случае
     * эта цель недостижима, и взаимодействие в рамках сессии должно завершится с ошибкой.
     */
    3: InvoicePaymentCancelled cancelled

    /**
     * Платёж возвращён.
     *
     * При достижении платежом этого статуса процессинг должен быть уверен в том, что провайдер
     * возвратил денежные средства плательщику, потраченные им в ходе подтверждённого списания.
     *
     * Если эта цель недостижима, взаимодействие в рамках сессии должно завершится с ошибкой.
     */
    4: InvoicePaymentRefunded refunded
}

union Payer {
    1: PaymentResourcePayer payment_resource
    2: CustomerPayer        customer
    3: RecurrentPayer       recurrent
}

struct PaymentResourcePayer {
    1: required DisposablePaymentResource resource
    2: required ContactInfo               contact_info
}

struct CustomerPayer {
    1: required CustomerID             customer_id
    2: required CustomerBindingID      customer_binding_id
    3: required RecurrentPaymentToolID rec_payment_tool_id
    4: required PaymentTool            payment_tool
    5: required ContactInfo            contact_info
}

struct RecurrentPayer {
    1: required PaymentTool            payment_tool
    2: required RecurrentParentPayment recurrent_parent
    3: required ContactInfo            contact_info
}

struct ClientInfo {
    1: optional IPAddress ip_address
    2: optional Fingerprint fingerprint
}

struct PaymentRoute {
    1: required ProviderRef provider
    2: required TerminalRef terminal
}

struct RecurrentParentPayment {
    1: required InvoiceID invoice_id
    2: required InvoicePaymentID payment_id
}

/* Adjustments */

struct InvoiceAdjustment {
    1: required InvoiceAdjustmentID id
    2: required string reason
    3: required base.Timestamp created_at
    4: required InvoiceAdjustmentStatus status
    5: required DataRevision domain_revision
    6: optional PartyRevision party_revision
    7: optional InvoiceAdjustmentState state
}

struct InvoiceAdjustmentPending   {}
struct InvoiceAdjustmentProcessed {}
struct InvoiceAdjustmentCaptured  { 1: required base.Timestamp at }
struct InvoiceAdjustmentCancelled { 1: required base.Timestamp at }

union InvoiceAdjustmentStatus {
    1: InvoiceAdjustmentPending   pending
    2: InvoiceAdjustmentCaptured  captured
    3: InvoiceAdjustmentCancelled cancelled
    4: InvoiceAdjustmentProcessed processed
}

/**
 * Специфическое для выбранного сценария состояние поправки к инвойсу.
 */
union InvoiceAdjustmentState {
    1: InvoiceAdjustmentStatusChangeState status_change
}

struct InvoiceAdjustmentStatusChangeState {
    1: required InvoiceAdjustmentStatusChange scenario
}

/**
 * Параметры поправки к инвойсу, используемые для смены его статуса.
 */
struct InvoiceAdjustmentStatusChange {
    /** Статус, в который необходимо перевести инвойс. */
    1: required InvoiceStatus target_status
}

struct InvoicePaymentAdjustment {
    1: required InvoicePaymentAdjustmentID id
    2: required InvoicePaymentAdjustmentStatus status
    3: required base.Timestamp created_at
    4: required DataRevision domain_revision
    5: required string reason
    6: required FinalCashFlow new_cash_flow
    7: required FinalCashFlow old_cash_flow_inverse
    8: optional PartyRevision party_revision
    9: optional InvoicePaymentAdjustmentState state
}

struct InvoicePaymentAdjustmentPending   {}
struct InvoicePaymentAdjustmentProcessed {}
struct InvoicePaymentAdjustmentCaptured  { 1: required base.Timestamp at }
struct InvoicePaymentAdjustmentCancelled { 1: required base.Timestamp at }

union InvoicePaymentAdjustmentStatus {
    1: InvoicePaymentAdjustmentPending     pending
    2: InvoicePaymentAdjustmentCaptured   captured
    3: InvoicePaymentAdjustmentCancelled cancelled
    4: InvoicePaymentAdjustmentProcessed processed
}

/**
 * Специфическое для выбранного сценария состояние поправки к платежу.
 */
union InvoicePaymentAdjustmentState {
    1: InvoicePaymentAdjustmentCashFlowState cash_flow
    2: InvoicePaymentAdjustmentStatusChangeState status_change
}

struct InvoicePaymentAdjustmentCashFlowState {
    1: required InvoicePaymentAdjustmentCashFlow scenario
}

struct InvoicePaymentAdjustmentStatusChangeState {
    1: required InvoicePaymentAdjustmentStatusChange scenario
}

/**
 * Параметры поправки к платежу, используемые для пересчёта графа финансовых потоков.
 */
struct InvoicePaymentAdjustmentCashFlow {
    /** Ревизия, относительно которой необходимо пересчитать граф финансовых потоков. */
    1: optional DataRevision domain_revision
}

/**
 * Параметры поправки к платежу, используемые для смены его статуса.
 */
struct InvoicePaymentAdjustmentStatusChange {
    /** Статус, в который необходимо перевести платёж. */
    1: required InvoicePaymentStatus target_status
}

/**
 * Процесс выполнения платежа.
 */
union InvoicePaymentFlow {
    1: InvoicePaymentFlowInstant instant
    2: InvoicePaymentFlowHold hold
}

struct InvoicePaymentFlowInstant   {}

struct InvoicePaymentFlowHold {
    1: required OnHoldExpiration on_hold_expiration
    2: required base.Timestamp held_until
}

enum OnHoldExpiration {
    cancel
    capture
}

/* Chargebacks */

struct InvoicePaymentChargeback {
     1: required InvoicePaymentChargebackID      id
     2: required InvoicePaymentChargebackStatus  status
     3: required base.Timestamp                  created_at
     4: required InvoicePaymentChargebackReason  reason
     5: required Cash                            levy
     6: required Cash                            body
     7: required InvoicePaymentChargebackStage   stage
     8: required DataRevision                    domain_revision
     9: optional PartyRevision                   party_revision
    10: optional InvoicePaymentChargebackContext context
    11: optional string                          external_id
}

typedef string ChargebackCode

struct InvoicePaymentChargebackReason {
    1: optional ChargebackCode code
    2: required InvoicePaymentChargebackCategory category
}

union InvoicePaymentChargebackCategory {
    /* The Fraud category is used for reason codes related to fraudulent transactions.
       Reason codes related to no cardholder authorization, EMV liability, Card Present
       and Card Not Present fraud are all found within the Fraud category. */
    1: InvoicePaymentChargebackCategoryFraud           fraud

    /* Consumer Disputes represent chargebacks initiated by the cardholder
       in regards to product, service, or merchant issues.
       Consumer Disputes are also referred to as Cardholder Disputes,
       Card Member Disputes, and Service chargebacks.
       The reasons for disputes categorized under Consumer Disputes are varied;
       and can include circumstances like goods not received to cancelled recurring billing. */
    2: InvoicePaymentChargebackCategoryDispute         dispute

    /* Authorisation chargebacks represent disputes related to authorization issues.
       For example, transactions where authorization was required, but not obtained.
       They can also represent disputes where an Authorisation Request received a Decline
       or Pickup Response and the merchant completed the transaction anyway. */
    3: InvoicePaymentChargebackCategoryAuthorisation   authorisation

    /* Processing Errors, also referred to as Point-of-Interaction Errors,
       categorize reason codes representing disputes including duplicate processing,
       late presentment, credit processed as charge, invalid card numbers,
       addendum/“no show” disputes, incorrect charge amounts, and other similar situations. */
    4: InvoicePaymentChargebackCategoryProcessingError processing_error
}

struct InvoicePaymentChargebackCategoryFraud           {}
struct InvoicePaymentChargebackCategoryDispute         {}
struct InvoicePaymentChargebackCategoryAuthorisation   {}
struct InvoicePaymentChargebackCategoryProcessingError {}

union InvoicePaymentChargebackStage {
    1: InvoicePaymentChargebackStageChargeback     chargeback
    2: InvoicePaymentChargebackStagePreArbitration pre_arbitration
    3: InvoicePaymentChargebackStageArbitration    arbitration
}

struct InvoicePaymentChargebackStageChargeback     {}
struct InvoicePaymentChargebackStagePreArbitration {}
struct InvoicePaymentChargebackStageArbitration    {}

union InvoicePaymentChargebackStatus {
    1: InvoicePaymentChargebackPending   pending
    2: InvoicePaymentChargebackAccepted  accepted
    3: InvoicePaymentChargebackRejected  rejected
    4: InvoicePaymentChargebackCancelled cancelled
}

struct InvoicePaymentChargebackPending   {}
struct InvoicePaymentChargebackAccepted  {}
struct InvoicePaymentChargebackRejected  {}
struct InvoicePaymentChargebackCancelled {}

/* Refunds */

struct InvoicePaymentRefund {
    1: required InvoicePaymentRefundID id
    2: required InvoicePaymentRefundStatus status
    3: required base.Timestamp created_at
    4: required DataRevision domain_revision
    7: optional PartyRevision party_revision
    6: optional Cash cash
    5: optional string reason
    8: optional InvoiceCart cart
    9: optional string external_id
}

union InvoicePaymentRefundStatus {
    1: InvoicePaymentRefundPending pending
    2: InvoicePaymentRefundSucceeded succeeded
    3: InvoicePaymentRefundFailed failed
}

struct InvoicePaymentRefundPending {}
struct InvoicePaymentRefundSucceeded {}

struct InvoicePaymentRefundFailed {
    1: required OperationFailure failure
}

/* Blocking and suspension */

union Blocking {
    1: Unblocked unblocked
    2: Blocked   blocked
}

struct Unblocked {
    1: required string reason
    2: required base.Timestamp since
}

struct Blocked {
    1: required string reason
    2: required base.Timestamp since
}

union Suspension {
    1: Active    active
    2: Suspended suspended
}

struct Active {
    1: required base.Timestamp since
}

struct Suspended {
    1: required base.Timestamp since
}

/* Parties */

typedef base.ID PartyID
typedef i64 PartyRevision

typedef string PartyMetaNamespace
typedef msgpack.Value PartyMetaData
typedef map<PartyMetaNamespace, PartyMetaData> PartyMeta

/** Участник. */
struct Party {
    1: required PartyID id
    7: required PartyContactInfo contact_info
    8: required base.Timestamp created_at
    2: required Blocking blocking
    3: required Suspension suspension
    9: required map<ContractorID, PartyContractor> contractors
    4: required map<ContractID, Contract> contracts
    5: required map<ShopID, Shop> shops
    10: required map<WalletID, Wallet> wallets
    6: required PartyRevision revision
}

/** Статусы участника **/
/** Данная структура используется только для получения статусов Участника **/

struct PartyStatus {
    1: required PartyID id
    2: required Blocking blocking
    3: required Suspension suspension
    4: required PartyRevision revision
}

struct PartyContactInfo {
    1: required string email
}

/* Shops */

typedef base.ID ShopID

/** Магазин мерчанта. */
struct Shop {
    1: required ShopID id
   11: required base.Timestamp created_at
    2: required Blocking blocking
    3: required Suspension suspension
    4: required ShopDetails details
   10: required ShopLocation location
    5: required CategoryRef category
    6: optional ShopAccount account
    7: required ContractID contract_id
    8: optional PayoutToolID payout_tool_id
   12: optional BusinessScheduleRef payout_schedule
}

struct ShopAccount {
    1: required CurrencyRef currency
    2: required AccountID settlement
    3: required AccountID guarantee
    /* Аккаунт на который выводятся деньги из системы */
    4: required AccountID payout
}

struct ShopDetails {
    1: required string name
    2: optional string description
}

union ShopLocation {
    1: string url
}

/** RBKM Wallets **/

typedef base.ID WalletID

struct Wallet {
    1: required WalletID id
    2: optional string name
    3: required base.Timestamp created_at
    4: required Blocking blocking
    5: required Suspension suspension
    6: required ContractID contract
    7: optional WalletAccount account
}

struct WalletAccount {
    1: required CurrencyRef currency
    2: required AccountID settlement

    // TODO
    // ?????
    3: required AccountID payout
}

/* Инспекция платежа */

enum RiskScore {
    low = 1
    high = 100
    fatal = 9999
}

typedef base.ID ScoreID

/* Contracts */

typedef base.ID ContractorID
typedef base.Opaque IdentityDocumentToken

struct PartyContractor {
    1: required ContractorID id
    2: required Contractor contractor
    3: required ContractorIdentificationLevel status
    4: required list<IdentityDocumentToken> identity_documents
}

/** Лицо, выступающее стороной договора. */
union Contractor {
    2: RegisteredUser registered_user
    1: LegalEntity legal_entity
    3: PrivateEntity private_entity
}

struct RegisteredUser {
    1: required string email
}

union LegalEntity {
    1: RussianLegalEntity russian_legal_entity
    2: InternationalLegalEntity international_legal_entity
}

// TODO refactor with RepresentativePerson
/** Юридическое лицо-резидент РФ */
struct RussianLegalEntity {
    /* Наименование */
    1: required string registered_name
    /* ОГРН */
    2: required string registered_number
    /* ИНН/КПП */
    3: required string inn
    /* Адрес места нахождения */
    4: required string actual_address
    /* Адрес для отправки корреспонденции (почтовый) */
    5: required string post_address
    /* Наименование должности ЕИО/представителя */
    6: required string representative_position
    /* ФИО ЕИО/представителя */
    7: required string representative_full_name
    /* Наименование документа, на основании которого действует ЕИО/представитель */
    8: required string representative_document
    /* Реквизиты юр.лица */
    9: required RussianBankAccount russian_bank_account
}

struct InternationalLegalEntity {
    /* Наименование */
    1: required string legal_name
    /* Торговое наименование (если применимо) */
    2: optional string trading_name
    /* Адрес места регистрации */
    3: required string registered_address
    /* Адрес места нахождения (если отличается от регистрации)*/
    4: optional string actual_address
    /* Регистрационный номер */
    5: optional string registered_number
}

enum ContractorIdentificationLevel {
    none = 100
    partial = 200
    full = 300
}

/** Банковский счёт. */

struct RussianBankAccount {
    1: required string account
    2: required string bank_name
    3: required string bank_post_account
    4: required string bank_bik
}

struct InternationalBankAccount {

    // common
    6: optional string                   number
    7: optional InternationalBankDetails bank
    8: optional InternationalBankAccount correspondent_account

    // sources
    4: optional string iban           // International Bank Account Number (ISO 13616)

    // deprecated
    1: optional string account_holder // we have `InternationalLegalEntity.legal_name` for that purpose
}

struct InternationalBankDetails {

    // common
    1: optional string    bic         // Business Identifier Code (ISO 9362)
    2: optional Residence country
    3: optional string    name
    4: optional string    address

    // sources
    5: optional string    aba_rtn     // ABA Routing Transit Number

}

struct WalletInfo {
    1: required WalletID wallet_id
}

union PrivateEntity {
    1: RussianPrivateEntity russian_private_entity
}

struct RussianPrivateEntity {
    1: required string first_name
    2: required string second_name
    3: required string middle_name
    4: required ContactInfo contact_info
}

typedef base.ID PayoutToolID

struct PayoutTool {
    1: required PayoutToolID id
    4: required base.Timestamp created_at
    2: required CurrencyRef currency
    3: required PayoutToolInfo payout_tool_info
}

union PayoutToolInfo {
    1: RussianBankAccount russian_bank_account
    2: InternationalBankAccount international_bank_account
    3: WalletInfo wallet_info
}

typedef base.ID ContractID

/** Договор */
struct Contract {
    1: required ContractID id
    14: optional ContractorID contractor_id
    12: optional PaymentInstitutionRef payment_institution
    11: required base.Timestamp created_at
    4: optional base.Timestamp valid_since
    5: optional base.Timestamp valid_until
    6: required ContractStatus status
    7: required TermSetHierarchyRef terms
    8: required list<ContractAdjustment> adjustments
    // TODO think about it
    // looks like payout tools are a bit off here,
    // maybe they should be directly in party
    9: required list<PayoutTool> payout_tools
    10: optional LegalAgreement legal_agreement
    13: optional ReportPreferences report_preferences
    // deprecated
    3: optional Contractor contractor
}

/** Юридическое соглашение */
struct LegalAgreement {
    1: required base.Timestamp signed_at
    2: required string legal_agreement_id
    3: optional base.Timestamp valid_until
}

struct ReportPreferences {
    1: optional ServiceAcceptanceActPreferences service_acceptance_act_preferences
}

struct ServiceAcceptanceActPreferences {
    1: required BusinessScheduleRef schedule
    2: required Representative signer
}

struct Representative {
    /* Наименование должности ЕИО/представителя */
    1: required string position
    /* ФИО ЕИО/представителя */
    2: required string full_name
    /* Документ, на основании которого действует ЕИО/представитель */
    3: required RepresentativeDocument document
}

union RepresentativeDocument {
    1: ArticlesOfAssociation articles_of_association    // устав
    2: LegalAgreement power_of_attorney                // доверенность
}

struct ArticlesOfAssociation {}

union ContractStatus {
    1: ContractActive active
    2: ContractTerminated terminated
    3: ContractExpired expired
}

struct ContractActive {}
struct ContractTerminated { 1: required base.Timestamp terminated_at }
struct ContractExpired {}

/* Categories */

struct CategoryRef { 1: required ObjectID id }

enum CategoryType {
    test
    live
}

/** Категория продаваемых товаров или услуг. */
struct Category {
    1: required string name
    2: required string description
    3: optional CategoryType type = CategoryType.test
}

struct ContractTemplateRef { 1: required ObjectID id }

/** Шаблон договора или поправки **/
struct ContractTemplate {
    4: optional string name
    5: optional string description
    1: optional Lifetime valid_since
    2: optional Lifetime valid_until
    3: required TermSetHierarchyRef terms
}

union Lifetime {
    1: base.Timestamp timestamp
    2: LifetimeInterval interval
}

struct LifetimeInterval {
    1: optional i16 years
    2: optional i16 months
    3: optional i16 days
    4: optional i16 hours
    5: optional i16 minutes
    6: optional i16 seconds
}

union ContractTemplateSelector {
    1: list<ContractTemplateDecision> decisions
    2: ContractTemplateRef value
}

struct ContractTemplateDecision {
    1: required Predicate if_
    2: required ContractTemplateSelector then_
}

/** Поправки к договору **/
typedef base.ID ContractAdjustmentID

struct ContractAdjustment {
    1: required ContractAdjustmentID id
    5: required base.Timestamp created_at
    2: optional base.Timestamp valid_since
    3: optional base.Timestamp valid_until
    4: required TermSetHierarchyRef terms
}

/** Условия **/
// Service
//   Payments
//     Regular
//     Held
//     Recurring
//     ...
//   Payouts
//   ...

struct TermSet {
    1: optional PaymentsServiceTerms payments
    2: optional RecurrentPaytoolsServiceTerms recurrent_paytools
    3: optional PayoutsServiceTerms payouts
    4: optional ReportsServiceTerms reports
    5: optional WalletServiceTerms wallets
}

struct TimedTermSet {
    1: required base.TimestampInterval action_time
    2: required TermSet terms
}

struct TermSetHierarchy {
    3: optional string name
    4: optional string description
    1: optional TermSetHierarchyRef parent_terms
    2: required list<TimedTermSet> term_sets
}

struct TermSetHierarchyRef { 1: required ObjectID id }

/* Payments service terms */

struct PaymentsServiceTerms {
     /* Shop level */
     // TODO It looks like you belong to the better place, something they call `AccountsServiceTerms`.
     1: optional CurrencySelector currencies
     2: optional CategorySelector categories
     /* Invoice level*/
     4: optional PaymentMethodSelector payment_methods
     5: optional CashLimitSelector cash_limit
     /* Payment level */
     6: optional CashFlowSelector fees
     9: optional PaymentHoldsServiceTerms holds
     8: optional PaymentRefundsServiceTerms refunds
    10: optional PaymentChargebackServiceTerms chargebacks
}

struct PaymentHoldsServiceTerms {
    1: optional PaymentMethodSelector payment_methods
    2: optional HoldLifetimeSelector lifetime
    /* Allow partial capture if this undefined, otherwise throw exception */
    3: optional PartialCaptureServiceTerms partial_captures
}

struct PartialCaptureServiceTerms {}

struct PaymentChargebackServiceTerms {
    5: optional Predicate allow
    2: optional CashFlowSelector fees
    3: optional TimeSpanSelector eligibility_time
}

struct PaymentRefundsServiceTerms {
    1: optional PaymentMethodSelector payment_methods
    2: optional CashFlowSelector fees
    3: optional TimeSpanSelector eligibility_time
    4: optional PartialRefundsServiceTerms partial_refunds
}

struct PartialRefundsServiceTerms {
    1: optional CashLimitSelector cash_limit
}

/* Recurrent payment tools service terms */

struct RecurrentPaytoolsServiceTerms {
    1: optional PaymentMethodSelector payment_methods
}

/* Payouts service terms */

struct PayoutsServiceTerms {
    /* Payout schedule level */
    4: optional BusinessScheduleSelector payout_schedules
    /* Payout level */
    1: optional PayoutMethodSelector payout_methods
    2: optional CashLimitSelector cash_limit
    3: optional CashFlowSelector fees
}


// legacy
struct PayoutCompilationPolicy {
    1: required base.TimeSpan assets_freeze_for
}

/** Wallets service terms **/

struct WalletServiceTerms {
    1: optional CurrencySelector currencies
    2: optional CashLimitSelector wallet_limit
    3: optional CumulativeLimitSelector turnover_limit
    4: optional WithdrawalServiceTerms withdrawals
    5: optional P2PServiceTerms p2p
    6: optional W2WServiceTerms w2w
}

union CumulativeLimitSelector {
    1: list<CumulativeLimitDecision> decisions
    2: set<CumulativeLimit> value
}

struct CumulativeLimitDecision {
    1: required Predicate if_
    2: required CumulativeLimitSelector then_
}

// TODO think about abstracting period & cash to some union of diferend metrics & bounds
struct CumulativeLimit {
    1: required CumulativeLimitPeriod period
    2: required CashRange cash
}

enum CumulativeLimitPeriod {
    today
    this_week
    this_month
    this_year
}

/** Withdrawal service terms **/

struct WithdrawalServiceTerms {
    1: optional CurrencySelector currencies
    2: optional CashLimitSelector cash_limit
    3: optional CashFlowSelector cash_flow
    4: optional AttemptLimitSelector attempt_limit
}

/** P2P service terms **/

struct P2PServiceTerms {
    1: optional Predicate allow
    2: optional CurrencySelector currencies
    3: optional CashLimitSelector cash_limit
    4: optional CashFlowSelector cash_flow
    5: optional FeeSelector fees
    6: optional LifetimeSelector quote_lifetime
    7: optional P2PTemplateServiceTerms templates
}

/** P2P template service terms **/

struct P2PTemplateServiceTerms {
    1: optional Predicate allow
}

/** W2W service terms **/

struct W2WServiceTerms {
    1: optional Predicate allow
    2: optional CurrencySelector currencies
    3: optional CashLimitSelector cash_limit
    4: optional CashFlowSelector cash_flow
    5: optional FeeSelector fees
}

/* Payout methods */

enum PayoutMethod {
    russian_bank_account
    international_bank_account
    wallet_info
}

struct PayoutMethodRef { 1: required PayoutMethod id }

/** Способ вывода, категория средства вывода. */
struct PayoutMethodDefinition {
    1: required string name
    2: required string description
}

union PayoutMethodSelector {
    1: list<PayoutMethodDecision> decisions
    2: set<PayoutMethodRef> value
}

struct PayoutMethodDecision {
    1: required Predicate if_
    2: required PayoutMethodSelector then_
}

/* Reports service terms */
struct ReportsServiceTerms {
    1: optional ServiceAcceptanceActsTerms acts
}

/* Service Acceptance Acts (Акты об оказании услуг) */
struct ServiceAcceptanceActsTerms {
    1: optional BusinessScheduleSelector schedules
}

/* Currencies */

/** Символьный код, уникально идентифицирующий валюту. */
typedef string CurrencySymbolicCode

struct CurrencyRef { 1: required CurrencySymbolicCode symbolic_code }

/** Валюта. */
struct Currency {
    1: required string name
    2: required CurrencySymbolicCode symbolic_code
    3: required i16 numeric_code
    4: required i16 exponent
}

union CurrencySelector {
    1: list<CurrencyDecision> decisions
    2: set<CurrencyRef> value
}

struct CurrencyDecision {
    1: required Predicate if_
    2: required CurrencySelector then_
}

/* Категории */

union CategorySelector {
    1: list<CategoryDecision> decisions
    2: set<CategoryRef> value
}

struct CategoryDecision {
    1: required Predicate if_
    2: required CategorySelector then_
}

/* Резиденция */
// Для обозначения спользуется alpha-3 код по стандарту ISO_3166-1
// https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3

enum Residence {
    ABH =   0  /*Abkhazia*/
    AUS =   1  /*Australia*/
    AUT =   2  /*Austria*/
    AZE =   3  /*Azerbaijan*/
    ALB =   4  /*Albania*/
    DZA =   5  /*Algeria*/
    ASM =   6  /*American Samoa*/
    AIA =   7  /*Anguilla*/
    AGO =   8  /*Angola*/
    AND =   9  /*Andorra*/
    ATA =  10  /*Antarctica*/
    ATG =  11  /*Antigua and Barbuda*/
    ARG =  12  /*Argentina*/
    ARM =  13  /*Armenia*/
    ABW =  14  /*Aruba*/
    AFG =  15  /*Afghanistan*/
    BHS =  16  /*Bahamas*/
    BGD =  17  /*Bangladesh*/
    BRB =  18  /*Barbados*/
    BHR =  19  /*Bahrain*/
    BLR =  20  /*Belarus*/
    BLZ =  21  /*Belize*/
    BEL =  22  /*Belgium*/
    BEN =  23  /*Benin*/
    BMU =  24  /*Bermuda*/
    BGR =  25  /*Bulgaria*/
    BOL =  26  /*Bolivia, plurinational state of*/
    BES =  27  /*Bonaire, Sint Eustatius and Saba*/
    BIH =  28  /*Bosnia and Herzegovina*/
    BWA =  29  /*Botswana*/
    BRA =  30  /*Brazil*/
    IOT =  31  /*British Indian Ocean Territory*/
    BRN =  32  /*Brunei Darussalam*/
    BFA =  33  /*Burkina Faso*/
    BDI =  34  /*Burundi*/
    BTN =  35  /*Bhutan*/
    VUT =  36  /*Vanuatu*/
    HUN =  37  /*Hungary*/
    VEN =  38  /*Venezuela*/
    VGB =  39  /*Virgin Islands, British*/
    VIR =  40  /*Virgin Islands, U.S.*/
    VNM =  41  /*Vietnam*/
    GAB =  42  /*Gabon*/
    HTI =  43  /*Haiti*/
    GUY =  44  /*Guyana*/
    GMB =  45  /*Gambia*/
    GHA =  46  /*Ghana*/
    GLP =  47  /*Guadeloupe*/
    GTM =  48  /*Guatemala*/
    GIN =  49  /*Guinea*/
    GNB =  50  /*Guinea-Bissau*/
    DEU =  51  /*Germany*/
    GGY =  52  /*Guernsey*/
    GIB =  53  /*Gibraltar*/
    HND =  54  /*Honduras*/
    HKG =  55  /*Hong Kong*/
    GRD =  56  /*Grenada*/
    GRL =  57  /*Greenland*/
    GRC =  58  /*Greece*/
    GEO =  59  /*Georgia*/
    GUM =  60  /*Guam*/
    DNK =  61  /*Denmark*/
    JEY =  62  /*Jersey*/
    DJI =  63  /*Djibouti*/
    DMA =  64  /*Dominica*/
    DOM =  65  /*Dominican Republic*/
    EGY =  66  /*Egypt*/
    ZMB =  67  /*Zambia*/
    ESH =  68  /*Western Sahara*/
    ZWE =  69  /*Zimbabwe*/
    ISR =  70  /*Israel*/
    IND =  71  /*India*/
    IDN =  72  /*Indonesia*/
    JOR =  73  /*Jordan*/
    IRQ =  74  /*Iraq*/
    IRN =  75  /*Iran, Islamic Republic of*/
    IRL =  76  /*Ireland*/
    ISL =  77  /*Iceland*/
    ESP =  78  /*Spain*/
    ITA =  79  /*Italy*/
    YEM =  80  /*Yemen*/
    CPV =  81  /*Cape Verde*/
    KAZ =  82  /*Kazakhstan*/
    KHM =  83  /*Cambodia*/
    CMR =  84  /*Cameroon*/
    CAN =  85  /*Canada*/
    QAT =  86  /*Qatar*/
    KEN =  87  /*Kenya*/
    CYP =  88  /*Cyprus*/
    KGZ =  89  /*Kyrgyzstan*/
    KIR =  90  /*Kiribati*/
    CHN =  91  /*China*/
    CCK =  92  /*Cocos (Keeling) Islands*/
    COL =  93  /*Colombia*/
    COM =  94  /*Comoros*/
    COG =  95  /*Congo*/
    COD =  96  /*Congo, Democratic Republic of the*/
    PRK =  97  /*Korea, Democratic People's republic of*/
    KOR =  98  /*Korea, Republic of*/
    CRI =  99  /*Costa Rica*/
    CIV = 100  /*Cote d'Ivoire*/
    CUB = 101  /*Cuba*/
    KWT = 102  /*Kuwait*/
    CUW = 103  /*Curaçao*/
    LAO = 104  /*Lao People's Democratic Republic*/
    LVA = 105  /*Latvia*/
    LSO = 106  /*Lesotho*/
    LBN = 107  /*Lebanon*/
    LBY = 108  /*Libyan Arab Jamahiriya*/
    LBR = 109  /*Liberia*/
    LIE = 110  /*Liechtenstein*/
    LTU = 111  /*Lithuania*/
    LUX = 112  /*Luxembourg*/
    MUS = 113  /*Mauritius*/
    MRT = 114  /*Mauritania*/
    MDG = 115  /*Madagascar*/
    MYT = 116  /*Mayotte*/
    MAC = 117  /*Macao*/
    MWI = 118  /*Malawi*/
    MYS = 119  /*Malaysia*/
    MLI = 120  /*Mali*/
    UMI = 121  /*United States Minor Outlying Islands*/
    MDV = 122  /*Maldives*/
    MLT = 123  /*Malta*/
    MAR = 124  /*Morocco*/
    MTQ = 125  /*Martinique*/
    MHL = 126  /*Marshall Islands*/
    MEX = 127  /*Mexico*/
    FSM = 128  /*Micronesia, Federated States of*/
    MOZ = 129  /*Mozambique*/
    MDA = 130  /*Moldova*/
    MCO = 131  /*Monaco*/
    MNG = 132  /*Mongolia*/
    MSR = 133  /*Montserrat*/
    MMR = 134  /*Burma*/
    NAM = 135  /*Namibia*/
    NRU = 136  /*Nauru*/
    NPL = 137  /*Nepal*/
    NER = 138  /*Niger*/
    NGA = 139  /*Nigeria*/
    NLD = 140  /*Netherlands*/
    NIC = 141  /*Nicaragua*/
    NIU = 142  /*Niue*/
    NZL = 143  /*New Zealand*/
    NCL = 144  /*New Caledonia*/
    NOR = 145  /*Norway*/
    ARE = 146  /*United Arab Emirates*/
    OMN = 147  /*Oman*/
    BVT = 148  /*Bouvet Island*/
    IMN = 149  /*Isle of Man*/
    NFK = 150  /*Norfolk Island*/
    CXR = 151  /*Christmas Island*/
    HMD = 152  /*Heard Island and McDonald Islands*/
    CYM = 153  /*Cayman Islands*/
    COK = 154  /*Cook Islands*/
    TCA = 155  /*Turks and Caicos Islands*/
    PAK = 156  /*Pakistan*/
    PLW = 157  /*Palau*/
    PSE = 158  /*Palestinian Territory, Occupied*/
    PAN = 159  /*Panama*/
    VAT = 160  /*Holy See (Vatican City State)*/
    PNG = 161  /*Papua New Guinea*/
    PRY = 162  /*Paraguay*/
    PER = 163  /*Peru*/
    PCN = 164  /*Pitcairn*/
    POL = 165  /*Poland*/
    PRT = 166  /*Portugal*/
    PRI = 167  /*Puerto Rico*/
    MKD = 168  /*Macedonia, The Former Yugoslav Republic Of*/
    REU = 169  /*Reunion*/
    RUS = 170  /*Russian Federation*/
    RWA = 171  /*Rwanda*/
    ROU = 172  /*Romania*/
    WSM = 173  /*Samoa*/
    SMR = 174  /*San Marino*/
    STP = 175  /*Sao Tome and Principe*/
    SAU = 176  /*Saudi Arabia*/
    SWZ = 177  /*Swaziland*/
    SHN = 178  /*Saint Helena, Ascension And Tristan Da Cunha*/
    MNP = 179  /*Northern Mariana Islands*/
    BLM = 180  /*Saint Barthélemy*/
    MAF = 181  /*Saint Martin (French Part)*/
    SEN = 182  /*Senegal*/
    VCT = 183  /*Saint Vincent and the Grenadines*/
    KNA = 184  /*Saint Kitts and Nevis*/
    LCA = 185  /*Saint Lucia*/
    SPM = 186  /*Saint Pierre and Miquelon*/
    SRB = 187  /*Serbia*/
    SYC = 188  /*Seychelles*/
    SGP = 189  /*Singapore*/
    SXM = 190  /*Sint Maarten*/
    SYR = 191  /*Syrian Arab Republic*/
    SVK = 192  /*Slovakia*/
    SVN = 193  /*Slovenia*/
    GBR = 194  /*United Kingdom*/
    USA = 195  /*United States*/
    SLB = 196  /*Solomon Islands*/
    SOM = 197  /*Somalia*/
    SDN = 198  /*Sudan*/
    SUR = 199  /*Suriname*/
    SLE = 200  /*Sierra Leone*/
    TJK = 201  /*Tajikistan*/
    THA = 202  /*Thailand*/
    TWN = 203  /*Taiwan, Province of China*/
    TZA = 204  /*Tanzania, United Republic Of*/
    TLS = 205  /*Timor-Leste*/
    TGO = 206  /*Togo*/
    TKL = 207  /*Tokelau*/
    TON = 208  /*Tonga*/
    TTO = 209  /*Trinidad and Tobago*/
    TUV = 210  /*Tuvalu*/
    TUN = 211  /*Tunisia*/
    TKM = 212  /*Turkmenistan*/
    TUR = 213  /*Turkey*/
    UGA = 214  /*Uganda*/
    UZB = 215  /*Uzbekistan*/
    UKR = 216  /*Ukraine*/
    WLF = 217  /*Wallis and Futuna*/
    URY = 218  /*Uruguay*/
    FRO = 219  /*Faroe Islands*/
    FJI = 220  /*Fiji*/
    PHL = 221  /*Philippines*/
    FIN = 222  /*Finland*/
    FLK = 223  /*Falkland Islands (Malvinas)*/
    FRA = 224  /*France*/
    GUF = 225  /*French Guiana*/
    PYF = 226  /*French Polynesia*/
    ATF = 227  /*French Southern Territories*/
    HRV = 228  /*Croatia*/
    CAF = 229  /*Central African Republic*/
    TCD = 230  /*Chad*/
    MNE = 231  /*Montenegro*/
    CZE = 232  /*Czech Republic*/
    CHL = 233  /*Chile*/
    CHE = 234  /*Switzerland*/
    SWE = 235  /*Sweden*/
    SJM = 236  /*Svalbard and Jan Mayen*/
    LKA = 237  /*Sri Lanka*/
    ECU = 238  /*Ecuador*/
    GNQ = 239  /*Equatorial Guinea*/
    ALA = 240  /*Aland Islands*/
    SLV = 241  /*El Salvador*/
    ERI = 242  /*Eritrea*/
    EST = 243  /*Estonia*/
    ETH = 244  /*Ethiopia*/
    ZAF = 245  /*South Africa*/
    SGS = 246  /*South Georgia and the South Sandwich Islands*/
    OST = 247  /*South Ossetia*/
    SSD = 248  /*South Sudan*/
    JAM = 249  /*Jamaica*/
    JPN = 250  /*Japan*/
}

/* Schedules */

struct BusinessScheduleRef { 1: required ObjectID id }

struct BusinessSchedule {
    1: required string name
    2: optional string description
    3: required base.Schedule schedule
    5: optional base.TimeSpan delay
    // legacy
    4: optional PayoutCompilationPolicy policy
}

union BusinessScheduleSelector {
    1: list<BusinessScheduleDecision> decisions
    2: set<BusinessScheduleRef> value
}

struct BusinessScheduleDecision {
    1: required Predicate if_
    2: required BusinessScheduleSelector then_
}

/* Calendars */

struct CalendarRef { 1: required ObjectID id }

struct Calendar {
    1: required string name
    2: optional string description
    3: required base.Timezone timezone
    4: required CalendarHolidaySet holidays
    5: optional base.DayOfWeek first_day_of_week
}

typedef map<base.Year, set<CalendarHoliday>> CalendarHolidaySet

struct CalendarHoliday {
    1: required string name
    2: optional string description
    3: required base.DayOfMonth day
    4: required base.Month month
}

/* Limits */

struct CashRange {
    1: required CashBound upper
    2: required CashBound lower
}

union CashBound {
    1: Cash inclusive
    2: Cash exclusive
}

union CashLimitSelector {
    1: list<CashLimitDecision> decisions
    2: CashRange value
}

struct CashLimitDecision {
    1: required Predicate if_
    2: required CashLimitSelector then_
}

/* Payment methods */

union PaymentMethod {
    2: TerminalPaymentProvider payment_terminal
    3: DigitalWalletProvider digital_wallet
    6: CryptoCurrency crypto_currency
    7: MobileOperator mobile
    8: BankCardPaymentMethod bank_card
    // Deprecated, use BankCardPaymentMethod instead
    1: BankCardPaymentSystem bank_card_deprecated
    4: TokenizedBankCard tokenized_bank_card_deprecated
    5: BankCardPaymentSystem empty_cvv_bank_card_deprecated
}

struct BankCardPaymentMethod {
    1: required BankCardPaymentSystem payment_system
    2: optional bool                  is_cvv_empty = false
    3: optional BankCardTokenProvider token_provider
    4: optional TokenizationMethod    tokenization_method
}

struct TokenizedBankCard {
    1: required BankCardPaymentSystem payment_system
    2: required BankCardTokenProvider token_provider
    3: optional TokenizationMethod    tokenization_method
}

enum BankCardPaymentSystem {
    visa
    mastercard
    visaelectron
    maestro
    forbrugsforeningen
    dankort
    amex
    dinersclub
    discover
    unionpay
    jcb
    nspkmir
}

/** Тип платежного токена **/

enum BankCardTokenProvider {
    applepay
    googlepay
    samsungpay
}

typedef base.ID CustomerID
typedef base.ID CustomerBindingID
typedef base.ID RecurrentPaymentToolID

struct P2PTool {
    1: required PaymentTool sender
    2: required PaymentTool receiver
}

union PaymentTool {
    1: BankCard bank_card
    2: PaymentTerminal payment_terminal
    3: DigitalWallet digital_wallet
    4: CryptoCurrency crypto_currency
    5: MobileCommerce mobile_commerce
}

struct DisposablePaymentResource {
    1: required PaymentTool        payment_tool
    2: optional PaymentSessionID   payment_session_id
    3: optional ClientInfo         client_info
}

typedef string Token

enum TokenizationMethod {
    dpan
    none
}

struct BankCard {
    1: required Token token
    2: required BankCardPaymentSystem payment_system
    3: required string bin
    4: required string last_digits
    5: optional BankCardTokenProvider token_provider
   12: optional TokenizationMethod tokenization_method
    6: optional Residence issuer_country
    7: optional string bank_name
    8: optional map<string, msgpack.Value> metadata
    9: optional bool is_cvv_empty
   10: optional BankCardExpDate exp_date
   11: optional string cardholder_name
   13: optional string category
}

/** Дата экспирации */
struct BankCardExpDate {
    /** Месяц 1..12 */
    1: required i8 month
    /** Год 2015..∞ */
    2: required i16 year
}

struct BankCardCategoryRef { 1: required ObjectID id }

struct BankCardCategory {
    1: required string name
    2: required string description
    3: required set<string> category_patterns
}

struct CryptoWallet {
    1: required string id // ID or wallet of the recipient in the third-party payment system
    2: required CryptoCurrency crypto_currency
    // A destination tag is a unique 9-digit figure assigned to each Ripple (XRP) account
    3: optional string destination_tag
}

enum CryptoCurrency {
    bitcoin
    litecoin
    bitcoin_cash
    ripple
    ethereum
    zcash
    usdt
}

struct MobileCommerce {
    1: required MobileOperator operator
    2: required MobilePhone    phone
}

enum MobileOperator {
    mts      = 1
    beeline  = 2
    megafone = 3
    tele2    = 4
    yota     = 5
}

/**
* Телефонный номер согласно (E.164 — рекомендация ITU-T)
* +79114363738
* cc = 7 - код страны(1-3 цифры)
* ctn = 9114363738 - 10-ти значный номер абонента(макс 12)
*/
struct MobilePhone {
    1: required string cc
    2: required string ctn
}

/** Платеж через терминал **/
struct PaymentTerminal {
    1: required TerminalPaymentProvider terminal_type
}

/**
*  Вид платежного терминала
*
*  например Евросеть
**/
enum TerminalPaymentProvider {
    euroset
    wechat
    alipay
    zotapay
    qps
}

typedef string DigitalWalletID

struct DigitalWallet {
    1: required DigitalWalletProvider provider
    2: required DigitalWalletID       id
    3: optional Token                 token
}

enum DigitalWalletProvider {
    qiwi
    rbkmoney
    yandex_money
}

struct BankRef { 1: required ObjectID id }

struct Bank {
    1: required string name
    2: required string description
    4: optional set<string> binbase_id_patterns

    /* legacy */
    3: required set<string> bins
}

struct PaymentMethodRef { 1: required PaymentMethod id }

/** Способ платежа, категория платёжного средства. */
struct PaymentMethodDefinition {
    1: required string name
    2: required string description
}

union PaymentMethodSelector {
    1: list<PaymentMethodDecision> decisions
    2: set<PaymentMethodRef> value
}

struct PaymentMethodDecision {
    1: required Predicate if_
    2: required PaymentMethodSelector then_
}

/* Holds */

struct HoldLifetime {
    1: required i32 seconds
}

union HoldLifetimeSelector {
    1: list<HoldLifetimeDecision> decisions
    2: HoldLifetime value
}

struct HoldLifetimeDecision {
    1: required Predicate if_
    2: required HoldLifetimeSelector then_
}

/* Refunds */

union TimeSpanSelector {
    1: list<TimeSpanDecision> decisions
    2: base.TimeSpan value
}

struct TimeSpanDecision {
    1: required Predicate if_
    2: required TimeSpanSelector then_
}

union LifetimeSelector {
    1: list<LifetimeDecision> decisions
    2: Lifetime value
}

struct LifetimeDecision {
    1: required Predicate if_
    2: required LifetimeSelector then_
}
/* Flows */

// TODO

/* Cash flows */

/** Счёт в графе финансовых потоков. */
union CashFlowAccount {
    1: MerchantCashFlowAccount merchant
    2: ProviderCashFlowAccount provider
    3: SystemCashFlowAccount system
    4: ExternalCashFlowAccount external
    5: WalletCashFlowAccount wallet
}

enum MerchantCashFlowAccount {

    /**
     * Расчётный счёт:
     *  - учёт прибыли по платежам в магазине;
     *  - учёт возмещённых вознаграждений.
     */
    settlement

    /**
     * Счёт гарантийного депозита:
     *  - учёт средств для погашения реализовавшихся рисков по мерчанту.
     */
    guarantee

    /**
         * Счёт выплаченных средств:
         *  - учёт средств выплаченных мерчанту.
         */
    payout

}

enum ProviderCashFlowAccount {

    /**
     * Расчётный счёт:
     *  - учёт полученных средств;
     *  - учёт вознаграждений.
     */
    settlement

}

enum SystemCashFlowAccount {

    /**
     * Расчётный счёт:
     *  - учёт полученных и возмещённых вознаграждений.
     */
    settlement

    /**
     * Расчётный счёт:
     * - проводки между внутренними участниками взаиморасчётов.
     */
    subagent

}

enum ExternalCashFlowAccount {

    /**
     * Счёт поступлений:
     *  - учёт любых поступлений в систему извне.
     */
    income

    /**
     * Счёт выводов:
     *  - учёт любых выводов из системы вовне.
     */
    outcome

}

enum WalletCashFlowAccount {
    sender_source
    sender_settlement
    receiver_settlement
    receiver_destination
}

enum CashFlowConstant {
    operation_amount    = 1
    /** Комиссия "сверху" - взимается с клиента в дополнение к сумме операции */
    surplus             = 2
    // ...
    // TODO

    /* deprecated */
    // invoice_amount = 0
    // payment_amount = 1
}

/** Структура содержит таблицу с комиссиями, удерживаемых при совершение операции.
    В случае когда CashVolume не fixed, Surplus может быть выражена только через operation_amount.
    Например(5% от суммы платежа):
    fees = {
        'surplus': CashVolume{
            share = CashVolumeShare{
                    parts = base.Rational{p = 5, q = 100},
                    of = operation_amount
                }
            }
        }
 */
struct Fees {
    1: required map<CashFlowConstant, CashVolume> fees
}

typedef map<CashFlowConstant, Cash> CashFlowContext

/** Граф финансовых потоков. */
typedef list<CashFlowPosting> CashFlow

/** Денежный поток между двумя участниками. */
struct CashFlowPosting {
    1: required CashFlowAccount source
    2: required CashFlowAccount destination
    3: required CashVolume volume
    4: optional string details
}

/** Полностью вычисленный граф финансовых потоков с проводками всех участников. */
typedef list<FinalCashFlowPosting> FinalCashFlow

/** Вычисленный денежный поток между двумя участниками. */
struct FinalCashFlowPosting {
    1: required FinalCashFlowAccount source
    2: required FinalCashFlowAccount destination
    3: required Cash volume
    4: optional string details
}

struct FinalCashFlowAccount {
    1: required CashFlowAccount account_type
    2: required AccountID account_id
}

/** Объём финансовой проводки. */
union CashVolume {
    1: CashVolumeFixed fixed
    2: CashVolumeShare share
    3: CashVolumeProduct product
}

/** Объём в абсолютных денежных единицах. */
struct CashVolumeFixed {
    1: required Cash cash
}

/** Объём в относительных единицах. */
struct CashVolumeShare {
    1: required base.Rational parts
    2: required CashFlowConstant of
    3: optional RoundingMethod rounding_method
}

/** Метод округления к целому числу. */
enum RoundingMethod {
    /** https://en.wikipedia.org/wiki/Rounding#Round_half_towards_zero. */
    round_half_towards_zero
    /** https://en.wikipedia.org/wiki/Rounding#Round_half_away_from_zero. */
    round_half_away_from_zero
}

/** Композиция различных объёмов. */
union CashVolumeProduct {
    /** Минимальный из полученных объёмов. */
    1: set<CashVolume> min_of
    /** Максимальный из полученных объёмов. */
    2: set<CashVolume> max_of
}

union CashFlowSelector {
    1: list<CashFlowDecision> decisions
    2: CashFlow value
}

struct CashFlowDecision {
    1: required Predicate if_
    2: required CashFlowSelector then_
}

union FeeSelector {
    1: list<FeeDecision> decisions
    2: Fees value
}

struct FeeDecision {
    1: required Predicate if_
    2: required FeeSelector then_
}

/* Attempt limit */

union AttemptLimitSelector {
    1: list<AttemptLimitDesision> decisions
    2: AttemptLimit value
}

struct AttemptLimitDesision {
    1: required Predicate if_
    2: required AttemptLimitSelector then_
}

struct AttemptLimit {
    1: required i64 attempts
}

/* Providers */

struct ProviderRef { 1: required ObjectID id }

struct Provider {
    1: required string name
    2: required string description
    3: required Proxy proxy
    9: optional string identity
    7: optional ProviderAccountSet accounts = {}
    10: optional ProvisionTermSet terms
    11: optional list<ProviderParameter> params_schema

    // Deprecated
    5: optional string abs_account
    6: optional PaymentsProvisionTerms payment_terms
    8: optional RecurrentPaytoolsProvisionTerms recurrent_paytool_terms
    4: optional TerminalSelector terminal
}

struct CashRegisterProviderRef { 1: required ObjectID id }

struct CashRegisterProvider {
    1: required string                              name
    2: optional string                              description
    3: required list<ProviderParameter>             params_schema
    4: required Proxy                               proxy
}

struct ProviderParameter {
    1: required string                            id
    2: optional string                            description
    3: required ProviderParameterType             type
    4: required bool                              is_required
}

union ProviderParameterType {
    1: ProviderParameterString   string_type
    2: ProviderParameterInteger  integer_type
    3: ProviderParameterUrl      url_type
    4: ProviderParameterPassword password_type
}

struct ProviderParameterString {}
struct ProviderParameterInteger {}
struct ProviderParameterUrl {}
struct ProviderParameterPassword {}

struct WithdrawalProviderRef { 1: required ObjectID id }

struct WithdrawalProvider {
    1: required string name
    2: optional string description
    3: required Proxy proxy
    4: optional string identity
    5: optional WithdrawalProvisionTerms withdrawal_terms
    6: optional ProviderAccountSet accounts = {}
    7: optional WithdrawalTerminalSelector terminal
}

struct P2PProviderRef { 1: required ObjectID id }

struct P2PProvider {
    1: required string name
    2: optional string description
    3: required Proxy proxy
    4: optional string identity
    6: optional P2PProvisionTerms p2p_terms
    7: optional ProviderAccountSet accounts = {}
}

struct ProvisionTermSet {
    1: optional PaymentsProvisionTerms payments
    2: optional RecurrentPaytoolsProvisionTerms recurrent_paytools
    3: optional WalletProvisionTerms wallet
}

struct PaymentsProvisionTerms {
    11: optional Predicate allow
    1: optional CurrencySelector currencies
    2: optional CategorySelector categories
    3: optional PaymentMethodSelector payment_methods
    6: optional CashLimitSelector cash_limit
    4: optional CashFlowSelector cash_flow
    5: optional PaymentHoldsProvisionTerms holds
    7: optional PaymentRefundsProvisionTerms refunds
    10: optional PaymentChargebackProvisionTerms chargebacks
}

struct PaymentHoldsProvisionTerms {
    1: required HoldLifetimeSelector lifetime
    /* Allow partial capture if this undefined, otherwise throw exception */
    2: optional PartialCaptureProvisionTerms partial_captures
}

struct PartialCaptureProvisionTerms {}

struct PaymentChargebackProvisionTerms {
    1: required CashFlowSelector cash_flow
    3: optional FeeSelector fees
}

struct PaymentRefundsProvisionTerms {
    1: required CashFlowSelector cash_flow
    /**
     * Условия для частичных рефандов.
     */
    2: optional PartialRefundsProvisionTerms partial_refunds
}

struct PartialRefundsProvisionTerms {
    1: required CashLimitSelector cash_limit
}

struct RecurrentPaytoolsProvisionTerms {
    1: required CashValueSelector     cash_value
    2: required CategorySelector      categories
    3: required PaymentMethodSelector payment_methods
}

struct WalletProvisionTerms {
    1: optional CumulativeLimitSelector turnover_limit
    2: optional WithdrawalProvisionTerms withdrawals
    3: optional P2PProvisionTerms p2p
}

struct WithdrawalProvisionTerms {
    5: optional Predicate allow
    1: optional CurrencySelector currencies
    2: optional PayoutMethodSelector payout_methods
    3: optional CashLimitSelector cash_limit
    4: optional CashFlowSelector cash_flow
}

struct P2PProvisionTerms {
    5: optional Predicate allow
    1: optional CurrencySelector currencies
    2: optional CashLimitSelector cash_limit
    3: optional CashFlowSelector cash_flow
    4: optional FeeSelector fees
}

union CashValueSelector {
    1: list<CashValueDecision> decisions
    2: Cash value
}

struct CashValueDecision {
    1: required Predicate if_
    2: required CashValueSelector then_
}

typedef map<CurrencyRef, ProviderAccount> ProviderAccountSet

struct ProviderAccount {
    1: required AccountID settlement
}

union ProviderSelector {
    1: list<ProviderDecision> decisions
    2: set<ProviderRef> value
}

struct ProviderDecision {
    1: required Predicate if_
    2: required ProviderSelector then_
}

union WithdrawalProviderSelector {
    1: list<WithdrawalProviderDecision> decisions
    2: set<WithdrawalProviderRef> value
}

struct WithdrawalProviderDecision {
    1: required Predicate if_
    2: required WithdrawalProviderSelector then_
}

union P2PProviderSelector {
    1: list<P2PProviderDecision> decisions
    2: set<P2PProviderRef> value
}

struct P2PProviderDecision {
    1: required Predicate if_
    2: required P2PProviderSelector then_
}

/** Inspectors */

struct InspectorRef { 1: required ObjectID id }

struct Inspector {
    1: required string name
    2: required string description
    3: required Proxy proxy
    4: optional RiskScore fallback_risk_score
}

union InspectorSelector {
    1: list<InspectorDecision> decisions
    2: InspectorRef value
}

struct InspectorDecision {
    1: required Predicate if_
    2: required InspectorSelector then_
}

struct P2PInspectorRef { 1: required ObjectID id }

struct P2PInspector {
    1: required string name
    2: required string description
    3: required Proxy proxy
    4: optional map<ScoreID, RiskScore> fallback_risk_score
}

union P2PInspectorSelector {
    1: list<P2PInspectorDecision> decisions
    2: P2PInspectorRef value
}

struct P2PInspectorDecision {
    1: required Predicate if_
    2: required P2PInspectorSelector then_
}

typedef string ExternalTerminalID
typedef string MerchantID
typedef string MerchantCategoryCode

/**
 * Обобщённый терминал у провайдера.
 *
 * Представляет собой единицу предоставления услуг по процессингу платежей со
 * стороны провайдера, согласно нашим с ним договорённостям.
 */
struct Terminal {
    1: required string name
    2: required string description
    9: optional ProxyOptions options
    10: optional RiskScore risk_coverage
    13: optional ProviderRef provider_ref
    14: optional ProvisionTermSet terms

    /* Идентификатор терминала во внешней системе провайдера.*/
    15: optional ExternalTerminalID external_terminal_id
    /* Идентификатор мерчанта во внешней системе провайдера.*/
    16: optional MerchantID external_merchant_id
    /* Код классификации вида деятельности мерчанта. */
    17: optional MerchantCategoryCode mcc

    // deprecated
    12: optional PaymentsProvisionTerms terms_legacy
}

union TerminalSelector {
    1: list<TerminalDecision> decisions
    2: set<ProviderTerminalRef> value
}

struct TerminalDecision {
    1: required Predicate if_
    2: required TerminalSelector then_
}

struct ProviderTerminalRef {
    1: required ObjectID id
    2: optional i64 priority = 1000
    3: optional i64 weight
}

struct TerminalRef {
    1: required ObjectID id
}

//

struct WithdrawalTerminalRef {
    1: required ObjectID id
    2: optional i64 priority = 1000
}

struct WithdrawalTerminal {
    1: required string name
    2: optional string description
    3: optional ProxyOptions options
    4: optional WithdrawalProvisionTerms terms
    5: optional WithdrawalProviderRef provider_ref
}

union WithdrawalTerminalSelector {
    1: list<WithdrawalTerminalDecision> decisions
    2: set<WithdrawalTerminalRef> value
}

struct WithdrawalTerminalDecision {
    1: required Predicate if_
    2: required WithdrawalTerminalSelector then_
}

/* Predicates / conditions */

union Predicate {
    5: bool constant
    1: Condition condition
    2: Predicate is_not
    3: set<Predicate> all_of
    4: set<Predicate> any_of
    6: CriterionRef criterion
}

union Condition {
    1: CategoryRef category_is
    2: CurrencyRef currency_is
    4: CashRange cost_in
    3: PaymentToolCondition payment_tool
    5: ShopLocation shop_location_is
    6: PartyCondition party
    7: PayoutMethodRef payout_method_is
    8: ContractorIdentificationLevel identification_level_is
    9: P2PToolCondition p2p_tool
}

struct P2PToolCondition {
    1: optional PaymentToolCondition sender_is
    2: optional PaymentToolCondition receiver_is
}

union PaymentToolCondition {
    1: BankCardCondition bank_card
    2: PaymentTerminalCondition payment_terminal
    3: DigitalWalletCondition digital_wallet
    4: CryptoCurrencyCondition crypto_currency
    5: MobileCommerceCondition mobile_commerce
}

struct BankCardCondition {
    3: optional BankCardConditionDefinition definition
}

union BankCardConditionDefinition {
    1: BankCardPaymentSystem payment_system_is // deprecated
    2: BankRef issuer_bank_is
    3: PaymentSystemCondition payment_system
    4: Residence issuer_country_is
    5: bool empty_cvv_is
    6: BankCardCategoryRef category_is
}

struct PaymentSystemCondition {
    1: required BankCardPaymentSystem payment_system_is
    2: optional BankCardTokenProvider token_provider_is
    3: optional TokenizationMethod    tokenization_method_is
}

struct PaymentTerminalCondition {
    1: optional PaymentTerminalConditionDefinition definition
}

union PaymentTerminalConditionDefinition {
    1: TerminalPaymentProvider provider_is
}

struct DigitalWalletCondition {
    1: optional DigitalWalletConditionDefinition definition
}

union DigitalWalletConditionDefinition {
    1: DigitalWalletProvider provider_is
}

struct CryptoCurrencyCondition {
    1: optional CryptoCurrencyConditionDefinition definition
}

union CryptoCurrencyConditionDefinition {
    1: CryptoCurrency crypto_currency_is
}

struct MobileCommerceCondition {
    1: optional MobileCommerceConditionDefinition definition
}

union MobileCommerceConditionDefinition {
    1: MobileOperator operator_is
}

struct PartyCondition {
    1: required PartyID id
    2: optional PartyConditionDefinition definition
}

union PartyConditionDefinition {
    1: ShopID shop_is
    2: WalletID wallet_is
    3: ContractID contract_is
}

struct CriterionRef { 1: required ObjectID id }

struct Criterion {
    1: required string name
    2: optional string description
    3: required Predicate predicate
}

/* Proxies */

typedef base.StringMap ProxyOptions

struct ProxyRef { 1: required ObjectID id }

struct ProxyDefinition {
    1: required string name
    2: required string description
    3: required string url
    4: required ProxyOptions options
}

struct Proxy {
    1: required ProxyRef ref
    2: required ProxyOptions additional
}

/* System accounts */

struct SystemAccountSetRef { 1: required ObjectID id }

struct SystemAccountSet {
    1: required string name
    2: required string description
    3: required map<CurrencyRef, SystemAccount> accounts
}

struct SystemAccount {
    1: required AccountID settlement
    2: optional AccountID subagent
}

union SystemAccountSetSelector {
    1: list<SystemAccountSetDecision> decisions
    2: SystemAccountSetRef value
}

struct SystemAccountSetDecision {
    1: required Predicate if_
    2: required SystemAccountSetSelector then_
}

/* External accounts */

struct ExternalAccountSetRef { 1: required ObjectID id }

struct ExternalAccountSet {
    1: required string name
    2: required string description
    3: required map<CurrencyRef, ExternalAccount> accounts
}

struct ExternalAccount {
    1: required AccountID income
    2: required AccountID outcome
}

union ExternalAccountSetSelector {
    1: list<ExternalAccountSetDecision> decisions
    2: ExternalAccountSetRef value
}

struct ExternalAccountSetDecision {
    1: required Predicate if_
    2: required ExternalAccountSetSelector then_
}

/* Payment institution */

struct PaymentInstitutionRef { 1: required ObjectID id }

struct PaymentInstitution {
    1: required string name
    2: optional string description
    9: optional CalendarRef calendar
    3: required SystemAccountSetSelector system_account_set
    4: required ContractTemplateSelector default_contract_template
    10: optional ContractTemplateSelector default_wallet_contract_template
    6: required InspectorSelector inspector
    7: required PaymentInstitutionRealm realm
    8: required set<Residence> residences
    /* TODO: separated system accounts for wallets look weird */
    11: optional SystemAccountSetSelector wallet_system_account_set
    12: optional string identity
    15: optional P2PInspectorSelector p2p_inspector
    16: optional Routing payment_routing
    17: optional ProviderSelector withdrawal_providers
    18: optional Routing token_provider_routing

    // Deprecated
    13: optional WithdrawalProviderSelector withdrawal_providers_legacy
    14: optional P2PProviderSelector p2p_providers_legacy
    5: optional ProviderSelector providers
}

enum PaymentInstitutionRealm {
    test
    live
}

struct ContractPaymentInstitutionDefaults {
    1: required PaymentInstitutionRef test
    2: required PaymentInstitutionRef live
}

/* Routing rule sets */

struct Routing {
    1: required RoutingRulesetRef policies
    2: required RoutingRulesetRef prohibitions
}

struct RoutingRulesetRef { 1: required ObjectID id }

struct RoutingRuleset {
    1: required string name
    2: optional string description
    3: required RoutingDecisions decisions
}

union RoutingDecisions {
    1: list<RoutingDelegate> delegates
    2: list<RoutingCandidate> candidates
}

struct RoutingDelegate {
    1: optional string description
    2: required Predicate allowed
    3: required RoutingRulesetRef ruleset
}

struct RoutingCandidate {
    1: optional string description
    2: required Predicate allowed
    3: required TerminalRef terminal
    4: optional i32 weight
    5: optional i32 priority = 1000
}

/* legacy */
/* TODO rework (de)serializer to handle those cases more politely and then remove */

struct PartyPrototypeRef { 1: required ObjectID id }

struct PartyPrototype {}

struct PartyPrototypeObject {
    1: required PartyPrototypeRef ref
    2: required PartyPrototype data
}

/* Root config */

struct GlobalsRef {}

struct Globals {

    4: required ExternalAccountSetSelector external_account_set
    8: optional set<PaymentInstitutionRef> payment_institutions
    42: optional ContractPaymentInstitutionDefaults contract_payment_institution_defaults

}

/** Dummy (for integrity test purpose) */
struct Dummy {}

struct DummyRef {
    1: base.ID id
}

struct DummyObject {
    1: DummyRef ref
    2: Dummy data
}

struct DummyLink {
    1: DummyRef link
}

struct DummyLinkRef {
    1: base.ID id
}

struct DummyLinkObject {
    1: DummyLinkRef ref
    2: DummyLink data
}

/* Type enumerations */

struct ContractTemplateObject {
    1: required ContractTemplateRef ref
    2: required ContractTemplate data
}

struct TermSetHierarchyObject {
    1: required TermSetHierarchyRef ref
    2: required TermSetHierarchy data
}

struct CategoryObject {
    1: required CategoryRef ref
    2: required Category data
}

struct CurrencyObject {
    1: required CurrencyRef ref
    2: required Currency data
}

struct BusinessScheduleObject {
    1: required BusinessScheduleRef ref
    2: required BusinessSchedule data
}

struct CalendarObject {
    1: required CalendarRef ref
    2: required Calendar data
}

struct PaymentMethodObject {
    1: required PaymentMethodRef ref
    2: required PaymentMethodDefinition data
}

struct PayoutMethodObject {
    1: required PayoutMethodRef ref
    2: required PayoutMethodDefinition data
}

struct BankObject {
    1: required BankRef ref
    2: required Bank data
}

struct BankCardCategoryObject {
    1: required BankCardCategoryRef ref
    2: required BankCardCategory data
}

struct ProviderObject {
    1: required ProviderRef ref
    2: required Provider data
}

struct CashRegisterProviderObject {
    1: required CashRegisterProviderRef ref
    2: required CashRegisterProvider data
}

struct WithdrawalProviderObject {
    1: required WithdrawalProviderRef ref
    2: required WithdrawalProvider data
}

struct P2PProviderObject {
    1: required P2PProviderRef ref
    2: required P2PProvider data
}

struct TerminalObject {
    1: required TerminalRef ref
    2: required Terminal data
}

struct WithdrawalTerminalObject {
    1: required WithdrawalTerminalRef ref
    2: required WithdrawalTerminal data
}

struct InspectorObject {
    1: required InspectorRef ref
    2: required Inspector data
}

struct P2PInspectorObject {
    1: required P2PInspectorRef ref
    2: required P2PInspector data
}

struct PaymentInstitutionObject {
    1: required PaymentInstitutionRef ref
    2: required PaymentInstitution data
}

struct SystemAccountSetObject {
    1: required SystemAccountSetRef ref
    2: required SystemAccountSet data
}

struct ExternalAccountSetObject {
    1: required ExternalAccountSetRef ref
    2: required ExternalAccountSet data
}

struct ProxyObject {
    1: required ProxyRef ref
    2: required ProxyDefinition data
}

struct GlobalsObject {
    1: required GlobalsRef ref
    2: required Globals data
}

struct RoutingRulesObject {
    1: required RoutingRulesetRef ref
    2: required RoutingRuleset data
}

struct CriterionObject {
    1: required CriterionRef ref
    2: required Criterion data
}

union Reference {

    1  : CategoryRef             category
    2  : CurrencyRef             currency
    19 : BusinessScheduleRef     business_schedule
    20 : CalendarRef             calendar
    3  : PaymentMethodRef        payment_method
    21 : PayoutMethodRef         payout_method
    5  : BankRef                 bank
    6  : ContractTemplateRef     contract_template
    17 : TermSetHierarchyRef     term_set_hierarchy
    18 : PaymentInstitutionRef   payment_institution
    7  : ProviderRef             provider
    8  : TerminalRef             terminal
    15 : InspectorRef            inspector
    25 : P2PInspectorRef         p2p_inspector
    14 : SystemAccountSetRef     system_account_set
    16 : ExternalAccountSetRef   external_account_set
    9  : ProxyRef                proxy
    11 : GlobalsRef              globals
    22 : WithdrawalProviderRef   withdrawal_provider
    23 : CashRegisterProviderRef cash_register_provider
    24 : P2PProviderRef          p2p_provider
    26 : RoutingRulesetRef       routing_rules
    27 : WithdrawalTerminalRef   withdrawal_terminal
    28 : BankCardCategoryRef     bank_card_category
    29 : CriterionRef            criterion

    12 : DummyRef                dummy
    13 : DummyLinkRef            dummy_link

    /* legacy */
    10 : PartyPrototypeRef       party_prototype
}

union DomainObject {

    1  : CategoryObject             category
    2  : CurrencyObject             currency
    19 : BusinessScheduleObject     business_schedule
    20 : CalendarObject             calendar
    3  : PaymentMethodObject        payment_method
    21 : PayoutMethodObject         payout_method
    5  : BankObject                 bank
    6  : ContractTemplateObject     contract_template
    17 : TermSetHierarchyObject     term_set_hierarchy
    18 : PaymentInstitutionObject   payment_institution
    7  : ProviderObject             provider
    8  : TerminalObject             terminal
    15 : InspectorObject            inspector
    25 : P2PInspectorObject         p2p_inspector
    14 : SystemAccountSetObject     system_account_set
    16 : ExternalAccountSetObject   external_account_set
    9  : ProxyObject                proxy
    11 : GlobalsObject              globals
    22 : WithdrawalProviderObject   withdrawal_provider
    23 : CashRegisterProviderObject cash_register_provider
    24 : P2PProviderObject          p2p_provider
    26 : RoutingRulesObject         routing_rules
    27 : WithdrawalTerminalObject   withdrawal_terminal
    28 : BankCardCategoryObject     bank_card_category
    29 : CriterionObject            criterion

    12 : DummyObject                dummy
    13 : DummyLinkObject            dummy_link

    /* legacy */
    10 : PartyPrototypeObject       party_prototype
}

/* Domain */

typedef map<Reference, DomainObject> Domain
