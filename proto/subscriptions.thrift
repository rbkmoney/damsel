include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.customer_service
namespace erlang custser

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
 * Ивенты, порождаемые во время получения многоразовых токенов
 */
union CustomerEvent {
    1: NondisposablePaymentMeanStarted       payment_mean_started
    2: NondisposablePaymentMeanStatusChanged payment_mean_status_changed
}

/**
 * Событие об запуске получения многоразового токена
 */
struct NondisposablePaymentMeanStarted {
    1: required domain.Customer customer
}

/**
 * Событие об запуске получения многоразового токена
 */
struct NondisposablePaymentMeanStatusChanged {

    1: required domain.Customer                  customer
    2: required domain.CustomerPaymentMeanStatus payment_mean_status
}

/**
 * Сервис управления customer'ами
 */
service CustomerService {

    /** Создать customer'а */
    void CreateCustomer (1: domain.CustomerMeta meta)
        throws (1: base.InvalidRequest invalid_request)

    /** Получить данные customer'а */
    void GetCustomer (1: domain.CustomerID id)
        throws (1: CustomerNotFound not_found, 2: base.InvalidRequest invalid_request)

    /** Удалить customer'а */
    void DeleteCustomer (1: domain.CustomerID id)
        throws (1: CustomerNotFound not_found, 2: base.InvalidRequest invalid_request)

    /* Event polling */
    Events GetEvents (1: domain.CustomerID customer_id, 2: EventRange range)
        throws (
            1: CustomerNotFound     ex1,
            2: EventNotFound ex2,
            3: base.InvalidRequest  ex3
        )
}
