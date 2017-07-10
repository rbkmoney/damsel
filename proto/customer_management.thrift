include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.customer_management
namespace erlang customer_management

exception CustomerNotFound {}
exception EventNotFound {}

typedef list<Event> Events;

struct Event {
    1: required base.EventID   id
    2: required base.Timestamp created_at
    3: required CustomerEvent  customer_event
}

struct EventRange {
    1: optional base.EventID after
    2: required i32 limit
}

/**
 * События, порождаемые во время получения многоразовых токенов
 */
union CustomerEvent {
    1: PaymentMeanStarted       payment_mean_started
    2: PaymentMeanStatusChanged payment_mean_status_changed
}

/**
 * Событие об запуске получения многоразового токена
 */
struct PaymentMeanStarted {
    1: required domain.CustomerID id
}

/**
 * Событие об запуске получения многоразового токена
 */
struct PaymentMeanStatusChanged {
    1: required domain.CustomerID                id
    2: required domain.CustomerPaymentMeanStatus payment_mean_status
}

/**
 * Сервис управления customer'ами
 */
service CustomerManagementService {

    /* Создать customer'а */
    domain.Customer CreateCustomer (1: domain.CustomerMeta meta)
        throws (1: base.InvalidRequest invalid_request)

    /* Создать многоразовый токен */
    domain.Customer AddToken (1: domain.CustomerID id, 2: domain.Token token, 3: domain.PaymentSessionID session_id)
        throws (1: CustomerNotFound not_found, 2: base.InvalidRequest invalid_request)

    /* Удалить многоразовый токен */
    void DeleteToken (1: domain.CustomerID id)
        throws (1: CustomerNotFound not_found, 2: base.InvalidRequest invalid_request)

    /* Получить данные customer'а */
    domain.Customer GetCustomer (1: domain.CustomerID id)
        throws (1: CustomerNotFound not_found, 2: base.InvalidRequest invalid_request)

    /* Удалить customer'а */
    void DeleteCustomer (1: domain.CustomerID id)
        throws (1: CustomerNotFound not_found, 2: base.InvalidRequest invalid_request)

    /* Event polling */
    Events GetEvents (1: domain.CustomerID customer_id, 2: EventRange range)
        throws (
            1: CustomerNotFound    customer_not_found,
            2: EventNotFound       event_not_found,
            3: base.InvalidRequest invalid_request
        )
}
