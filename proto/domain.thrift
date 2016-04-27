/**
 * Определения предметной области.
 */

include "base.thrift"

namespace erl domain

const i32 REVISION = 42

typedef i32 ObjectID

/* Common */

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

/** Распределение денежных потоков в системе. */
struct CashDistribution {
    1: required string name
    2: required string description = ""
    3: required list<CashFlow> flows
}

/** Денежный поток между двумя участниками. */
struct CashFlow {
    1: required CashFlowNode source
    2: required CashFlowNode destination
    3: required CashVolume volume
}

/** Участник распределения денежных потоков. */
typedef string CashFlowNode // FIXME: too broad

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

/* Merchants */

/** Мерчант. */
struct Merchant {
    1: optional Contract contract
    2: required list<Shop> shops = []
}

struct MerchantRef { 1: required base.ID id }

struct MerchantObject {
    1: required MerchantRef ref
    2: required Merchant data
}

/* Contracts */

/** Договор с юридическим лицом, в частности с мерчантом. */
struct Contract {
    1: required string number
    2: required base.Timestamp signed_at
    3: required PartyRef party
    4: required BankAccount account
    5: required list<ContractTerm> terms
}

/** Лицо, выступающее стороной договора. */
struct Party {
    1: required string registered_name
    2: required LegalEntity legal_entity
}

/** Форма юридического лица. */
union LegalEntity {
}

struct PartyRef { 1: required ObjectID id }

struct PartyObject {
    1: required PartyRef ref
    2: required Party data
}

/** Банковский счёт. */
struct BankAccount {
}

/** Условие договора. */
union ContractTerm {
    1: CashDistributionTerm cash_distribution
}

struct CashDistributionTerm {
}

/* Shops */

/** Магазин мерчанта. */
struct Shop {
    1: required string name
    2: optional string url
    3: required Category category
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

struct BankCard {
    1: required i64 pan
    2: required ExpDate exp_date
    3: optional string holder
    4: optional string cvv
}

struct ExpDate {
    1: required i8 month
    2: required i16 year
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

/* Merchant prototype */

/** Прототип мерчанта по умолчанию. */
struct MerchantPrototype {
    1: required Merchant data
}

struct MerchantPrototypeRef {}

/* Type enumerations */

union Reference {
    1: CategoryRef category
    2: PaymentMethodRef payment_method
    3: FlowRef flow
    4: CurrencyRef currency
    5: ConditionRef condition
    6: CashDistributionRef cash_distribution
    7: PartyRef party
    8: MerchantPrototypeRef merchant_prototype
}

union Object {
    1: CategoryObject category
    2: PaymentMethodObject payment_method
    3: FlowObject flow
    4: CurrencyObject currency
    5: ConditionObject condition
    6: CashDistributionObject cash_distribution
    7: PartyObject party
    8: MerchantPrototype merchant_prototype
}

/* Domain */

struct Domain {
    1: required map<Reference, Object> objects
}
