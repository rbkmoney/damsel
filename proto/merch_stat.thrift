/**
 * Интерфейс сервиса статистики и связанные с ним определения предметной области, основанные на моделях домена.
 */

include "base.thrift"
include "domain.thrift"
include "geo_ip.thrift"

namespace java com.rbkmoney.damsel.merch_stat
namespace erlang merchstat

/**
 * Информация о платеже. Состоит из id инвойса платежа, доменной модели платежа и гео-данных.
  * **/
struct StatPayment {
    1: required domain.InvoiceID invoice_id
    2: required domain.InvoicePayment payment
    3: optional geo_ip.LocationInfo location_info
}

/**
* Информация об инвойсе. Состоит из доменной модели инвойса.
*/
struct StatInvoice {
    1: required domain.Invoice invoice;
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

