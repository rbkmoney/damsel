include "base.thrift"
include "domain.thrift"
include "msgpack.thrift"

namespace java com.rbkmoney.damsel.subscriptions
namespace erlang subs

/**
 * Generic
 */

typedef i64 Revision
typedef i64 Duration

struct Range {
    1: optional i64 offset
    2: required i16 limit
}

struct TimePeriod {
    1: required TimeUnit unit
    2: required i64      number
}

enum TimeUnit {
    day
    month
    year
}

struct Lifetime {
    1: optional Duration duration
    2: required i16      retries
}

typedef list<Event> Events

struct Event {
    1: required base.EventID   id
    2: required base.Timestamp created_at
    3: required EventPayload   payload
}

struct EventRange {
    1: optional base.EventID after
    2: required i32          limit
}

union EventPayload {
    1: SubscriptionEventPayload     subscription_changes
    2: SubscriptionPlanEventPayload plan_changes
}

/**
 * Subscriptions
 */

 typedef base.ID SubscriptionID
 typedef list<SubscriptionChangeEvent> SubscriptionEventPayload

//Events

//@TODO planId and revision are still changeable on swag
union SubscriptionChangeEvent {
    1: SubscriptionCreated        subscription_created
    2: SubscriptionInvoiceCreated subscription_invoice_created
    3: SubscriptionPayerChanged   subscription_payer_changed
    4: SubscriptionStatusChanged  subscription_status_changed
}

struct SubscriptionCreated {
    1: required Subscription subscription
}

struct SubscriptionInvoiceCreated {
    1: required domain.InvoiceID invoice_id
}

struct SubscriptionPayerChanged {
    1: required domain.Payer payer
}

struct SubscriptionStatusChanged {
    1: required SubscriptionStatus status
}

//Structs

struct PlanRef {
    1: optional PlanID   plan_id
    2: optional Revision plan_revision
}

struct CustomerInfo {
    1: required string        email
    2: optional msgpack.Value metadata
}

enum SubscriptionStatusType {
    active
    suspended
    finished
}

struct SubscriptionStatus {
    1: required SubscriptionStatusType status
    2: required string                 reason
}

struct Subscription {
    1: required SubscriptionID     id
    2: required domain.PartyID     owner_id
    3: required PlanRef            plan_ref
    4: required SubscriptionStatus status
    5: optional domain.Payer       payer
    6: required CustomerInfo       customer_info
    7: optional msgpack.Value      metadata
}

struct SubscriptionCreationArgs {
    1: required SubscriptionID     id
    2: required domain.PartyID     owner_id
    3: required PlanRef            plan_ref
    4: required CustomerInfo       customer_info
    5: optional msgpack.Value      metadata
}

//Exceptions

exception SubscriptionNotFound      {}

// We probably don't want to allow a million payment methods on a single sub
// Especially when MVP only supports one
exception PaymentMethodLimitReached {}

// Fail when trying to activate/suspend an already active/suspended sub
exception InvalidSubscriptionStatus {
    1: required SubscriptionStatus current_status
}

//Service

service Subscriptions {
    Subscription Get (1: SubscriptionID id)
        throws (
            1: SubscriptionNotFound ex1
        )

    set<Subscription> Select (1: Range range)
        throws (
            1: base.InvalidRequest ex1
        )

    Subscription Create (1: SubscriptionCreationArgs creation_args)
        throws (
            1: base.InvalidRequest ex1
        )

    Subscription AddPaymentMethod(1: SubscriptionID id, 2: domain.Payer payer)
        throws (
            1: SubscriptionNotFound      ex1
            2: base.InvalidRequest       ex2
            3: PaymentMethodLimitReached ex3
        )

    Subscription Activate(1: SubscriptionID id)
        throws (
            1: SubscriptionNotFound      ex1
            2: InvalidSubscriptionStatus ex2
        )

    Subscription Suspend(1: SubscriptionID id)
        throws (
            1: SubscriptionNotFound      ex1
            2: InvalidSubscriptionStatus ex2
        )

    Events GetEvents (1: SubscriptionID id, 2: EventRange range)
        throws (
            1: SubscriptionNotFound ex1
            2: base.InvalidRequest  ex2
        )
}

/**
 * Subscription Plans
 */

typedef base.ID PlanID
typedef list<SubscriptionPlanChange> SubscriptionPlanEventPayload

//Events

union SubscriptionPlanChange {
    1: SubscriptionPlanCreated plan_created
    2: SubscriptionPlanChanged plan_changed
    3: SubscriptionPlanDeleted plan_deleted
}

union SubscriptionPlanChanged {
    1:  SubscriptionPlanNameChanged         name_changed
    2:  SubscriptionPlanAmountChanged       amount_changed
    3:  SubscriptionPlanCurrencyChanged     currency_changed
    4:  SubscriptionPlanDescriptionChanged  description_changed
    5:  SubscriptionPlanPresentationChanged presentation_changed
    6:  SubscriptionPlanStatusChanged       status_changed
    7:  SubscriptionPlanScheduleChanged     schedule_changed
    8:  SubscriptionPlanLifetimeChanged     lifetime_changed
    9:  SubscriptionPlanActivationChanged   activation_changed
    10: SubscriptionPlanTrialChanged        trial_changed
}

struct SubscriptionPlanCreated {
    1: required SubscriptionPlan plan
}

struct SubscriptionPlanNameChanged {
    1: required string name
}

struct SubscriptionPlanAmountChanged {
    1: required domain.Amount amount
}

struct SubscriptionPlanCurrencyChanged {
    1: required domain.CurrencyRef currency
}

struct SubscriptionPlanDescriptionChanged {
    1: required string description
}

struct SubscriptionPlanPresentationChanged {
    1: required SubscriptionPlanPresentation presentation
}

struct SubscriptionPlanStatusChanged {
    1: required SubscriptionPlanStatus status
}

struct SubscriptionPlanScheduleChanged {
    1: required TimePeriod schedule
}

struct SubscriptionPlanLifetimeChanged {
    1: required Lifetime lifetime
}

struct SubscriptionPlanActivationChanged {
    1: required SubscriptionPlanActivation activation_params
}

struct SubscriptionPlanTrialChanged {
    1: required SubscriptionPlanTrial trial_params
}

struct SubscriptionPlanDeleted {}

//Structs

struct SubscriptionPlan {
    1:  required PlanID                       id
    2:  required domain.PartyID               owner_id
    3:  required string                       name
    4:  required domain.Amount                amount
    5:  required domain.CurrencyRef           currency
    6:  optional string                       description
    7:  optional SubscriptionPlanPresentation presentation
    8:  required SubscriptionPlanStatus       status
    9:  required TimePeriod                   schedule
    10: required Lifetime                     lifetime
    11: optional SubscriptionPlanActivation   activation_params
    12: optional SubscriptionPlanTrial        trial_params
}

struct SubscriptionPlanPresentation {
    1: required string description
}

enum SubscriptionPlanStatus {
    active
    inactive
    deleted
}

struct SubscriptionPlanActivation {
    1: required domain.Amount amount
    2: required bool          enabled
}

struct SubscriptionPlanTrial {
    1: required domain.Amount amount
    2: required Duration      duration
    3: required bool          enabled
}

//Exceptions

exception PlanNotFound     {}
exception RevisionNotFound {}

//Service

service SubscriptionPlans {
    SubscriptionPlan GetLatest (1: PlanID id)
        throws (
            1: PlanNotFound ex1
        )

    SubscriptionPlan Get (1: PlanID id, 2: Revision revision)
        throws (
            1: PlanNotFound     ex1
            2: RevisionNotFound ex2
        )

    set<SubscriptionPlan> Select (1: Range range)
        throws (
            1: base.InvalidRequest ex1
        )

    SubscriptionPlan Create (1: SubscriptionPlan plan)
        throws (
            1: base.InvalidRequest ex1
        )

    SubscriptionPlan Update (1: PlanID id, 2: list<SubscriptionPlanChanged> changes)
        throws (
            1: base.InvalidRequest ex1
        )

    SubscriptionPlan Delete (1: PlanID id)
        throws (
            1: PlanNotFound ex1
        )
}
