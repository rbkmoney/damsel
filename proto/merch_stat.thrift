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
    6 : required domain.InvoicePaymentStatus status
    7 : required domain.Amount amount
    8 : required domain.Amount fee
    9 : required domain.CurrencyRef currency
    10: required domain.PaymentTool payment_tool
    11: optional domain.IPAddress ip_address
    12: optional domain.Fingerprint fingerprint
    13: optional string phone_number
    14: optional string email
    15: required domain.PaymentSession session //<- what this?
    16: required domain.DataRevision domain_revision
    17: optional domain.InvoicePaymentContext context
    18: optional domain.RiskScore risk_score
    19: optional geo_ip.LocationInfo location_info
}

/**
* Информация об инвойсе.
*/
struct StatInvoice {
    1 : required domain.InvoiceID id
    2 : required domain.PartyID owner_id
    3 : required domain.ShopID shop_id
    4 : required base.Timestamp created_at
    5 : required domain.InvoiceStatus status
    6 : required domain.InvoiceDetails details
    7 : required base.Timestamp due
    8 : required domain.Amount amount
    9 : required domain.CurrencyRef currency
    10: optional domain.InvoiceContext context
}

/**
* Информация о клиенте. Уникальность клиента определяется по fingerprint.
*/
struct StatCustomer {
    1: required domain.Fingerprint id
    2: required base.Timestamp created_at
}


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
     * Возвращает аггрегированные данные в виде набора записей, формат возвращаемых данных зависит от целевой функции, указанной в DSL.
     */
    StatResponse GetStatistics(1: StatRequest req) throws (1: InvalidRequest ex1, 2: DatasetTooBig ex2)
}

