include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.webhooker
namespace erlang webhooker

typedef string Url
typedef string Key
typedef i64 WebhookID
exception WebhookNotFound {}
exception LimitExceeded {}

struct Webhook {
    1: required WebhookID id
    2: required domain.PartyID party_id
    3: required EventFilter event_filter
    4: required Url url
    5: required Key pub_key
    6: required bool enabled
}

struct WebhookParams {
    1: required domain.PartyID party_id
    2: required EventFilter event_filter
    3: required Url url
}

union EventFilter {
    1: PartyEventFilter party
    2: InvoiceEventFilter invoice
    3: CustomerEventFilter customer
    4: WalletEventFilter wallet
}

struct PartyEventFilter {
    1: required set<PartyEventType> types
}

union PartyEventType {
    1: ClaimEventType claim
}

union ClaimEventType {
    1: ClaimCreated created
    2: ClaimDenied denied
    3: ClaimAccepted accepted
}

struct ClaimCreated {}
struct ClaimDenied {}
struct ClaimAccepted {}

struct InvoiceEventFilter {
    1: required set<InvoiceEventType> types
    2: optional domain.ShopID shop_id
}

union InvoiceEventType {
    1: InvoiceCreated created
    2: InvoiceStatusChanged status_changed
    3: InvoicePaymentEventType payment
}

struct InvoiceCreated {}
struct InvoiceStatusChanged {
    1: optional InvoiceStatus value
}

union InvoiceStatus {
    1: InvoiceUnpaid unpaid
    2: InvoicePaid paid
    3: InvoiceCancelled cancelled
    4: InvoiceFulfilled fulfilled
}

struct InvoiceUnpaid    {}
struct InvoicePaid      {}
struct InvoiceCancelled {}
struct InvoiceFulfilled {}

union InvoicePaymentEventType {
    1: InvoicePaymentCreated created
    2: InvoicePaymentStatusChanged status_changed
    3: InvoicePaymentRefundChange invoice_payment_refund_change
}

struct InvoicePaymentCreated {}
struct InvoicePaymentStatusChanged {
    1: optional InvoicePaymentStatus value
}

union InvoicePaymentRefundChange {
    1: InvoicePaymentRefundCreated invoice_payment_refund_created
    2: InvoicePaymentRefundStatusChanged invoice_payment_refund_status_changed
}

struct InvoicePaymentRefundCreated {}
struct InvoicePaymentRefundStatusChanged {
    1: required InvoicePaymentRefundStatus value
}

union InvoicePaymentStatus {
    1: InvoicePaymentPending pending
    4: InvoicePaymentProcessed processed
    2: InvoicePaymentCaptured captured
    5: InvoicePaymentCancelled cancelled
    3: InvoicePaymentFailed failed
    6: InvoicePaymentRefunded refunded
}

struct InvoicePaymentPending   {}
struct InvoicePaymentProcessed {}
struct InvoicePaymentCaptured  {}
struct InvoicePaymentCancelled {}
struct InvoicePaymentFailed    {}
struct InvoicePaymentRefunded  {}

union InvoicePaymentRefundStatus {
    1: InvoicePaymentRefundPending pending
    2: InvoicePaymentRefundSucceeded succeeded
    3: InvoicePaymentRefundFailed failed
}

struct InvoicePaymentRefundPending {}
struct InvoicePaymentRefundSucceeded {}
struct InvoicePaymentRefundFailed {}

struct CustomerEventFilter {
    1: required set<CustomerEventType> types
    2: optional domain.ShopID shop_id
}

union CustomerEventType {
    1: CustomerCreated created
    2: CustomerDeleted deleted
    3: CustomerStatusReady ready
    4: CustomerBindingEvent binding
}

struct CustomerCreated {}
struct CustomerDeleted {}
struct CustomerStatusReady {}

union CustomerBindingEvent {
    1: CustomerBindingStarted started
    2: CustomerBindingSucceeded succeeded
    3: CustomerBindingFailed failed
}

struct CustomerBindingStarted {}
struct CustomerBindingSucceeded {}
struct CustomerBindingFailed {}

struct WalletEventFilter {
    1: required set<WalletEventType> types
}

union WalletEventType {
    1: WalletWithdrawalEventType withdrawal
}

union WalletWithdrawalEventType {
    1: WalletWithdrawalStarted started
    2: WalletWithdrawalSucceeded succeeded
    3: WalletWithdrawalFailed failed
}

struct WalletWithdrawalStarted {}
struct WalletWithdrawalSucceeded {}
struct WalletWithdrawalFailed {}

service WebhookManager {
    list<Webhook> GetList(1: domain.PartyID party_id)
    Webhook Get(1: WebhookID webhook_id) throws (1: WebhookNotFound ex1)
    Webhook Create(1: WebhookParams webhook_params) throws (1: LimitExceeded ex1)
    void Delete(1: WebhookID webhook_id) throws (1: WebhookNotFound ex1)
}
