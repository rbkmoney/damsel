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
    10: required Payer payer
    12: optional base.Content context
    13: optional geo_ip.LocationInfo location_info
    14: required InvoicePaymentFlow flow
    15: optional string short_id
    16: optional bool make_recurrent
    17: optional RecurrentParentPayment recurrent_parent
}

struct RecurrentParentPayment {
    1: required InvoiceID invoice_id
    2: required InvoicePaymentID payment_id
}

union Payer {
    1: PaymentResourcePayer payment_resource
    2: CustomerPayer        customer
}

struct PaymentResourcePayer {
    1: required PaymentTool payment_tool
    2: optional domain.IPAddress ip_address
    3: optional domain.Fingerprint fingerprint
    4: optional string phone_number
    5: optional string email
    6: required domain.PaymentSessionID session_id
}

struct CustomerPayer {
    1: required domain.CustomerID customer_id
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
    2: domain.Failure  failure
}

struct OperationTimeout {}

struct InvoicePaymentPending   {}
struct InvoicePaymentProcessed { 1: optional base.Timestamp at }
struct InvoicePaymentCaptured  { 1: optional base.Timestamp at }
struct InvoicePaymentCancelled { 1: optional base.Timestamp at }
struct InvoicePaymentRefunded  { 1: optional base.Timestamp at }
struct InvoicePaymentFailed    {
    1: required OperationFailure failure
    2: optional base.Timestamp at
}

union InvoicePaymentStatus {
    1: InvoicePaymentPending pending
    4: InvoicePaymentProcessed processed
    2: InvoicePaymentCaptured captured
    5: InvoicePaymentCancelled cancelled
    6: InvoicePaymentRefunded refunded
    3: InvoicePaymentFailed failed
}

union PaymentTool {
    1: BankCard bank_card
    2: PaymentTerminal payment_terminal
    3: DigitalWallet digital_wallet
}

struct BankCard {
    1: required domain.Token token
    2: required domain.BankCardPaymentSystem payment_system
    3: required string bin
    4: required string masked_pan
    5: optional domain.BankCardTokenProvider token_provider
}

struct PaymentTerminal {
    1: required TerminalPaymentProvider terminal_type
}

enum TerminalPaymentProvider {
    euroset
}

typedef string DigitalWalletID

struct DigitalWallet {
    1: required DigitalWalletProvider provider
    2: required DigitalWalletID       id
}

enum DigitalWalletProvider {
    qiwi
}

struct RussianBankAccount {
    1: required string account
    2: required string bank_name
    3: required string bank_post_account
    4: required string bank_bik
}

struct InternationalBankAccount {
    1: required string account_holder
    2: required string bank_name
    3: required string bank_address
    4: required string iban
    5: required string bic
    6: optional string local_bank_code
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
struct InvoicePaid      { 1: optional base.Timestamp at }
struct InvoiceCancelled {
    1: required string details
    2: optional base.Timestamp at
}
struct InvoiceFulfilled {
    1: required string details
    2: optional base.Timestamp at
}

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
    10: optional PayoutSummary summary
}

enum OperationType {
    payment
    refund
}

struct PayoutSummaryItem {
    1: required domain.Amount amount
    2: required domain.Amount fee
    3: required string currency_symbolic_code
    4: required base.Timestamp from_time
    5: required base.Timestamp to_time
    6: required OperationType operation_type
    7: required i32 count
}

typedef list<PayoutSummaryItem> PayoutSummary

union PayoutType {
    1: PayoutCard bank_card
    2: PayoutAccount bank_account
}

struct PayoutCard {
    1: required BankCard card
}

union PayoutAccount {
    1: RussianPayoutAccount       russian_payout_account
    2: InternationalPayoutAccount international_payout_account
}

struct RussianPayoutAccount {
    1: required RussianBankAccount bank_account
    2: required string inn
    3: required string purpose
}

struct InternationalPayoutAccount {
   1: required InternationalBankAccount bank_account
   2: required string purpose
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

/**
 * Информация о рефанде.
  * **/
struct StatRefund {
    1 : required domain.InvoicePaymentRefundID id
    2 : required domain.InvoicePaymentID payment_id
    3 : required domain.InvoiceID invoice_id
    4 : required domain.PartyID owner_id
    5 : required domain.ShopID shop_id
    6 : required InvoicePaymentRefundStatus status
    7 : required base.Timestamp created_at
    8 : required domain.Amount amount
    9 : required domain.Amount fee
    10: required string currency_symbolic_code
    11: optional string reason
}

union InvoicePaymentRefundStatus {
    1: InvoicePaymentRefundPending pending
    2: InvoicePaymentRefundSucceeded succeeded
    3: InvoicePaymentRefundFailed failed
}

struct InvoicePaymentRefundPending {}
struct InvoicePaymentRefundSucceeded {
    1: required base.Timestamp at
}

struct InvoicePaymentRefundFailed {
    1: required OperationFailure failure
    2: required base.Timestamp at
}

typedef map<string, string> StatInfo
typedef base.InvalidRequest InvalidRequest

/**
* Данные запроса к сервису. Формат и функциональность запроса зависят от DSL.
 * DSL содержит условия выборки, а также id мерчанта, по которому производится выборка.
 * continuation_token - токен, который передается в случае обращения за следующим блоком данных, соответствующих dsl
*/
struct StatRequest {
    1: required string dsl
    2: optional string continuation_token
}

/**
* Данные ответа сервиса.
* data - данные, тип зависит от целевой функции.
* total_count - ожидаемое общее количество данных (т.е. размер всех данных результата, без ограничений по количеству)
* continuation_token - токен, сигнализирующий о том, что в ответе передана только часть данных, для получения следующей части
* нужно повторно обратиться к сервису, указав тот-же набор условий и continuation_token. Если токена нет, получена последняя часть данных.
*/
struct StatResponse {
    1: required StatResponseData data
    2: optional i32 total_count
    3: optional string continuation_token
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
    6: list<StatRefund> refunds
}

/**
* Ошибка обработки переданного токена, при получении такой ошибки клиент должен заново запросить все данные, соответсвующие dsl запросу
*/
exception BadToken {
    1: string reason
}

service MerchantStatistics {
    /**
     * Возвращает набор данных о платежах
     */
    StatResponse GetPayments(1: StatRequest req) throws (1: InvalidRequest ex1, 3: BadToken ex3)

    /**
     *  Возвращает набор данных об инвойсах
     */
    StatResponse GetInvoices(1: StatRequest req) throws (1: InvalidRequest ex1, 3: BadToken ex3)

    /**
     * Возвращает набор данных о покупателях
     */
    StatResponse GetCustomers(1: StatRequest req) throws (1: InvalidRequest ex1, 3: BadToken ex3)

    /**
     * Возвращает набор данных о выплатах
     */
    StatResponse GetPayouts(1: StatRequest req) throws (1: InvalidRequest ex1, 3: BadToken ex3)

    /**
     * Возвращает аггрегированные данные в виде набора записей, формат возвращаемых данных зависит от целевой функции, указанной в DSL.
     */
    StatResponse GetStatistics(1: StatRequest req) throws (1: InvalidRequest ex1, 3: BadToken ex3)
}

