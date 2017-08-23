include "base.thrift"
include "cash_register.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.cash_register
namespace erlang proxy_cash_register

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
 * Данные платежа, необходимые для обращения к прокси
 */
struct PaymentInfo {
    1: required Shop shop
    2: required domain.RussianLegalEntity russian_legal_entity
    3: required Invoice invoice
    4: required InvoicePayment invoice_payment
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
    1: required domain.PaymentTool payment_tool
    2: required domain.ContactInfo contact_info
}

struct Cash {
    1: required domain.Amount amount
    2: required domain.Currency currency
}

/**
 * Данные сессии взаимодействия с прокси.
 */
struct Session {
    1: required RegisterInvoiceReceipt register
}

struct Debit {}
struct RefundDebit {}

/**
 * Целевое значение статуса платежа.
 */
union RegisterInvoiceReceipt {

    /**
     * Расход
     */
    1: Debit debit

    /**
     * Возврат расхода
     */
    2: RefundDebit refund_debit

}

/**
 * Набор данных для взаимодействия с прокси.
 */
struct Context {
    1: required PaymentInfo payment_info
    2: optional domain.ProxyOptions options = {}
}


/**
 * Результат обращения к провайдерскому прокси в рамках сессии.
 */
struct CashBoxProxyResult {
    1: required cash_register.Intent intent
}

service CashBoxProxy {

    /**
     * Запрос к прокси на проведение взаимодействия с провайдером в рамках сессии.
     */
    CashBoxProxyResult RegisterInvoice (1: Context context, 2: Session session)

}

