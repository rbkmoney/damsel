include "base.thrift"
include "domain.thrift"
include "cash_flow.thrift"

namespace java com.rbkmoney.damsel.invoice_adjustments
namespace erlang invoice_adj

/* Adjustments */

struct InvoiceAdjustment {
    1: required domain.InvoiceAdjustmentID id
    2: required string reason
    3: required base.Timestamp created_at
    4: required InvoiceAdjustmentStatus status
    5: required domain.DataRevision domain_revision
    6: optional domain.PartyRevision party_revision
    7: optional InvoiceAdjustmentState state
}

struct InvoiceAdjustmentPending   {}
struct InvoiceAdjustmentProcessed {}
struct InvoiceAdjustmentCaptured  { 1: required base.Timestamp at }
struct InvoiceAdjustmentCancelled { 1: required base.Timestamp at }

union InvoiceAdjustmentStatus {
    1: InvoiceAdjustmentPending   pending
    2: InvoiceAdjustmentCaptured  captured
    3: InvoiceAdjustmentCancelled cancelled
    4: InvoiceAdjustmentProcessed processed
}

/**
 * Специфическое для выбранного сценария состояние поправки к инвойсу.
 */
union InvoiceAdjustmentState {
    1: InvoiceAdjustmentStatusChangeState status_change
}

struct InvoiceAdjustmentStatusChangeState {
    1: required InvoiceAdjustmentStatusChange scenario
}

/**
 * Параметры поправки к инвойсу, используемые для смены его статуса.
 */
struct InvoiceAdjustmentStatusChange {
    /** Статус, в который необходимо перевести инвойс. */
    1: required domain.InvoiceStatus target_status
}

struct InvoicePaymentAdjustment {
    1: required domain.InvoicePaymentAdjustmentID id
    2: required InvoicePaymentAdjustmentStatus status
    3: required base.Timestamp created_at
    4: required domain.DataRevision domain_revision
    5: required string reason
    6: required domain.FinalCashFlow deprecated_new_cash_flow
    7: required domain.FinalCashFlow deprecated_old_cash_flow_inverse
    10: optional cash_flow.CashFlow new_cash_flow
    11: optional cash_flow.CashFlow old_cash_flow_inverse
    8: optional domain.PartyRevision party_revision
    9: optional InvoicePaymentAdjustmentState state
}

struct InvoicePaymentAdjustmentPending   {}
struct InvoicePaymentAdjustmentProcessed {}
struct InvoicePaymentAdjustmentCaptured  { 1: required base.Timestamp at }
struct InvoicePaymentAdjustmentCancelled { 1: required base.Timestamp at }

union InvoicePaymentAdjustmentStatus {
    1: InvoicePaymentAdjustmentPending     pending
    2: InvoicePaymentAdjustmentCaptured   captured
    3: InvoicePaymentAdjustmentCancelled cancelled
    4: InvoicePaymentAdjustmentProcessed processed
}

/**
 * Специфическое для выбранного сценария состояние поправки к платежу.
 */
union InvoicePaymentAdjustmentState {
    1: InvoicePaymentAdjustmentCashFlowState cash_flow
    2: InvoicePaymentAdjustmentStatusChangeState status_change
}

struct InvoicePaymentAdjustmentCashFlowState {
    1: required InvoicePaymentAdjustmentCashFlow scenario
}

struct InvoicePaymentAdjustmentStatusChangeState {
    1: required InvoicePaymentAdjustmentStatusChange scenario
}

/**
 * Параметры поправки к платежу, используемые для пересчёта графа финансовых потоков.
 */
struct InvoicePaymentAdjustmentCashFlow {
    /** Ревизия, относительно которой необходимо пересчитать граф финансовых потоков. */
    1: optional domain.DataRevision domain_revision
}

/**
 * Параметры поправки к платежу, используемые для смены его статуса.
 */
struct InvoicePaymentAdjustmentStatusChange {
    /** Статус, в который необходимо перевести платёж. */
    1: required domain.InvoicePaymentStatus target_status
}
