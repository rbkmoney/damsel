/**
 * Определения и сервисы инвойсинга.
 *
 * NB: В данный момент это лишь зачатки сервиса, поэтому основная часть invoicing'а
 * все еще находится в payment_processing.thrift
 */

include "base.thrift"
include "domain.thrift"
include "payment_processing.thrift"

namespace java com.rbkmoney.damsel.invoicing
namespace erlang invoicing

/* Events */

typedef list<Event> Events

struct Event {
    1: required base.EventID   id
    2: required base.Timestamp created_at
    3: required EventSource    source
    4: required EventPayload   payload
}

union EventSource {
    1: BindingID binding_id
}

union EventPayload {
    1: list<CustomerChange> customer_changes
    2: list<BindingChange>  binding_changes
}

struct EventRange {
    1: optional base.EventID after
    2: required i32          limit
}

/* Customers */

typedef domain.CustomerID           CustomerID
typedef payment_processing.UserInfo UserInfo

struct CustomerParams {
    1: required domain.Metadata metadata
}

struct Customer {
    1: required CustomerID      id
    2: required list<Binding>   bindings
    3: optional BindingID       active_binding
    4: optional base.Timestamp  updated_at
    5: optional domain.Metadata metadata
}

// Events

union CustomerChange {
    1: CustomerCreated            customer_created
    2: CustomerDeleted            customer_deleted
    3: CustomerPaymentMeanBound   customer_payment_mean_bound
    4: CustomerPaymentMeanUnbound customer_payment_mean_unbound
}

struct CustomerCreated {
    1: required Customer customer
}

struct CustomerDeleted {}

struct CustomerBindingStarted {
    1: required CustomerID id
    2: required BindingID  binding_id
}

struct CustomerBindingFinished {
    1: required CustomerID id
    2: required BindingID  binding_id
    3: required payment_processing.PaymentMeanStatus payment_mean_status
}

struct CustomerPaymentMeanBound {
    1: required CustomerID id
    2: required BindingID  binding_id
}

struct CustomerPaymentMeanUnbound {}

// Exceptions

exception InvalidUser        {}
exception CustomerNotFound   {}
exception BindingNotFound    {}
exception InvalidPaymentTool {}
exception EventNotFound      {}

// Service

service CustomerManagement {

    Customer Create (1: UserInfo user, 2: CustomerParams params)
        throws (
            1: InvalidUser         invalid_user,
            2: base.InvalidRequest invalid_request
        )

    Customer Get (1: UserInfo user, 2: CustomerID id)
        throws (1: CustomerNotFound not_found)

    void Delete (1: UserInfo user, 2: CustomerID id)
        throws (1: CustomerNotFound not_found)

    Binding StartBinding (1: UserInfo user, 2: CustomerID customer_id, 3: domain.PaymentTool payment_tool)
        throws (
            1: CustomerNotFound   customer_not_found,
            2: InvalidPaymentTool invalid_payment_tool
        )

    void Unbind (1: UserInfo user, 2: CustomerID customer_id, 3: BindingID binding_id)
        throws (
            1: CustomerNotFound not_found
            2: BindingNotFound  binding_not_found
        )

    Events GetEvents (1: UserInfo user, 2: CustomerID customer_id, 3: EventRange range)
        throws (
            1: CustomerNotFound customer_not_found,
            2: EventNotFound    event_not_found
        )
}

/* Bindings */

typedef base.ID                          PaymentMeanBindingID
typedef base.ID                          BindingID
typedef payment_processing.PaymentMeanID PaymentMeanID

struct Binding {
    1: required BindingID          id
    2: required PaymentMeanID      payment_mean_id
    3: required domain.PaymentTool source_payment_tool
    4: required BindingStatus      status
}

// Statuses

union BindingStatus {
    1: BindingCreated   created
    2: BindingSucceeded succeeded
    3: BindingFailed    failed
}

struct BindingCreated   {}
struct BindingSucceeded {}
struct BindingFailed    { 1: BindingFailure failure }

struct BindingFailure {
    1: required string details
}

// Events

union BindingChange {
    1: BindingStarted   binding_started
    3: BindingSucceeded binding_succeeded
    4: BindingFailed    binding_failed
}

struct BindingStarted {
    1: required payment_processing.PaymentMean payment_mean
}

struct BindingFinished {
    1: required BindingStatus       status
    2: optional domain.Token        token
    3: optional domain.PaymentRoute route
}
