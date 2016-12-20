include "base.thrift"
include "proxy.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.proxy_merchant
namespace erlang prxmerch

/**
 * Набор данных для взаимодействия с мерчантским прокси.
 */
struct Context {
    1: required Session session
    2: required InvoiceInfo invoice
    3: required domain.ProxyOptions options
}

/**
 * Данные инвойса, которые могут быть необходимы для обращения к мерчанту.
 */
struct InvoiceInfo {
    1: required Party party
    2: required Shop shop
    3: required Invoice invoice
}

struct Party {
    1: required domain.PartyID id
}

struct Shop {
    1: required domain.ShopID id
    2: required domain.ShopDetails details
}

struct Invoice {
    1: required domain.InvoiceID id
    2: required base.Timestamp created_at
    3: required base.Timestamp due
    4: required domain.InvoiceDetails details
    5: required Cash cost
    6: required domain.InvoiceContext context
}

struct Cash {
    1: required domain.Amount amount
    2: required domain.Currency currency
}

/**
 * Данные сессии взаимодействия с мерчантским прокси.
 */
struct Session {
    1: required InvoiceEvent event
    2: optional proxy.ProxyState state
}

/**
 * Событие об изменении состояния инвойса.
 */
union InvoiceEvent {
    1: InvoiceStatusChanged status_changed
}

/**
 * Событие об изменении статуса инвойса.
 */
struct InvoiceStatusChanged {
    1: required InvoiceStatus status
}

struct InvoicePaid {}

union InvoiceStatus {
    1: InvoicePaid paid
}

/**
 * Результат обращения к мерчантскому прокси в рамках сессии.
 *
 * В результате обращения прокси может решить, следует ли:
 *  - завершить сессию взаимодействия с провайдером (FinishIntent); или
 *  - просто приостановить на определённое время (SleepIntent), обновив своё состояние, которое
 *    вернётся к нему в последующем запросе.
 */
struct ProxyResult {
    1: required Intent intent
    2: optional proxy.ProxyState next_state
}

union Intent {
    1: FinishIntent finish
    2: SleepIntent sleep
}

/**
 * Требование завершить сессию взаимодействия.
 */
struct FinishIntent {}

/**
 * Требование прервать на определённое время сессию взаимодействия, с намерением продолжить
 * её потом.
 */
typedef proxy.SleepIntent SleepIntent

service MerchantProxy {

    /**
     * Запрос к прокси на обработку события об изменении состояния инвойса.
     */
    ProxyResult HandleInvoiceEvent (1: Context context)

}
