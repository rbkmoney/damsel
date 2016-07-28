/**
 * Интерфейс сервиса статистики и связанные с ним определения предметной области, основанные на моделях домена.
 */

include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.merch_stat
namespace erlang merchstat

/**
 * Информация о платеже. Состоит из id инвойса платежа, доменной модели платежа и гео-данных.
  * **/
struct StatPayment {
    1: required domain.InvoiceID invoice_id
    2: required domain.InvoicePayment payment
    3: optional GeoInfo geo_info
}

/**
* Гео-данные платежа. Соcтоит из имени города (определяется по IP).
*/
struct GeoInfo {
    1: optional string city_name
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

/**
* Данные запроса к сервису. Формат и функциональность запроса зависят от DSL.
 * DSL содержит условия выборки, а также id мерчанта, по которому производится выборка.
*/
struct StatRequest {
    1: required string dsl
}

typedef map<string, string> StatInfo
typedef base.InvalidRequest InvalidRequest

service MerchantStatistics {
    list<StatPayment> GetPayments(1: StatRequest req) throws (1: InvalidRequest ex1)
    list<StatInvoice> GetInvoices(1: StatRequest req) throws (1: InvalidRequest ex1)
    list<StatCustomer> GetCustomers(1: StatRequest req) throws (1: InvalidRequest ex1)

    /**
    * Возвращает аггрегированные данные, формат возвращаемых данных зависит от целевой функции, указанной в DSL.
    */
    list<StatInfo> GetStat(1: StatRequest req) throws (1: InvalidRequest ex1)
}

