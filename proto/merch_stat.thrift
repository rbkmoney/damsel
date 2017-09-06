/**
 * Интерфейс сервиса статистики и связанные с ним определения предметной области, основанные на моделях домена.
 */

include "base.thrift"
include "domain.thrift"
include "geo_ip.thrift"

namespace java com.rbkmoney.damsel.merch_stat
namespace erlang merchstat

/**
 * Информация о платеже.
  * **/
struct StatPayment {
    1 : required domain.InvoicePaymentID id
    2 : required domain.InvoiceID invoice_id
    3 : required domain.PartyID owner_id
    4 : required domain.ShopID shop_id
    5 : required base.Timestamp created_at
    6 : required InvoicePaymentStatus status
    7 : required domain.Amount amount
    8 : required domain.Amount fee
    9 : required string currency_symbolic_code
    10: required PaymentTool payment_tool
    11: optional domain.IPAddress ip_address
    12: optional domain.Fingerprint fingerprint
    13: optional string phone_number
    14: optional string email
    15: required domain.PaymentSessionID session_id
    16: optional base.Content context
    17: optional geo_ip.LocationInfo location_info
    18: required InvoicePaymentFlow flow
}

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

union OperationFailure {
    1: OperationTimeout operation_timeout
    2: ExternalFailure  external_failure
}

struct OperationTimeout {}

struct ExternalFailure {
    1: required string code
    2: optional string description
}

struct InvoicePaymentPending   {}
struct InvoicePaymentProcessed {}
struct InvoicePaymentCaptured  {}
struct InvoicePaymentCancelled {}
struct InvoicePaymentFailed    { 1: required OperationFailure failure }

union InvoicePaymentStatus {
    1: InvoicePaymentPending pending
    4: InvoicePaymentProcessed processed
    2: InvoicePaymentCaptured captured
    5: InvoicePaymentCancelled cancelled
    3: InvoicePaymentFailed failed
}

union PaymentTool {
    1: BankCard bank_card
    2: PaymentTerminal payment_terminal
}

struct BankCard {
    1: required domain.Token token
    2: required domain.BankCardPaymentSystem payment_system
    3: required string bin
    4: required string masked_pan
}

struct PaymentTerminal {
    1: required TerminalPaymentProvider terminal_type
}

enum TerminalPaymentProvider {
    euroset
}

struct BankAccount {
    1: required string account
    2: required string bank_name
    3: required string bank_post_account
    4: required string bank_bik
}

/**
* Информация об инвойсе.
*/
struct StatInvoice {
    1 : required domain.InvoiceID id
    2 : required domain.PartyID owner_id
    3 : required domain.ShopID shop_id
    4 : required base.Timestamp created_at
    5 : required InvoiceStatus status
    6 : required string product
    7 : optional string description
    8 : required base.Timestamp due
    9 : required domain.Amount amount
    10: required string currency_symbolic_code
    11: optional base.Content context
    12: optional domain.InvoiceCart cart
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

/**
* Информация о клиенте. Уникальность клиента определяется по fingerprint.
*/
struct StatCustomer {
    1: required domain.Fingerprint id
    2: required base.Timestamp created_at
}

typedef base.ID PayoutID

/**
* Информация о выплате
*/
struct StatPayout {
    1 : required PayoutID id
    2 : required domain.PartyID party_id
    3 : required domain.ShopID shop_id
    4 : required base.Timestamp created_at
    5 : required PayoutStatus status
    6 : required domain.Amount amount
    7 : required domain.Amount fee
    8 : required string currency_symbolic_code
    9 : required PayoutType type
}

union PayoutType {
    1: PayoutCard bank_card
    2: PayoutAccount bank_account
}

struct PayoutCard {
    1: required BankCard card
}

struct PayoutAccount {
    1: required BankAccount account
    4: required string inn
    5: required string purpose
}

union PayoutStatus {
    1: PayoutUnpaid unpaid
    2: PayoutPaid paid
    3: PayoutCancelled cancelled
    4: PayoutConfirmed confirmed
}

struct PayoutUnpaid {}
struct PayoutPaid {}
struct PayoutCancelled { 1: required string details }
struct PayoutConfirmed {}

typedef map<string, string> StatInfo
typedef base.InvalidRequest InvalidRequest

/**
* Данные запроса к сервису. Формат и функциональность запроса зависят от DSL.
 * DSL содержит условия выборки, а также id мерчанта, по которому производится выборка.
*/
struct StatRequest {
    1: required string dsl
}

/**
* Данные ответа сервиса.
* data - данные, тип зависит от целевой функции.
* total_count - ожидаемое общее количество данных (т.е. размер всех данных результата, без ограничений по количеству)
*/
struct StatResponse {
    1: required StatResponseData data
    2: optional i32 total_count
}

/**
* Возможные варианты возвращаемых данных
*/
union StatResponseData {
    1: list<StatPayment> payments
    2: list<StatInvoice> invoices
    3: list<StatCustomer> customers
    4: list<StatInfo> records
    5: list<StatPayout> payouts
}

/**
* Ошибка превышения максимального размера блока данных, доступного для отправки клиенту.
* limit - текущий максимальный размер блока.
*/
exception DatasetTooBig {
    1: i32 limit;
}

service MerchantStatistics {
    /**
     * Возвращает набор данных о платежах
     */
    StatResponse GetPayments(1: StatRequest req) throws (1: InvalidRequest ex1, 2: DatasetTooBig ex2)

    /**
     *  Возвращает набор данных об инвойсах
     */
    StatResponse GetInvoices(1: StatRequest req) throws (1: InvalidRequest ex1, 2: DatasetTooBig ex2)

    /**
     * Возвращает набор данных о покупателях
     */
    StatResponse GetCustomers(1: StatRequest req) throws (1: InvalidRequest ex1, 2: DatasetTooBig ex2)

    /**
     * Возвращает набор данных о выплатах
     */
     StatResponse GetPayouts(1: StatRequest req) throws (1: InvalidRequest ex1, 2: DatasetTooBig ex2)

    /**
     * Возвращает аггрегированные данные в виде набора записей, формат возвращаемых данных зависит от целевой функции, указанной в DSL.
     */
    StatResponse GetStatistics(1: StatRequest req) throws (1: InvalidRequest ex1, 2: DatasetTooBig ex2)
}

