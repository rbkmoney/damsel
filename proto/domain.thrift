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

/** Денежные средства, состоящий из суммы и валюты. */
struct Funds {
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
    2: required PartyRef owner
    3: required ShopID shop_id
    4: required base.Timestamp created_at
    5: required DataRevision domain_revision
    6: required InvoiceStatus status
    7: required base.Timestamp due
    8: required string product
    9: optional string description
   10: required Funds cost
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
    8: required Funds cost
    6: optional InvoicePaymentContext context
}

struct InvoicePaymentPending   {}
struct InvoicePaymentProcessed {}
struct InvoicePaymentCaptured  {}
struct InvoicePaymentCancelled {}
struct InvoicePaymentFailed    { 1: OperationError err }

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
    4: required map<ShopID, Shop> shops = []
}

struct PartyRef {
    1: required PartyID id
    2: required DataRevision revision
}

/* Shops */

typedef string ShopID

/** Магазин мерчанта. */
struct Shop {
    1: required ShopID id
    2: required Blocking blocking
    3: required Suspension suspension
    4: required ShopDetails details
    5: required CategoryRef category
    6: optional ShopAccountSet accounts
    7: optional Contractor contractor
    8: optional ShopContract contract
    9: required ShopServices services
}

struct ShopAccountSet {
    1: required CurrencyRef currency
    2: required AccountID general
    3: required AccountID guarantee
}

struct ShopDetails {
    1: required string name
    2: optional string description
    3: optional string location
}

// Service
//   Payments
//     Regular
//     Held
//     Recurring
//     ...
//   ...

struct ShopServices {
    1: optional PaymentsService payments
}

struct PaymentsService {
    1: required DataRevision domain_revision
    2: required PaymentsServiceTermsRef terms
}

/* Service terms */

struct PaymentsServiceTermsRef { 1: required ObjectID id }

struct PaymentsServiceTerms {
    1: optional PaymentMethodSelector payment_methods
    2: optional AmountLimitSelector limits
    3: optional CashFlowSelector fees
    4: optional GuaranteeFundTerms guarantee_fund
}

struct GuaranteeFundTerms {
    1: optional AmountLimitSelector limits
    2: optional CashFlowSelector fees
}

/* Contracts */

/** Договор между юридическими лицами, в частности между системой и участником. */
struct ShopContract {
    1: required string number
    2: required ContractorRef system_contractor
    3: required base.Timestamp concluded_at
    4: required base.Timestamp valid_since
    5: required base.Timestamp valid_until
    6: optional base.Timestamp terminated_at
}

/** Лицо, выступающее стороной договора. */
struct Contractor {
    1: required string registered_name
    2: required LegalEntity legal_entity
}

/** Форма юридического лица. */
union LegalEntity {
}

struct ContractorRef { 1: required ObjectID id }

struct ContractorObject {
    1: required ContractorRef ref
    2: required Contractor data
}

/** Банковский счёт. */
struct BankAccount {
}

/* Categories */

struct CategoryRef { 1: required ObjectID id }

/** Категория продаваемых товаров или услуг. */
struct Category {
    1: required string name
    2: required string description = ""
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
    2: set<AmountLimit> value
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
    processing
}

typedef string CashFlowConstant                         // DISCUSS too broad?
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

struct Terminal {
    1: required string name
    2: required string description
    3: required PaymentMethodRef payment_method
    4: required CategoryRef category
    5: required CurrencyRef currency
    6: required CashFlow cash_flow
    7: required TerminalAccountSet accounts
    8: optional TerminalDescriptor descriptor
}

struct TerminalAccountSet {
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

union TerminalDescriptor {
    1: AcquiringTerminalDescriptor acquiring
}

struct AcquiringTerminalDescriptor {
    1: required string terminal_id
    2: required string merchant_id
    3: required string mcc
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
    1: required string url
    2: optional ProxyOptions options = {}
}

struct Proxy {
    1: required ProxyRef ref
    2: required ProxyOptions additional
}

/* Merchant prototype */

struct PartyPrototypeRef { 1: required ObjectID id }

/** Прототип мерчанта по умолчанию. */
struct PartyPrototype {
    1: required ShopPrototype shop
}

struct ShopPrototype {
    1: required CategoryRef category
    2: required CurrencyRef currency
    3: required ShopServices services
}

/* Root config */

struct GlobalsRef {}

struct Globals {
    1: required PartyPrototypeRef party_prototype
    2: required ProviderSelector providers
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

struct PaymentsServiceTermsObject {
    1: required PaymentsServiceTermsRef ref
    2: required PaymentsServiceTerms data
}

struct ProviderObject {
    1: required ProviderRef ref
    2: required Provider data
}

struct TerminalObject {
    1: required TerminalRef ref
    2: required Terminal data
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

    1: CategoryRef category
    2: CurrencyRef currency
    3: PaymentMethodRef payment_method
    4: BankCardBINRangeRef bank_card_bin_range
    5: PaymentsServiceTermsRef payments_service_terms
    6: ProviderRef provider
    7: TerminalRef terminal
    8: ProxyRef proxy
    9: PartyPrototypeRef party_prototype
   10: GlobalsRef globals

   11: DummyRef dummy
   12: DummyLinkRef dummy_link

}

union DomainObject {

    1: CategoryObject category
    2: CurrencyObject currency
    3: PaymentMethodObject payment_method
    4: BankCardBINRangeObject bank_card_bin_range
    5: PaymentsServiceTermsObject payments_service_terms
    6: ProviderObject provider
    7: TerminalObject terminal
    8: ProxyObject proxy
    9: PartyPrototypeObject party_prototype
   10: GlobalsObject globals

   11: DummyObject dummy
   12: DummyLinkObject dummy_link

}

/* Domain */

typedef map<Reference, DomainObject> Domain
