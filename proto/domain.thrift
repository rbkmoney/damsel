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
    2: ExternalFailure  external_failure
}

struct OperationTimeout {}

struct ExternalFailure {
    /** Уникальный признак ошибки, пригодный для обработки машиной */
    1: required string code
    /** Описание ошибки, пригодное для восприятия человеком */
    2: optional string description
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
}

/* Invoices */

typedef base.ID InvoiceID
typedef base.ID InvoicePaymentID
typedef base.ID InvoicePaymentAdjustmentID
typedef base.Content InvoiceContext
typedef base.Content InvoicePaymentContext
typedef string PaymentSessionID
typedef string Fingerprint
typedef string IPAddress

struct Invoice {
    1 : required InvoiceID id
    2 : required PartyID owner_id
    3 : required ShopID shop_id
    4 : required base.Timestamp created_at
    6 : required InvoiceStatus status
    7 : required InvoiceDetails details
    8 : required base.Timestamp due
    10: required Cash cost
    11: optional InvoiceContext context
    12: optional InvoiceTemplateID template_id
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
    10: required DataRevision domain_revision
    3:  required InvoicePaymentStatus status
    5:  required Payer payer
    8:  required Cash cost
    6:  optional InvoicePaymentContext context
}

struct InvoicePaymentPending   {}
struct InvoicePaymentProcessed {}
struct InvoicePaymentCaptured  {}
struct InvoicePaymentCancelled {}
struct InvoicePaymentFailed    { 1: required OperationFailure failure }

/**
 * Шаблон инвойса.
 * Согласно https://github.com/rbkmoney/coredocs/blob/0a5ae1a79f977be3134c3b22028631da5225d407/docs/domain/entities/invoice.md#шаблон-инвойса
 */

typedef base.ID InvoiceTemplateID

struct InvoiceTemplate {
    1: required InvoiceTemplateID id
    2: required PartyID owner_id
    3: required ShopID shop_id
    4: required InvoiceDetails details
    5: required LifetimeInterval invoice_lifetime
    6: required InvoiceTemplateCost cost
    7: optional InvoiceContext context
}

union InvoiceTemplateCost {
    1: Cash fixed
    2: CashRange range
    3: InvoiceTemplateCostUnlimited unlim
}

struct InvoiceTemplateCostUnlimited {}

/**
 * Статус платежа.
 * Согласно https://github.com/rbkmoney/coredocs/blob/589799f/docs/domain/entities/payment.md
 */
union InvoicePaymentStatus {
    1: InvoicePaymentPending pending
    4: InvoicePaymentProcessed processed
    2: InvoicePaymentCaptured captured
    5: InvoicePaymentCancelled cancelled
    3: InvoicePaymentFailed failed
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

}

union Payer {
    1: PaymentResourcePayer payment_resource
    2: CustomerPayer        customer
}

struct PaymentResourcePayer {
    1: required DisposablePaymentResource resource
    2: required ContactInfo               contact_info
}

struct CustomerPayer {
    1: required CustomerID customer_id
}

struct ClientInfo {
    1: optional IPAddress ip_address
    2: optional Fingerprint fingerprint
}

struct PaymentRoute {
    1: required ProviderRef provider
    2: required TerminalRef terminal
}

struct InvoicePaymentAdjustment {
    1: required InvoicePaymentAdjustmentID id
    2: required InvoicePaymentAdjustmentStatus status
    3: required base.Timestamp created_at
    4: required DataRevision domain_revision
    5: required string reason
    6: required FinalCashFlow new_cash_flow
    7: required FinalCashFlow old_cash_flow_inverse
}

struct InvoicePaymentAdjustmentPending   {}
struct InvoicePaymentAdjustmentCaptured  { 1: required base.Timestamp at }
struct InvoicePaymentAdjustmentCancelled { 1: required base.Timestamp at }

union InvoicePaymentAdjustmentStatus {
    1: InvoicePaymentAdjustmentPending pending
    2: InvoicePaymentAdjustmentCaptured captured
    3: InvoicePaymentAdjustmentCancelled cancelled
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
    4: required map<ContractID, Contract> contracts
    5: required map<ShopID, Shop> shops
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
    9: optional Proxy proxy
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

/* Инспекция платежа */

enum RiskScore {
    low = 1
    high = 100
    fatal = 9999
}

/* Contracts */

struct ContractorRef { 1: required ObjectID id }

/** Лицо, выступающее стороной договора. */
union Contractor {
    1: LegalEntity legal_entity
    2: RegisteredUser registered_user
}

struct RegisteredUser {
    1: required string email
}

union LegalEntity {
    1: RussianLegalEntity russian_legal_entity
}

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
    9: required BankAccount bank_account
}

/** Банковский счёт. */

struct BankAccount {
    1: required string account
    2: required string bank_name
    3: required string bank_post_account
    4: required string bank_bik
}

typedef base.ID PayoutToolID

struct PayoutTool {
    1: required PayoutToolID id
    4: required base.Timestamp created_at
    2: required CurrencyRef currency
    3: required PayoutToolInfo payout_tool_info
}

union PayoutToolInfo {
    1: BankAccount bank_account
}

typedef base.ID ContractID

/** Договор */
struct Contract {
    1: required ContractID id
    3: optional Contractor contractor
    11: required base.Timestamp created_at
    4: optional base.Timestamp valid_since
    5: optional base.Timestamp valid_until
    6: required ContractStatus status
    7: required TermSetHierarchyRef terms
    8: required list<ContractAdjustment> adjustments
    9: required list<PayoutTool> payout_tools
    10: optional LegalAgreement legal_agreement
}

/** Юридическое соглашение */
struct LegalAgreement {
    1: required base.Timestamp signed_at
    2: required string legal_agreement_id
}

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

/* Service terms */

struct PaymentsServiceTerms {
    /* Shop level */
    1: optional CurrencySelector currencies
    2: optional CategorySelector categories
    /* Invoice level*/
    4: optional PaymentMethodSelector payment_methods
    5: optional CashLimitSelector cash_limit
    /* Payment level */
    6: optional CashFlowSelector fees
    /* Undefined level */
    3: optional GuaranteeFundTerms guarantee_fund
}

struct GuaranteeFundTerms {
    1: optional CashLimitSelector limits
    2: optional CashFlowSelector fees
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
    1: BankCardPaymentSystem bank_card
    2: TerminalPaymentProvider payment_terminal
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

typedef base.ID CustomerID

union PaymentTool {
    1: BankCard bank_card
    2: PaymentTerminal payment_terminal
}

struct DisposablePaymentResource {
    1: required DisposablePaymentResourceData payment_resource_data
    2: required ContactInfo                   contact_info
}

struct DisposablePaymentResourceData {
    1: required PaymentTool      payment_tool
    2: optional PaymentSessionID payment_session_id
    3: required ClientInfo       client_info
}

struct CustomerPaymentResource {
    1: required CustomerID customer_id
}

typedef string Token

struct BankCard {
    1: required Token token
    2: required BankCardPaymentSystem payment_system
    3: required string bin
    4: required string masked_pan
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
}


struct BankCardBINRangeRef { 1: required ObjectID id }

struct BankCardBINRange {
    1: required string name
    2: required string description
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

/* Flows */

// TODO

/* Cash flows */

/** Счёт в графе финансовых потоков. */
union CashFlowAccount {
    1: MerchantCashFlowAccount merchant
    2: ProviderCashFlowAccount provider
    3: SystemCashFlowAccount system
    4: ExternalCashFlowAccount external
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

enum CashFlowConstant {
    invoice_amount
    payment_amount
    // ...
    // TODO
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

/* Providers */

struct ProviderRef { 1: required ObjectID id }

struct Provider {
    1: required string name
    2: required string description
    3: required Proxy proxy
    4: required TerminalSelector terminal
    /* Счет для платажей принятых эквайеромв АБС*/
    5: required string abs_account
}

union ProviderSelector {
    1: list<ProviderDecision> decisions
    2: set<ProviderRef> value
}

struct ProviderDecision {
    1: required Predicate if_
    2: required ProviderSelector then_
}

struct TerminalRef { 1: required ObjectID id }

/** Inspectors */

struct InspectorRef { 1: required ObjectID id }

struct Inspector {
    1: required string name
    2: required string description
    3: required Proxy proxy
}

union InspectorSelector {
    1: list<InspectorDecision> decisions
    2: InspectorRef value
}

struct InspectorDecision {
    1: required Predicate if_
    2: required InspectorSelector then_
}

/**
 * Обобщённый терминал у провайдера.
 *
 * Представляет собой единицу предоставления услуг по процессингу платежей со
 * стороны провайдера, согласно нашим с ним договорённостям.
 */
struct Terminal {
    1: required string name
    2: required string description
    3: required PaymentMethodRef payment_method
    4: required CategoryRef category
    6: required CashFlow cash_flow
    7: required TerminalAccount account
    // TODO
    // 8: optional TerminalDescriptor descriptor
    9: optional ProxyOptions options
    10: required RiskScore risk_coverage
}

struct TerminalAccount {
    1: required CurrencyRef currency
    2: required AccountID settlement
}

union TerminalSelector {
    1: list<TerminalDecision> decisions
    2: set<TerminalRef> value
}

struct TerminalDecision {
    1: required Predicate if_
    2: required TerminalSelector then_
}

/* Predicates / conditions */

union Predicate {
    5: bool constant
    1: Condition condition
    2: Predicate is_not
    3: set<Predicate> all_of
    4: set<Predicate> any_of
}

union Condition {
    1: CategoryRef category_is
    2: CurrencyRef currency_is
    4: CashRange cost_in
    3: PaymentToolCondition payment_tool
    5: ShopLocation shop_location_is
    6: PartyCondition party
}

union PaymentToolCondition {
    1: BankCardCondition bank_card
}

union BankCardCondition {
    1: BankCardPaymentSystem payment_system_is
    2: BankCardBINRangeRef bin_in
}

struct PartyCondition {
    1: required PartyID id
    2: optional PartyConditionDefinition definition
}

union PartyConditionDefinition {
    1: ShopID shop_is
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

/* Merchant prototype */

struct PartyPrototypeRef { 1: required ObjectID id }

/** Прототип мерчанта по умолчанию. */
struct PartyPrototype {
    1: required ShopPrototype shop
    3: required ContractPrototype contract
}

struct ShopPrototype {
    5: required ShopID shop_id
    1: required CategoryRef category
    2: required CurrencyRef currency
    3: required ShopDetails details
    4: required ShopLocation location
}

struct ContractPrototype {
    1: required ContractID contract_id
    2: required ContractTemplateRef test_contract_template
    3: required PayoutToolPrototype payout_tool
}

struct PayoutToolPrototype {
    1: required PayoutToolID payout_tool_id
    2: required PayoutToolInfo payout_tool_info
    3: required CurrencyRef payout_tool_currency
}

/* Root config */

struct GlobalsRef {}

struct Globals {
    1: required PartyPrototypeRef party_prototype
    2: required ProviderSelector providers
    3: required SystemAccountSetSelector system_account_set
    4: required ExternalAccountSetSelector external_account_set
    5: required InspectorSelector inspector
    6: required ContractTemplateRef default_contract_template
    7: required ProxyRef common_merchant_proxy
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

struct PaymentMethodObject {
    1: required PaymentMethodRef ref
    2: required PaymentMethodDefinition data
}

struct BankCardBINRangeObject {
    1: required BankCardBINRangeRef ref
    2: required BankCardBINRange data
}

struct ContractorObject {
    1: required ContractorRef ref
    2: required Contractor data
}

struct ProviderObject {
    1: required ProviderRef ref
    2: required Provider data
}

struct TerminalObject {
    1: required TerminalRef ref
    2: required Terminal data
}

struct InspectorObject {
    1: required InspectorRef ref
    2: required Inspector data
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

struct PartyPrototypeObject {
    1: required PartyPrototypeRef ref
    2: required PartyPrototype data
}

struct GlobalsObject {
    1: required GlobalsRef ref
    2: required Globals data
}

union Reference {

    1  : CategoryRef             category
    2  : CurrencyRef             currency
    3  : PaymentMethodRef        payment_method
    4  : ContractorRef           contractor
    5  : BankCardBINRangeRef     bank_card_bin_range
    6  : ContractTemplateRef     contract_template
    17 : TermSetHierarchyRef     term_set_hierarchy
    7  : ProviderRef             provider
    8  : TerminalRef             terminal
    15 : InspectorRef            inspector
    14 : SystemAccountSetRef     system_account_set
    16 : ExternalAccountSetRef   external_account_set
    9  : ProxyRef                proxy
    10 : PartyPrototypeRef       party_prototype
    11 : GlobalsRef              globals

    12 : DummyRef                dummy
    13 : DummyLinkRef            dummy_link

}

union DomainObject {

    1  : CategoryObject             category
    2  : CurrencyObject             currency
    3  : PaymentMethodObject        payment_method
    4  : ContractorObject           contractor
    5  : BankCardBINRangeObject     bank_card_bin_range
    6  : ContractTemplateObject     contract_template
    17 : TermSetHierarchyObject     term_set_hierarchy
    7  : ProviderObject             provider
    8  : TerminalObject             terminal
    15 : InspectorObject            inspector
    14 : SystemAccountSetObject     system_account_set
    16 : ExternalAccountSetObject   external_account_set
    9  : ProxyObject                proxy
    10 : PartyPrototypeObject       party_prototype
    11 : GlobalsObject              globals

    12 : DummyObject                dummy
    13 : DummyLinkObject            dummy_link

}

/* Domain */

typedef map<Reference, DomainObject> Domain
