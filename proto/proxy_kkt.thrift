include "base.thrift"
include "kkt.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.proxy_kkt
namespace erlang prxkkt

/**
 * Данные о компании
 */
struct Company {
    1: required string name
    2: required string url
    3: required string inn
    4: required string address
    5: required string tax
    6: required Shop shop
}

struct Shop {
    1: required domain.ShopID id
    3: required domain.ShopDetails details
    4: required domain.ShopLocation location
}

struct ShopDetails {
    1: required string name
    2: optional string description
}

struct ShopLocation {
    1: string url
}


/**
 * Данные для проксика для взаимодействия с ККТ
 */
struct CashBox {
    1: required string url
    2: required string group
    3: optional string clientId
    4: optional domain.ProxyOptions options = {}
}


/**
 * Данные платежа, необходимые для обращения к прокси
 */
struct PaymentInfo {
    1: required Company company
    2: required CashBox cashbox
    3: required Invoice invoice
    4: required InvoicePayment invoicePayment
}

struct Invoice {
    1: required domain.InvoiceID id
    2: required base.Timestamp created_at
    3: required base.Timestamp due
    7: required domain.InvoiceDetails details
    6: required Cash cost
}

struct InvoicePayment {
    1: required domain.InvoicePaymentID id
    2: required base.Timestamp created_at
    3: required Payer payer
    4: required Cash cost
}

struct Payer {
    1: required domain.ContactInfo contact_info
}

struct Cash {
    1: required domain.Amount amount
    2: required domain.Currency currency
}

/**
 * Данные сессии взаимодействия с прокси.
 */
struct Session {
    1: required TargetInvoicePaymentStatus target
}

struct Debit {}
struct RefundDebit {}

/**
 * Целевое значение статуса платежа.
 */
union TargetInvoicePaymentStatus {

    /**
     * Расход
     */
    1: Debit debit

    /**
     * Возврат расхода
     */
    2: RefundDebit refundDebit

}

/**
 * Набор данных для взаимодействия с прокси.
 */
struct Context {
    1: required Session session
    2: required PaymentInfo payment_info
    3: optional domain.ProxyOptions options = {}
}


/**
 * Результат обращения к провайдерскому прокси в рамках сессии.
 */
struct CashBoxProxyResult {
    1: required kkt.Intent intent
    2: optional string originalResponse
}

service CashBoxProxy {

    /**
     * Запрос к прокси на проведение взаимодействия с провайдером в рамках сессии.
     */
    CashBoxProxyResult Processed (1: Context context)

}

