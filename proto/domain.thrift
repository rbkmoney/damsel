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

// В идеале надо использовать `typedef` над `base.Error`, но сейчас это приводит к ошибкам кодогенератора Go
struct OperationError {
    /** Уникальный признак ошибки, пригодный для обработки машиной */
    1: required string code;
    /** Описание ошибки, пригодное для восприятия человеком */
    2: optional string description;
}

/** Сумма в минимальных денежных единицах. */
typedef i64 Amount

/** Валюта. */
struct Currency {
    1: required string name
    2: required string symbolic_code
    3: required i16 numeric_code
    4: required i16 exponent
}

struct CurrencyRef { 1: required string symbolic_code }

struct CurrencyObject {
    1: required CurrencyRef ref
    2: required Currency data
}

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
typedef binary InvoiceContext
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
   11: required InvoiceContext context
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
}

struct InvoicePaymentPending   {}
struct InvoicePaymentSucceeded {}
struct InvoicePaymentFailed    { 1: OperationError err }

union InvoicePaymentStatus {
    1: InvoicePaymentPending pending
    2: InvoicePaymentSucceeded succeeded
    3: InvoicePaymentFailed failed
}

struct Payer {
    1: required PaymentTool payment_tool
    2: required PaymentSession session
    3: required ClientInfo client_info
}

struct ClientInfo {
    1: optional IPAddress ip_address
    2: optional Fingerprint fingerprint
}

/* Cash flows */

/** Распределение денежных потоков в системе. */
struct CashDistribution {
    1: required string name
    2: required string description = ""
    3: required list<CashFlow> flows
}

/** Участник распределения денежных потоков. */
// Порядок следования `typedef`-`struct` важен для кодогенератора Go
typedef string CashFlowNode // FIXME: too broad

/** Денежный поток между двумя участниками. */
struct CashFlow {
    1: required CashFlowNode source
    2: required CashFlowNode destination
    3: required CashVolume volume
}


/** Объём денежного потока. */
union CashVolume {
    1: VolumeFixed fixed
    2: VolumeShare share
}

/** Объём в абсолютных денежных единицах. */
struct VolumeFixed {
    1: required Amount amount
}

/** Объём в относительных единицах. */
struct VolumeShare {
    1: required base.Rational parts
    2: optional CashFlowNode of
}

struct CashDistributionRef { 1: required ObjectID id }

struct CashDistributionObject {
    1: required CashDistributionRef ref
    2: required CashDistribution data
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
    4: required CategoryObject category
    5: required ShopDetails details
    6: optional Contractor contractor
    7: optional ShopContract contract
}

struct ShopDetails {
    1: required string name
    2: optional string description
    3: optional string location
}

/* Contracts */

/** Договор между юридическими лицами, в частности между системой и участником. */
struct ShopContract {
    1: required string number
    2: required ContractorObject system_contractor
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

/** Категория продаваемых товаров или услуг. */
struct Category {
    1: required string name
    2: required string description = ""
}

struct CategoryRef { 1: required ObjectID id }

struct CategoryObject {
    1: required CategoryRef ref
    2: required Category data
}

/* Payment methods */

enum PaymentMethod {
    bank_card = 1        // payment_card?
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

enum BankCardPaymentSystem {
    visa
    mastercard
}

/** Способ платежа, категория платёжного средства. */
struct PaymentMethodDefinition {
    1: required string name
    2: required string description = ""
}

struct PaymentMethodRef { 1: required PaymentMethod id }

struct PaymentMethodObject {
    1: required PaymentMethodRef ref
    2: required PaymentMethodDefinition data
}

/* Conditions */

/** Условие применимости. */
struct Condition {
    1: required string name
    2: required string description = ""
    3: required ConditionDef definition
}

/** Варианты условий применимости. */
union ConditionDef {
    /// basis and combinators
    1: bool value_is
    2: set<ConditionDef> all_of
    3: set<ConditionDef> one_of
    4: ConditionDef is_not
    /// primitives
    5: ConditionRef condition_is
    6: CategoryRef category_is
    7: PaymentMethodRef payment_method_is
    8: FlowRef flow_is
}

struct ConditionRef { 1: required ObjectID id }

struct ConditionObject {
    1: required ConditionRef ref
    2: required Condition data
}

/* Flows */

/** Операция над бизнес-объектом, в частности инвойсом. */
struct Flow {
    1: required string name
    2: required string description = ""
}

struct FlowRef { 1: required ObjectID id }

struct FlowObject {
    1: required FlowRef ref
    2: required Flow data
}

/* Proxies */

typedef base.StringMap ProxyOptions

enum ProxyType {
    provider
}

struct Proxy {
    1: required ProxyType type
    2: required string url
    3: optional ProxyOptions options
}

struct ProxyRef { 1: required ObjectID id }

struct ProxyObject {
    1: required ProxyRef ref
    2: required ProxyObject object
}

/* Merchant prototype */

struct PartyPrototypeRef {}

/** Прототип мерчанта по умолчанию. */
struct PartyPrototype {
    1: required PartyPrototypeRef ref
    2: required Party data
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

union Reference {
    1: CategoryRef category
    2: PaymentMethodRef payment_method
    3: FlowRef flow
    4: CurrencyRef currency
    5: ConditionRef condition
    6: CashDistributionRef cash_distribution
    7: ContractorRef contractor
    8: PartyPrototypeRef party_prototype
    9: ProxyRef proxy
    10: DummyRef dummy
    11: DummyLinkRef dummy_link
}

union DomainObject {
    1: CategoryObject category
    2: PaymentMethodObject payment_method
    3: FlowObject flow
    4: CurrencyObject currency
    5: ConditionObject condition
    6: CashDistributionObject cash_distribution
    7: ContractorObject contractor
    8: PartyPrototype party_prototype
    9: ProxyObject proxy
    10: DummyObject dummy
    11: DummyLinkObject dummy_link
}

/* Domain */

typedef map<Reference, DomainObject> Domain
