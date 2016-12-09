/**
 * Определения предметной области.
 */

include "base.thrift"

namespace java com.rbkmoney.damsel.domain
namespace erlang domain

typedef i32 SchemaRevision
typedef i64 DataRevision

const SchemaRevision SCHEMA_REVISION = 42

typedef i32 ObjectID

/* Common */

/** Контактная информация. **/
struct ContactInfo {
    1: optional string phone_number
    2: optional string email
}

typedef base.Error OperationError

/** Сумма в минимальных денежных единицах. */
typedef i64 Amount

/** Номер счёта. */
typedef i64 AccountID

/** Денежные средства, состоящие из суммы и валюты. */
struct Cash {
    1: required Amount amount
    2: required Currency currency
}

/* Contractor transactions */

struct TransactionInfo {
    1: required string id
    2: optional base.Timestamp timestamp
    3: required base.StringMap extra = []
}

/* Invoices */

typedef base.ID InvoiceID
typedef base.ID InvoicePaymentID
typedef base.Content InvoiceContext
typedef base.Content InvoicePaymentContext
typedef string PaymentSession
typedef string Fingerprint
typedef string IPAddress

struct Invoice {
    1: required InvoiceID id
    2: required PartyID owner_id
    3: required ShopID shop_id
    4: required base.Timestamp created_at
    6: required InvoiceStatus status
    7: required base.Timestamp due
    8: required string product
    9: optional string description
   10: required Cash cost
   11: optional InvoiceContext context
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
    1: required InvoicePaymentID id
    2: required base.Timestamp created_at
    3: required InvoicePaymentStatus status
    4: optional TransactionInfo trx
    5: required Payer payer
    8: required Cash cost
    6: optional InvoicePaymentContext context
    9: optional RiskScore risk_score
}

struct InvoicePaymentPending   {}
struct InvoicePaymentProcessed {}
struct InvoicePaymentCaptured  {}
struct InvoicePaymentCancelled {}
struct InvoicePaymentFailed    { 1: required OperationError err }

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

struct Payer {
    1: required PaymentTool payment_tool
    2: required PaymentSession session
    3: required ClientInfo client_info
    4: required ContactInfo contact_info
}

struct ClientInfo {
    1: optional IPAddress ip_address
    2: optional Fingerprint fingerprint
}

struct InvoicePaymentRoute {
    1: required ProviderRef provider
    2: required TerminalRef terminal
}

struct InvoicePaymentCashFlow {
    /** Полностью вычисленный граф финансовых потоков с проводками всех участников. */
    1: required CashFlow final_cash_flow
    /** Отображение счетов в графе на номера счетов в системе учёта счетов. */
    2: required map<CashFlowAccount, AccountID> account_map
}

/* Blocking and suspension */

union Blocking {
    1: Unblocked unblocked
    2: Blocked   blocked
}

struct Unblocked {
    1: required string reason
}

struct Blocked {
    1: required string reason
}

union Suspension {
    1: Active    active
    2: Suspended suspended
}

struct Active {}
struct Suspended {}

/* Parties */

typedef base.ID PartyID

/** Участник. */
struct Party {
    1: required PartyID id
    2: required Blocking blocking
    3: required Suspension suspension
    4: required map<ContractID, Contract> contracts = []
    5: required map<ShopID, Shop> shops = []
    6: required map<PayoutAccountID, PayoutAccount> payout_accounts = []
}

/* Shops */

typedef i32 ShopID

/** Магазин мерчанта. */
struct Shop {
    1: required ShopID id
    2: required Blocking blocking
    3: required Suspension suspension
    4: required ShopDetails details
    5: required CategoryRef category
    6: optional ShopAccountSet accounts
    7: required ContractID contract_id
    8: required PayoutAccountID payout_account_id
}

struct ShopAccountSet {
    1: required CurrencyRef currency
    2: required AccountID general
    3: required AccountID guarantee
}

struct ShopDetails {
    1: required string name
    2: optional string description
    3: optional ShopLocation location
}

union ShopLocation {
    1: string url
}

/* Инспекция платежа */

enum RiskScore {
    low = 1
    high = 100
}

/* Contracts */

struct ContractorRef { 1: required ObjectID id }

/** Лицо, выступающее стороной договора. */
struct Contractor {
    1: required string registered_name
    2: required LegalEntity legal_entity
}

/** Форма юридического лица. */
struct LegalEntity {
    1: required BankAccount bank_account
}

/** Банковский счёт. */

struct BankAccount {
    1: required string account
    2: required string bank_name
    3: required string bank_post_account
    4: required string bank_bik
}

typedef i32 PayoutAccountID

struct PayoutAccount {
    1: required PayoutAccountID id
    2: required CurrencyRef currency
    3: required PayoutMethod method
}

union PayoutMethod {
    1: BankAccount bank_account
}

typedef i32 ContractID

/** Договор */
struct Contract {
    1: required ContractID id
    3: required Contractor contractor
    4: optional base.Timestamp concluded_at
    5: optional base.Timestamp terminated_at
    6: required ContractTemplateRef template
    7: required list<ContractAdjustment> adjustments = []
}


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
    1: optional ContractTemplateRef parent_template
    2: optional Lifetime valid_since
    3: optional Lifetime valid_until
    4: required Terms terms
}

union Lifetime {
    1: base.Timestamp timestamp
    2: LifetimePeriod period
}

struct LifetimePeriod {
    1: optional i16 years
    2: optional i16 months
    3: optional i16 days
}

/** Поправки к договору **/
struct ContractAdjustment {
    1: required i32 id
    2: optional base.Timestamp concluded_at
    3: required ContractTemplateRef template
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

struct Terms {
    1: optional PaymentsServiceTerms payments
}

/* Service terms */

struct PaymentsServiceTerms {
    /* Shop level */
    1: optional CurrencySelector currencies
    2: optional CategorySelector categories
    /* Invoice level*/
    4: optional PaymentMethodSelector payment_methods
    5: optional AmountLimitSelector amount_limit
    /* Payment level */
    6: optional CashFlowSelector fees
    /* Undefined level */
    3: optional GuaranteeFundTerms guarantee_fund
}

struct GuaranteeFundTerms {
    1: optional AmountLimitSelector limits
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
    1: set<CurrencyPredicate> predicates
    2: set<CurrencyRef> value
}

struct CurrencyPredicate {
    1: required Predicate if_
    2: required CurrencySelector then_
}

/* Категории */

union CategorySelector {
    1: set<CategoryPredicate> predicates
    2: set<CategoryRef> value
}

struct CategoryPredicate {
    1: required Predicate if_
    2: required CategorySelector then_
}

/* Limits */

struct AmountLimit {
    1: required AmountBound min
    2: required AmountBound max
}

union AmountBound {
    1: Amount inclusive
    2: Amount exclusive
}

union AmountLimitSelector {
    1: set<AmountLimitPredicate> predicates
    2: AmountLimit value
}

struct AmountLimitPredicate {
    1: required Predicate if_
    2: required AmountLimitSelector then_
}

/* Payment methods */

union PaymentMethod {
    1: BankCardPaymentSystem bank_card
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

union PaymentTool {
    1: BankCard bank_card
}

typedef string Token

struct BankCard {
    1: required Token token
    2: required BankCardPaymentSystem payment_system
    3: required string bin
    4: required string masked_pan
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
    1: set<PaymentMethodPredicate> predicates
    2: set<PaymentMethodRef> value
}

struct PaymentMethodPredicate {
    1: required Predicate if_
    2: required PaymentMethodSelector then_
}

/* Flows */

// TODO

/* Cash flows */

enum CashFlowParty {
    merchant,
    provider,
    system
}

// TODO
//
// union CashFlowAccount {
//     1: MerchantAccount merchant_account
//     2: ProviderAccount provider_account
//     3: SystemAccount system_account
// }
// ...

enum CashFlowConstant {
    invoice_amount
    payment_amount
    // ...
    // TODO
}

typedef map<CashFlowConstant, Amount> CashFlowContext

/** Граф финансовых потоков. */
typedef list<CashFlowPosting> CashFlow

/** Счёт в графе финансовых потоков. */
struct CashFlowAccount {
    1: required CashFlowParty party
    2: required string designation
}

/** Денежный поток между двумя участниками. */
struct CashFlowPosting {
    1: required CashFlowAccount source
    2: required CashFlowAccount destination
    3: required CashVolume volume
    4: optional string details = ""
}

/** Объём финансовой проводки. */
union CashVolume {
    1: CashVolumeFixed fixed
    2: CashVolumeShare share
}

/** Объём в абсолютных денежных единицах. */
struct CashVolumeFixed {
    1: required Amount amount
}

/** Объём в относительных единицах. */
struct CashVolumeShare {
    1: required base.Rational parts
    2: required CashFlowConstant of
}

union CashFlowSelector {
    1: set<CashFlowPredicate> predicates
    2: CashFlow value
}

struct CashFlowPredicate {
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
}

union ProviderSelector {
    1: set<ProviderPredicate> predicates
    2: set<ProviderRef> value
}

struct ProviderPredicate {
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
    7: required TerminalAccountSet accounts
    // TODO
    // 8: optional TerminalDescriptor descriptor
    9: optional ProxyOptions options = {}
    10: required RiskScore risk_coverage
}

struct TerminalAccountSet {
    3: required CurrencyRef currency
    1: required AccountID receipt
    2: required AccountID compensation
}

union TerminalSelector {
    1: set<TerminalPredicate> predicates
    2: set<TerminalRef> value
}

struct TerminalPredicate {
    1: required Predicate if_
    2: required TerminalSelector then_
}

/* Predicates / conditions */

union Predicate {
    1: Condition condition
    2: Predicate is_not
    3: set<Predicate> all_of
    4: set<Predicate> any_of
}

union Condition {
    1: CategoryRef category_is
    2: CurrencyRef currency_is
    3: PaymentMethodRef payment_method_is
    4: PaymentToolCondition payment_tool
}

union PaymentToolCondition {
    1: BankCardBINRangeRef bank_card_bin_in
}

/* Proxies */

typedef base.StringMap ProxyOptions

struct ProxyRef { 1: required ObjectID id }

struct ProxyDefinition {
    // TODO
    // 1: required string name
    // 2: required string description
    1: required string url
    2: optional ProxyOptions options = {}
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
    3: required CurrencyRef currency
    4: required AccountID compensation
}

union SystemAccountSetSelector {
    1: set<SystemAccountSetPredicate> predicates
    2: set<SystemAccountSetRef> value
}

struct SystemAccountSetPredicate {
    1: required Predicate if_
    2: required SystemAccountSetSelector then_
}

/* Merchant prototype */

struct PartyPrototypeRef { 1: required ObjectID id }

/** Прототип мерчанта по умолчанию. */
struct PartyPrototype {
    1: required ShopPrototype shop
    2: required Contract default_contract
}

struct ShopPrototype {
    1: required CategoryRef category
    3: required ShopDetails details
    2: required CurrencyRef currency
}

/* Root config */

struct GlobalsRef {}

struct Globals {
    1: required PartyPrototypeRef party_prototype
    2: required ProviderSelector providers
    3: required SystemAccountSetSelector system_accounts
    4: required InspectorRef inspector
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

   1 : CategoryRef category
   2 : CurrencyRef currency
   3 : PaymentMethodRef payment_method
   4 : ContractorRef contractor
   5 : BankCardBINRangeRef bank_card_bin_range
   6 : ContractTemplateRef template
   7 : ProviderRef provider
   8 : TerminalRef terminal
   15: InspectorRef inspector
   14: SystemAccountSetRef system_account_set
   9 : ProxyRef proxy
   10: PartyPrototypeRef party_prototype
   11: GlobalsRef globals

   12: DummyRef dummy
   13: DummyLinkRef dummy_link

}

union DomainObject {

    1 : CategoryObject category
    2 : CurrencyObject currency
    3 : PaymentMethodObject payment_method
    4 : ContractorObject contractor
    5 : BankCardBINRangeObject bank_card_bin_range
    6 : ContractTemplateObject template
    7 : ProviderObject provider
    8 : TerminalObject terminal
    15: InspectorObject inspector
    14: SystemAccountSetObject system_account_set
    9 : ProxyObject proxy
    10: PartyPrototypeObject party_prototype
    11: GlobalsObject globals

    12: DummyObject dummy
    13: DummyLinkObject dummy_link

}

/* Domain */

typedef map<Reference, DomainObject> Domain
