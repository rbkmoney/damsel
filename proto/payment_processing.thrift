/**
 * Определения и сервисы процессинга.
 */

include "base.thrift"
include "domain.thrift"
include "user_interaction.thrift"
include "timeout_behaviour.thrift"
include "repairing.thrift"
include "msgpack.thrift"

namespace java com.rbkmoney.damsel.payment_processing
namespace erlang payproc

/* Interface clients */

typedef base.ID UserID

struct UserInfo {
    1: required UserID id
    2: required UserType type
}

/* Временная замена ролям пользователей для разграничения доступа в HG */
union UserType {
    1: InternalUser internal_user
    2: ExternalUser external_user
    3: ServiceUser  service_user
}

struct InternalUser {}

struct ExternalUser {}

struct ServiceUser {}

/* Events */

typedef list<Event> Events

/**
 * Событие, атомарный фрагмент истории бизнес-объекта, например инвойса.
 */
struct Event {

    /**
     * Идентификатор события.
     * Монотонно возрастающее целочисленное значение, таким образом на множестве
     * событий задаётся отношение полного порядка (total order).
     */
    1: required base.EventID id

    /**
     * Время создания события.
     */
    2: required base.Timestamp created_at

    /**
     * Идентификатор бизнес-объекта, источника события.
     */
    3: required EventSource source

    /**
     * Содержание события, состоящее из списка (возможно пустого)
     * изменений состояния бизнес-объекта, источника события.
     */
    4: required EventPayload payload

    /**
     * Идентификатор события в рамках одной машины.
     * Монотонно возрастающее целочисленное значение.
     */
    5: optional base.SequenceID sequence
}

/**
 * Источник события, идентификатор бизнес-объекта, который породил его в
 * процессе выполнения определённого бизнес-процесса.
 */
union EventSource {
    /** Идентификатор инвойса, который породил событие. */
    1: domain.InvoiceID         invoice_id
    /** Идентификатор участника, который породил событие. */
    2: domain.PartyID           party_id
    /** Идентификатор шаблона инвойса, который породил событие. */
    3: domain.InvoiceTemplateID invoice_template_id
    /** Идентификатор плательщика, который породил событие. */
    4: domain.CustomerID        customer_id
}

/**
 * Один из возможных вариантов содержания события.
 */
union EventPayload {
    /** Набор изменений, порождённых инвойсом. */
    1: list<InvoiceChange>          invoice_changes
    /** Набор изменений, порождённых участником. */
    2: list<PartyChange>            party_changes
    /** Набор изменений, порождённых шаблоном инвойса. */
    3: list<InvoiceTemplateChange>  invoice_template_changes
    /** Некоторое событие, порождённое плательщиком. */
    4: list<CustomerChange>         customer_changes
}

/**
 * Один из возможных вариантов события, порождённого инвойсом.
 */
union InvoiceChange {
    1: InvoiceCreated          invoice_created
    2: InvoiceStatusChanged    invoice_status_changed
    3: InvoicePaymentChange    invoice_payment_change
    4: InvoiceAdjustmentChange invoice_adjustment_change
}

union InvoiceTemplateChange {
    1: InvoiceTemplateCreated invoice_template_created
    2: InvoiceTemplateUpdated invoice_template_updated
    3: InvoiceTemplateDeleted invoice_template_deleted
}

/**
 * Событие о создании нового инвойса.
 */
struct InvoiceCreated {
    /** Данные созданного инвойса. */
    1: required domain.Invoice invoice
}

/**
 * Событие об изменении статуса инвойса.
 */
struct InvoiceStatusChanged {
    /** Новый статус инвойса. */
    1: required domain.InvoiceStatus status
}

/**
 * Событие, касающееся определённого платежа по инвойсу.
 */
struct InvoicePaymentChange {
    1: required domain.InvoicePaymentID id
    2: required InvoicePaymentChangePayload payload
    3: optional base.Timestamp occurred_at
}

/**
 * Событие, касающееся корректировки по инвойсу.
 */
struct InvoiceAdjustmentChange {
    1: required domain.InvoiceAdjustmentID id
    2: required InvoiceAdjustmentChangePayload payload
    3: optional base.Timestamp occurred_at
}

/**
 * Один из возможных вариантов события, порождённого корректировкой по инвойсу.
 */
union InvoiceAdjustmentChangePayload {
    1: InvoiceAdjustmentCreated       invoice_adjustment_created
    2: InvoiceAdjustmentStatusChanged invoice_adjustment_status_changed
}

/**
 * Событие о создании корректировки инвойса
 */
struct InvoiceAdjustmentCreated {
    1: required domain.InvoiceAdjustment adjustment
}

/**
 * Событие об изменении статуса корректировки платежа
 */
struct InvoiceAdjustmentStatusChanged {
    1: required domain.InvoiceAdjustmentStatus status
}

/**
 * Один из возможных вариантов события, порождённого платежом по инвойсу.
 */
union InvoicePaymentChangePayload {
    1: InvoicePaymentStarted                invoice_payment_started
    8: InvoicePaymentRiskScoreChanged       invoice_payment_risk_score_changed
    9: InvoicePaymentRouteChanged           invoice_payment_route_changed
    10: InvoicePaymentCashFlowChanged       invoice_payment_cash_flow_changed
    3: InvoicePaymentStatusChanged          invoice_payment_status_changed
    2: InvoicePaymentSessionChange          invoice_payment_session_change
    7: InvoicePaymentRefundChange           invoice_payment_refund_change
    6: InvoicePaymentAdjustmentChange       invoice_payment_adjustment_change
    11: InvoicePaymentRecTokenAcquired      invoice_payment_rec_token_acquired
    12: InvoicePaymentCaptureStarted        invoice_payment_capture_started
    13: InvoicePaymentChargebackChange      invoice_payment_chargeback_change
    14: InvoicePaymentRollbackStarted       invoice_payment_rollback_started
    15: InvoicePaymentClockUpdate           invoice_payment_clock_update
}

/**
 * Событие об запуске платежа по инвойсу.
 */
struct InvoicePaymentStarted {
    /** Данные запущенного платежа. */
    1: required domain.InvoicePayment payment

    /** deprecated */
    /** Оценка риска платежа. */
    4: optional domain.RiskScore risk_score
    /** Выбранный маршрут обработки платежа. */
    2: optional domain.PaymentRoute route
    /** Данные финансового взаимодействия. */
    3: optional domain.FinalCashFlow cash_flow
}

struct InvoicePaymentClockUpdate {
    1: required domain.AccounterClock clock
}

struct InvoicePaymentRollbackStarted {
    1: required domain.OperationFailure reason
}

/**
 * Событие об изменении оценки риска платежа.
 */
struct InvoicePaymentRiskScoreChanged {
    /** Оценка риска платежа. */
    1: required domain.RiskScore risk_score
}

/**
 * Событие об изменении маршрута обработки платежа.
 */
struct InvoicePaymentRouteChanged {
    /** Выбранный маршрут обработки платежа. */
    1: required domain.PaymentRoute route
}

/**
 * Событие об изменении данных финансового взаимодействия.
 */
struct InvoicePaymentCashFlowChanged {
    /** Данные финансового взаимодействия. */
    1: required domain.FinalCashFlow cash_flow
}

/**
 * Событие об изменении статуса платежа по инвойсу.
 */
struct InvoicePaymentStatusChanged {
    /** Статус платежа по инвойсу. */
    1: required domain.InvoicePaymentStatus status
}

/**
 * Событие в рамках сессии взаимодействия с провайдером.
 */
struct InvoicePaymentSessionChange {
    1: required domain.TargetInvoicePaymentStatus target
    2: required SessionChangePayload payload
}

/**
 * Один из возможных вариантов события, порождённого сессией взаимодействия.
 */
union SessionChangePayload {
    1: SessionStarted              session_started
    2: SessionFinished             session_finished
    3: SessionSuspended            session_suspended
    4: SessionActivated            session_activated
    5: SessionTransactionBound     session_transaction_bound
    6: SessionProxyStateChanged    session_proxy_state_changed
    7: SessionInteractionRequested session_interaction_requested
}

struct SessionStarted {}

struct SessionFinished {
    1: required SessionResult result
}

struct SessionSuspended {
    1: optional base.Tag tag
    2: optional timeout_behaviour.TimeoutBehaviour timeout_behaviour
}

struct SessionActivated {}

union SessionResult {
    1: SessionSucceeded succeeded
    2: SessionFailed    failed
}

struct SessionSucceeded {}

struct SessionFailed {
    1: required domain.OperationFailure failure
}

/**
 * Событие о создании нового шаблона инвойса.
 */
struct InvoiceTemplateCreated {
    /** Данные созданного шаблона инвойса. */
    1: required domain.InvoiceTemplate invoice_template
}

/**
 * Событие о модификации шаблона инвойса.
 */
struct InvoiceTemplateUpdated {
    /** Данные модифицированного шаблона инвойса. */
    1: required InvoiceTemplateUpdateParams diff
}

/**
 * Событие об удалении шаблона инвойса.
 */
struct InvoiceTemplateDeleted {}

/**
 * Событие о том, что появилась связь между платежом по инвойсу и транзакцией
 * у провайдера.
 */
struct SessionTransactionBound {
    /** Данные о связанной транзакции у провайдера. */
    1: required domain.TransactionInfo trx
}

/**
 * Событие о том, что изменилось непрозрачное состояние прокси в рамках сессии.
 */
struct SessionProxyStateChanged {
    1: required base.Opaque proxy_state
}

/**
 * Событие о запросе взаимодействия с плательщиком.
 */
struct SessionInteractionRequested {
    /** Необходимое взаимодействие */
    1: required user_interaction.UserInteraction interaction
}

/**
 * Событие, касающееся определённого чарджбека.
 */
struct InvoicePaymentChargebackChange {
    1: required domain.InvoicePaymentChargebackID id
    2: required InvoicePaymentChargebackChangePayload payload
    3: optional base.Timestamp occurred_at
}

/**
 * Один из возможных вариантов события, порождённого чарджбеком платежа по инвойсу.
 */
union InvoicePaymentChargebackChangePayload {
    1: InvoicePaymentChargebackCreated              invoice_payment_chargeback_created
    2: InvoicePaymentChargebackStatusChanged        invoice_payment_chargeback_status_changed
    3: InvoicePaymentChargebackCashFlowChanged      invoice_payment_chargeback_cash_flow_changed
    4: InvoicePaymentChargebackBodyChanged          invoice_payment_chargeback_body_changed
    5: InvoicePaymentChargebackLevyChanged          invoice_payment_chargeback_levy_changed
    6: InvoicePaymentChargebackStageChanged         invoice_payment_chargeback_stage_changed
    7: InvoicePaymentChargebackTargetStatusChanged  invoice_payment_chargeback_target_status_changed
    8: InvoicePaymentClockUpdate                    invoice_payment_chargeback_clock_update
}

/**
 * Событие о создании чарджбека
 */
struct InvoicePaymentChargebackCreated {
    1: required domain.InvoicePaymentChargeback chargeback
}

/**
 * Событие об изменении статуса чарджбека
 */
struct InvoicePaymentChargebackStatusChanged {
    1: required domain.InvoicePaymentChargebackStatus status
}

/**
 * Событие об изменении кэшфлоу чарджбека
 */
struct InvoicePaymentChargebackCashFlowChanged {
    1: required domain.FinalCashFlow cash_flow
}

/**
 * Событие об изменении объёма чарджбека
 */
struct InvoicePaymentChargebackBodyChanged {
    1: required domain.Cash body
}

/**
 * Событие об изменении размера списываемых средств у чарджбека
 */
struct InvoicePaymentChargebackLevyChanged {
    2: required domain.Cash levy
}

/**
 * Событие об изменении стадии чарджбека
 */
struct InvoicePaymentChargebackStageChanged {
    1: required domain.InvoicePaymentChargebackStage stage
}

/**
 * Событие об изменении целевого статуса чарджбека
 */
struct InvoicePaymentChargebackTargetStatusChanged {
    1: required domain.InvoicePaymentChargebackStatus status
}

/**
 * Событие, касающееся определённого возврата платежа.
 */
struct InvoicePaymentRefundChange {
    1: required domain.InvoicePaymentRefundID id
    2: required InvoicePaymentRefundChangePayload payload
}

/**
 * Один из возможных вариантов события, порождённого возратом платежа по инвойсу.
 */
union InvoicePaymentRefundChangePayload {
    1: InvoicePaymentRefundCreated         invoice_payment_refund_created
    2: InvoicePaymentRefundStatusChanged   invoice_payment_refund_status_changed
    3: InvoicePaymentSessionChange         invoice_payment_session_change
    4: InvoicePaymentRefundRollbackStarted invoice_payment_refund_rollback_started
    5: InvoicePaymentClockUpdate           invoice_payment_refund_clock_update
}

/**
 * Событие о создании возврата платежа
 */
struct InvoicePaymentRefundCreated {
    1: required domain.InvoicePaymentRefund refund
    2: required domain.FinalCashFlow cash_flow

    /**
    * Данные проведённой вручную транзакции.
    * В случае присутствия при обработке возврата этап обращения к адаптеру будет пропущен,
    * а эти данные будут использованы в качестве результата
    */
    3: optional domain.TransactionInfo transaction_info
}

/**
 * Событие об изменении статуса возврата платежа
 */
struct InvoicePaymentRefundStatusChanged {
    1: required domain.InvoicePaymentRefundStatus status
}

struct InvoicePaymentRefundRollbackStarted {
    1: required domain.OperationFailure reason
}

/**
 * Событие, касающееся определённой корректировки платежа.
 */
struct InvoicePaymentAdjustmentChange {
    1: required domain.InvoicePaymentAdjustmentID id
    2: required InvoicePaymentAdjustmentChangePayload payload
}

/**
 * Один из возможных вариантов события, порождённого корректировкой платежа по инвойсу.
 */
union InvoicePaymentAdjustmentChangePayload {
    1: InvoicePaymentAdjustmentCreated       invoice_payment_adjustment_created
    2: InvoicePaymentAdjustmentStatusChanged invoice_payment_adjustment_status_changed
    3: InvoicePaymentClockUpdate             invoice_payment_adjustment_clock_update
}

/**
 * Событие о создании корректировки платежа
 */
struct InvoicePaymentAdjustmentCreated {
    1: required domain.InvoicePaymentAdjustment adjustment
}

/**
 * Событие об изменении статуса корректировки платежа
 */
struct InvoicePaymentAdjustmentStatusChanged {
    1: required domain.InvoicePaymentAdjustmentStatus status
}

/**
 * Событие о полуечнии рекуррентного токена
 */
struct InvoicePaymentRecTokenAcquired {
    1: required domain.Token token
}

struct InvoicePaymentCaptureStarted {
    1: required InvoicePaymentCaptureParams params
}

/**
 * Диапазон для выборки событий.
 */
struct EventRange {

    /**
     * Идентификатор события, за которым должны следовать попадающие в выборку
     * события.
     *
     * Если `after` не указано, в выборку попадут события с начала истории; если
     * указано, например, `42`, то в выборку попадут события, случившиеся _после_
     * события `42`.
     */
    1: optional base.EventID after

    /**
     * Максимальное количество событий в выборке.
     *
     * В выборку может попасть количество событий, _не больше_ указанного в
     * `limit`. Если в выборку попало событий _меньше_, чем значение `limit`,
     * был достигнут конец текущей истории.
     *
     * _Допустимые значения_: неотрицательные числа
     */
    2: optional i32 limit

}

/* Invoicing service definitions */

struct InvoiceParams {
    1: required PartyID party_id
    2: required ShopID shop_id
    3: required domain.InvoiceDetails details
    4: required base.Timestamp due
    5: required domain.Cash cost
    6: required domain.InvoiceContext context
    7: optional domain.InvoiceID id
    8: optional string external_id
    9: optional bool   trusted_client  /* мерчант передаёт сведения о надёжности плательщика */
}

struct InvoiceWithTemplateParams {
    1: required domain.InvoiceTemplateID template_id
    2: optional domain.Cash cost
    3: optional domain.InvoiceContext context
    4: optional domain.InvoiceID id
    5: optional string external_id
}

struct InvoiceTemplateCreateParams {
    1: required PartyID party_id
    2: required ShopID shop_id
    4: required domain.LifetimeInterval invoice_lifetime
    7: required string product # for backward compatibility
    8: optional string description
    9: required domain.InvoiceTemplateDetails details
    6: required domain.InvoiceContext context
}

struct InvoiceTemplateUpdateParams {
    2: optional domain.LifetimeInterval invoice_lifetime
    5: optional string product # for backward compatibility
    6: optional string description
    7: optional domain.InvoiceTemplateDetails details
    4: optional domain.InvoiceContext context
}

struct InvoicePaymentParams {
    1: required PayerParams payer
    2: required InvoicePaymentParamsFlow flow
    3: optional bool make_recurrent
    4: optional domain.InvoicePaymentID id
    5: optional string external_id
    6: optional domain.InvoicePaymentContext context
    7: optional base.Timestamp processing_deadline
}

union PayerParams {
    1: PaymentResourcePayerParams payment_resource
    2: CustomerPayerParams        customer
    3: RecurrentPayerParams       recurrent
}

struct PaymentResourcePayerParams {
    1: required domain.DisposablePaymentResource resource
    2: required domain.ContactInfo               contact_info
}

struct CustomerPayerParams {
    1: required domain.CustomerID customer_id
}

struct RecurrentPayerParams{
    1: required domain.RecurrentParentPayment recurrent_parent
    2: required domain.ContactInfo            contact_info
}

union InvoicePaymentParamsFlow {
    1: InvoicePaymentParamsFlowInstant instant
    2: InvoicePaymentParamsFlowHold hold
}

struct InvoicePaymentParamsFlowInstant {}

struct InvoicePaymentParamsFlowHold {
    1: required domain.OnHoldExpiration on_hold_expiration
}

struct Invoice {
    1: required domain.Invoice invoice
    2: required list<InvoicePayment> payments
    3: optional list<InvoiceAdjustment> adjustments
}

struct InvoicePayment {
    1: required domain.InvoicePayment payment
    6: optional domain.PaymentRoute route
    7: optional FinalCashFlow cash_flow
    2: required list<InvoicePaymentAdjustment> adjustments
    4: required list<InvoicePaymentRefund> refunds
    5: required list<InvoicePaymentSession> sessions
    8: optional list<InvoicePaymentChargeback> chargebacks
    9: optional domain.TransactionInfo last_transaction_info
    # deprecated
    3: required list<domain.InvoicePaymentRefund> legacy_refunds
}

struct InvoicePaymentRefund {
    1: required domain.InvoicePaymentRefund refund
    2: required list<InvoiceRefundSession> sessions
    3: optional FinalCashFlow cash_flow
}

struct InvoicePaymentSession {
    1: required domain.TargetInvoicePaymentStatus target_status
    2: optional domain.TransactionInfo transaction_info
}

struct InvoiceRefundSession {
    1: optional domain.TransactionInfo transaction_info
}

typedef domain.InvoiceAdjustment InvoiceAdjustment
typedef domain.InvoicePaymentAdjustment InvoicePaymentAdjustment

struct InvoicePaymentChargeback {
    1: required domain.InvoicePaymentChargeback chargeback
    2: optional FinalCashFlow cash_flow
}

/**
 * Параметры создаваемого чарджбэка.
 */
struct InvoicePaymentChargebackParams {
    /**
     * Идентификатор чарджбэка
     */
    5: required domain.InvoicePaymentChargebackID id
    /**
    * Код причины чарджбэка
    */
    1: required domain.InvoicePaymentChargebackReason reason

    /**
     * Сумма списания: количество денежных средств, подлежащих удержанию
     * со счёта продавца.
     */
    2: required domain.Cash levy
    /**
     * Размер опротестования.
     * Если не указан, то считаем, что это возврат на полную сумму платежа.
     * Не может быть больше суммы платежа.
     */
    3: optional domain.Cash body
    /**
     * Данные проведённой вручную транзакции
     */
    4: optional domain.TransactionInfo transaction_info
    /**
     * Внешний идентификатор объекта
     */
    6: optional string external_id
    /**
     * Дополнительные метаданные по чарджбэку
     */
    7: optional domain.InvoicePaymentChargebackContext context
    /**
     * Фактическое время создания
     */
    8: optional base.Timestamp occurred_at
}

struct InvoicePaymentChargebackAcceptParams {
    /**
     * Сумма возврата.
     * Если сумма не указана, то текущая сумма не меняется
     */
    1: optional domain.Cash body
    /**
     * Сумма списания.
     * Если сумма не указана, то текущая сумма не меняется
     */
    2: optional domain.Cash levy
    /**
     * Фактическое время принятия
     */
    3: optional base.Timestamp occurred_at
}

struct InvoicePaymentChargebackReopenParams {
    /**
     * Сумма возврата.
     * Если сумма не указана, то текущая сумма не меняется
     */
    1: optional domain.Cash body

    /**
     * Сумма списания.
     */
    2: optional domain.Cash levy
    /**
     * Фактическое время опротестования
     */
    3: optional base.Timestamp occurred_at
    /**
     * Возможность переместить стадию
     */
    4: optional domain.InvoicePaymentChargebackStage move_to_stage
}

struct InvoicePaymentChargebackRejectParams {
    /**
     * Сумма списания.
     */
    1: optional domain.Cash levy
    /**
     * Фактическое время отклонения
     */
    8: optional base.Timestamp occurred_at
}

struct InvoicePaymentChargebackCancelParams {
    /**
     * Фактическое время отмены
     */
    1: optional base.Timestamp occurred_at
}

typedef domain.FinalCashFlow FinalCashFlow

/**
 * Параметры создаваемого возврата платежа.
 */
struct InvoicePaymentRefundParams {
    /** Причина, на основании которой производится возврат. */
    1: optional string reason
    /**
     * Сумма возврата.
     * Если сумма не указана, то считаем, что это возврат на полную сумму платежа.
     */
    2: optional domain.Cash cash
    /**
     * Данные проведённой вручную транзакции
     */
    3: optional domain.TransactionInfo transaction_info
    /**
     * Итоговая корзина товаров.
     * Используется для частичного возврата, содержит позиции, которые остались после возврата.
     */
    4: optional domain.InvoiceCart cart
    /**
     * Идентификатор рефанда
     */
    5: optional domain.InvoicePaymentRefundID id
    /**
     * Внешний идентификатор объекта
     */
    6: optional string external_id
}

/**
 * Параметры подтверждаемого платежа.
 */
struct InvoicePaymentCaptureParams {
    /** Причина совершения операции. */
    1: required string reason
    /**
     * Подтверждаемая сумма.
     * Если сумма не указана, то считаем, что подтверждаем полную сумму платежа.
     */
    2: optional domain.Cash cash
    3: optional domain.InvoiceCart cart
}

/**
 * Параметры создаваемой поправки к инвойсу.
 */
struct InvoiceAdjustmentParams {
    /** Причина, на основании которой создаётся поправка. */
    1: required string reason
    /** Сценарий создаваемой поправки. */
    2: required InvoiceAdjustmentScenario scenario
}

/**
 * Сценарий поправки к инвойсу.
 */
union InvoiceAdjustmentScenario {
    1: domain.InvoiceAdjustmentStatusChange status_change
}

/**
 * Параметры создаваемой поправки к платежу.
 */
struct InvoicePaymentAdjustmentParams {
    /** Deprecated! Ревизия, относительно которой необходимо пересчитать граф финансовых потоков. */
    1: optional domain.DataRevision legacy_domain_revision
    /** Причина, на основании которой создаётся поправка. */
    2: required string reason
    /** Сценарий создаваемой поправки. */
    3: optional InvoicePaymentAdjustmentScenario scenario
}

/**
 * Сценарий поправки к платежу.
 */
union InvoicePaymentAdjustmentScenario {
    1: domain.InvoicePaymentAdjustmentCashFlow cash_flow
    2: domain.InvoicePaymentAdjustmentStatusChange status_change
}

/* Сценарий, проверяющий состояние упавшей машины и, в случае если
   платеж упал раньше похода к провайдеру, начинает процедуру корректного
   завершения, используя заданную ошибку*/

struct InvoiceRepairFailPreProcessing {
    1:  required domain.Failure failure
}

/* Сценарий, позволяющий пропустить испекцию платежа, подменив ее результат заданым. */

struct InvoiceRepairSkipInspector {
    1:  required domain.RiskScore risk_score
}

/* Сценарий, использующий заданную ошибку, чтобы сконструировать результат похода к адаптеру */

struct InvoiceRepairFailSession {
    1:  required domain.Failure failure
}

/* Комбинированная структура */

struct InvoiceRepairComplex {
    1:  required list<InvoiceRepairScenario> scenarios
}

union InvoiceRepairScenario{
    1: InvoiceRepairComplex complex
    2: InvoiceRepairFailPreProcessing fail_pre_processing
    3: InvoiceRepairSkipInspector skip_inspector
    4: InvoiceRepairFailSession fail_session
}

/* Параметры adhoc починки упавшей машины. */
struct InvoiceRepairParams {
    1: optional bool validate_transitions = true
}

// Exceptions

// forward-declared
exception PartyNotFound {}
exception PartyNotExistsYet {}
exception InvalidPartyRevision {}

exception ShopNotFound {}
exception WalletNotFound {}

exception InvalidPartyStatus { 1: required InvalidStatus status }
exception InvalidShopStatus { 1: required InvalidStatus status }
exception InvalidWalletStatus { 1: required InvalidStatus status }
exception InvalidContractStatus { 1: required domain.ContractStatus status }

union InvalidStatus {
    1: domain.Blocking blocking
    2: domain.Suspension suspension
}

exception InvalidUser {}
exception InvoiceNotFound {}

exception InvoiceAdjustmentNotFound {}
exception InvoiceAdjustmentPending {
    1: required domain.InvoiceAdjustmentID id
}
exception InvoiceAdjustmentStatusUnacceptable {}
exception InvalidInvoiceAdjustmentStatus {
    1: required domain.InvoiceAdjustmentStatus status
}

exception InvoicePaymentNotFound {}
exception InvoicePaymentRefundNotFound {}

exception InvoicePaymentChargebackNotFound {}
exception InvoicePaymentChargebackCannotReopenAfterArbitration {}
exception InvoicePaymentChargebackInvalidStage {
    1: required domain.InvoicePaymentChargebackStage stage
}
exception InvoicePaymentChargebackInvalidStatus {
    1: required domain.InvoicePaymentChargebackStatus status
}

exception InvoicePaymentAdjustmentNotFound {}

exception EventNotFound {}
exception OperationNotPermitted {}
exception PayoutToolNotFound {}
exception InsufficientAccountBalance {}
exception InvalidRecurrentParentPayment {
    1: optional string details
}

exception InvoicePaymentPending {
    1: required domain.InvoicePaymentID id
}

exception InvoicePaymentRefundPending {
    1: required domain.InvoicePaymentRefundID id
}

exception InvoicePaymentAdjustmentPending {
    1: required domain.InvoicePaymentAdjustmentID id
}

exception InvalidInvoiceStatus {
    1: required domain.InvoiceStatus status
}

exception InvalidPaymentStatus {
    1: required domain.InvoicePaymentStatus status
}

exception InvalidPaymentTargetStatus {
    1: required domain.InvoicePaymentStatus status
}

exception InvoiceAlreadyHasStatus {
    1: required domain.InvoiceStatus status
}

exception InvoicePaymentAlreadyHasStatus {
    1: required domain.InvoicePaymentStatus status
}

exception InvalidPaymentAdjustmentStatus {
    1: required domain.InvoicePaymentAdjustmentStatus status
}

exception InvoiceTemplateNotFound {}
exception InvoiceTemplateRemoved {}

struct InvoiceUnpayable {}

union InvoiceTermsViolationReason {
    1: InvoiceUnpayable invoice_unpayable
}

exception InvoiceTermsViolated {
    1: required InvoiceTermsViolationReason reason
}

exception InvoicePaymentAmountExceeded {
    1: required domain.Cash maximum
}

exception InconsistentRefundCurrency {
    1: required domain.CurrencySymbolicCode currency
}

exception InconsistentChargebackCurrency {
    1: required domain.CurrencySymbolicCode currency
}

exception InconsistentCaptureCurrency {
    1: required domain.CurrencySymbolicCode payment_currency
    2: optional domain.CurrencySymbolicCode passed_currency
}

exception AmountExceededCaptureBalance {
    1: required domain.Amount payment_amount
    2: optional domain.Amount passed_amount
}

exception InvoicePaymentChargebackPending {}

service Invoicing {

    Invoice Create (1: UserInfo user, 2: InvoiceParams params)
        throws (
            1: InvalidUser ex1,
            2: base.InvalidRequest ex2,
            3: PartyNotFound ex3,
            4: ShopNotFound ex4,
            5: InvalidPartyStatus ex5,
            6: InvalidShopStatus ex6,
            7: InvalidContractStatus ex7,
            8: InvoiceTermsViolated ex8
        )

    Invoice CreateWithTemplate (1: UserInfo user, 2: InvoiceWithTemplateParams params)
        throws (
            1: InvalidUser ex1,
            2: base.InvalidRequest ex2,
            3: InvalidPartyStatus ex3,
            4: InvalidShopStatus ex4,
            5: InvalidContractStatus ex5
            6: InvoiceTemplateNotFound ex6,
            7: InvoiceTemplateRemoved ex7,
            8: InvoiceTermsViolated ex8
        )

    Invoice Get (1: UserInfo user, 2: domain.InvoiceID id, 3: EventRange range)
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2
        )

    Events GetEvents (1: UserInfo user, 2: domain.InvoiceID id, 3: EventRange range)
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: EventNotFound ex3,
            4: base.InvalidRequest ex4
        )

    InvoiceAdjustment CreateInvoiceAdjustment (
        1: UserInfo user,
        2: domain.InvoiceID id,
        3: InvoiceAdjustmentParams params
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvalidInvoiceStatus ex3,
            4: InvoiceAdjustmentPending ex4,
            5: InvoiceAdjustmentStatusUnacceptable ex5,
            6: InvoiceAlreadyHasStatus ex6,
            7: base.InvalidRequest ex7,
            8: InvoicePaymentPending ex8
        )

    InvoiceAdjustment GetAdjustment (
        1: UserInfo user,
        2: domain.InvoiceID id,
        3: domain.InvoiceAdjustmentID adjustment_id
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvoiceAdjustmentNotFound ex3
        )

    void CaptureAdjustment (
        1: UserInfo user,
        2: domain.InvoiceID id,
        3: domain.InvoiceAdjustmentID adjustment_id
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvoiceAdjustmentNotFound ex3,
            4: InvalidInvoiceAdjustmentStatus ex4
        )

    void CancelAdjustment (
        1: UserInfo user
        2: domain.InvoiceID id,
        3: domain.InvoiceAdjustmentID adjustment_id
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvoiceAdjustmentNotFound ex3,
            4: InvalidInvoiceAdjustmentStatus ex4
        )

    /* Terms */

    domain.TermSet ComputeTerms (
        1: UserInfo user,
        2: domain.InvoiceID id
        3: PartyRevisionParam party_revision_param
    )
        throws (1: InvalidUser ex1, 2: InvoiceNotFound ex2)

    /* Payments */

    InvoicePayment StartPayment (
        1: UserInfo user,
        2: domain.InvoiceID id,
        3: InvoicePaymentParams params
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvalidInvoiceStatus ex3,
            4: InvoicePaymentPending ex4,
            5: base.InvalidRequest ex5,
            6: InvalidPartyStatus ex6,
            7: InvalidShopStatus ex7,
            8: InvalidContractStatus ex8,
            9: InvalidRecurrentParentPayment ex9,
            10: OperationNotPermitted ex10,
            11: InvoiceAdjustmentPending ex11
        )

    InvoicePayment GetPayment (
        1: UserInfo user,
        2: domain.InvoiceID id,
        3: domain.InvoicePaymentID payment_id
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvoicePaymentNotFound ex3
        )

    void CancelPayment (
        1: UserInfo user,
        2: domain.InvoiceID id,
        3: domain.InvoicePaymentID payment_id
        4: string reason
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvoicePaymentNotFound ex3,
            4: InvalidPaymentStatus ex4,
            5: base.InvalidRequest ex5,
            6: OperationNotPermitted ex6,
            7: InvalidPartyStatus ex7,
            8: InvalidShopStatus ex8
        )

    void CapturePayment (
        1: UserInfo user,
        2: domain.InvoiceID id,
        3: domain.InvoicePaymentID payment_id
        4: InvoicePaymentCaptureParams params
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvoicePaymentNotFound ex3,
            4: InvalidPaymentStatus ex4,
            5: base.InvalidRequest ex5,
            6: OperationNotPermitted ex6,
            7: InvalidPartyStatus ex7,
            8: InvalidShopStatus ex8,
            9: InconsistentCaptureCurrency ex9,
            10: AmountExceededCaptureBalance ex10
        )

    void CapturePaymentNew (
        1: UserInfo user,
        2: domain.InvoiceID id,
        3: domain.InvoicePaymentID payment_id
        4: InvoicePaymentCaptureParams params
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvoicePaymentNotFound ex3,
            4: InvalidPaymentStatus ex4,
            5: base.InvalidRequest ex5,
            6: OperationNotPermitted ex6,
            7: InvalidPartyStatus ex7,
            8: InvalidShopStatus ex8,
            9: InconsistentCaptureCurrency ex9,
            10: AmountExceededCaptureBalance ex10
        )
    /**
     * Создать поправку к платежу.
     *
     * После создания поправку необходимо либо подтвердить, если её эффекты
     * соответствуют ожиданиям, либо отклонить в противном случае (по аналогии с
     * заявками).
     * Пока созданная поправка ни подтверждена, ни отклонена, другую поправку
     * создать невозможно.
     */
    InvoicePaymentAdjustment CreatePaymentAdjustment (
        1: UserInfo user,
        2: domain.InvoiceID id,
        3: domain.InvoicePaymentID payment_id,
        4: InvoicePaymentAdjustmentParams params
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvoicePaymentNotFound ex3,
            4: InvalidPaymentStatus ex4,
            5: InvoicePaymentAdjustmentPending ex5
            6: InvalidPaymentTargetStatus ex6
            7: InvoicePaymentAlreadyHasStatus ex7
            8: base.InvalidRequest ex8
        )

    InvoicePaymentAdjustment GetPaymentAdjustment (
        1: UserInfo user,
        2: domain.InvoiceID id,
        3: domain.InvoicePaymentID payment_id
        4: domain.InvoicePaymentAdjustmentID adjustment_id
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvoicePaymentNotFound ex3,
            4: InvoicePaymentAdjustmentNotFound ex4
        )

    void CapturePaymentAdjustment (
        1: UserInfo user,
        2: domain.InvoiceID id,
        3: domain.InvoicePaymentID payment_id
        4: domain.InvoicePaymentAdjustmentID adjustment_id
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvoicePaymentNotFound ex3,
            4: InvoicePaymentAdjustmentNotFound ex4,
            5: InvalidPaymentAdjustmentStatus ex5
        )

    void CancelPaymentAdjustment (
        1: UserInfo user
        2: domain.InvoiceID id,
        3: domain.InvoicePaymentID payment_id
        4: domain.InvoicePaymentAdjustmentID adjustment_id
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvoicePaymentNotFound ex3,
            4: InvoicePaymentAdjustmentNotFound ex4,
            5: InvalidPaymentAdjustmentStatus ex5
        )

    /**
     * Создать чарджбэк
     */
    domain.InvoicePaymentChargeback CreateChargeback (
        1: UserInfo user
        2: domain.InvoiceID id,
        3: domain.InvoicePaymentID payment_id
        4: InvoicePaymentChargebackParams params
    )
        throws (
            1:  InvalidUser ex1,
            2:  InvoiceNotFound ex2,
            3:  InvoicePaymentNotFound ex3,
            4:  InvalidPaymentStatus ex4,
            6:  OperationNotPermitted ex6,
            7:  InsufficientAccountBalance ex7,
            8:  InvoicePaymentAmountExceeded ex8
            9:  InconsistentChargebackCurrency ex9,
            11: InvoicePaymentChargebackInvalidStatus ex11
            12: InvalidContractStatus ex12
            14: InvoicePaymentChargebackPending ex14
            /* something else? */
        )

    /**
     * Найти чарджбэк
     */
    domain.InvoicePaymentChargeback GetPaymentChargeback (
        1: UserInfo user
        2: domain.InvoiceID id,
        3: domain.InvoicePaymentID payment_id
        4: domain.InvoicePaymentChargebackID chargeback_id
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvoicePaymentNotFound ex3,
            4: InvoicePaymentChargebackNotFound ex4
        )

    /**
     * Принять чарджбэк
     */
    void AcceptChargeback (
        1: UserInfo user
        2: domain.InvoiceID id,
        3: domain.InvoicePaymentID payment_id
        4: domain.InvoicePaymentChargebackID chargeback_id
        5: InvoicePaymentChargebackAcceptParams params
    )
        throws (
            1:  InvalidUser ex1,
            2:  InvoiceNotFound ex2,
            3:  InvoicePaymentNotFound ex3,
            4:  InvoicePaymentChargebackNotFound ex4
            6:  OperationNotPermitted ex6,
            8:  InvoicePaymentAmountExceeded ex8
            9:  InconsistentChargebackCurrency ex9,
            11: InvoicePaymentChargebackInvalidStatus ex11
            12: InvalidContractStatus ex12
        )

    /**
     * Отклонить чарджбэк
     */
    void RejectChargeback (
        1: UserInfo user
        2: domain.InvoiceID id
        3: domain.InvoicePaymentID payment_id
        4: domain.InvoicePaymentChargebackID chargeback_id
        5: InvoicePaymentChargebackRejectParams params
    )
        throws (
            1:  InvalidUser ex1,
            2:  InvoiceNotFound ex2,
            3:  InvoicePaymentNotFound ex3,
            4:  InvoicePaymentChargebackNotFound ex4
            6:  OperationNotPermitted ex6,
            9:  InconsistentChargebackCurrency ex9,
            11: InvoicePaymentChargebackInvalidStatus ex11
            12: InvalidContractStatus ex12
        )

    /**
     * Открыть чарджбэк заново. Переход возможен из отклонённого состояния,
     * если покупатель не согласен с результатом и хочет его оспорить.
     */
    void ReopenChargeback (
        1: UserInfo user
        2: domain.InvoiceID id
        3: domain.InvoicePaymentID payment_id
        4: domain.InvoicePaymentChargebackID chargeback_id
        5: InvoicePaymentChargebackReopenParams params
    )
        throws (
            1:  InvalidUser ex1
            2:  InvoiceNotFound ex2
            3:  InvoicePaymentNotFound ex3
            4:  InvoicePaymentChargebackNotFound ex4
            6:  OperationNotPermitted ex6
            8:  InvoicePaymentAmountExceeded ex8
            9:  InconsistentChargebackCurrency ex9,
            11: InvoicePaymentChargebackInvalidStatus ex11
            12: InvalidContractStatus ex12
            13: InvoicePaymentChargebackCannotReopenAfterArbitration ex13
            14: InvoicePaymentChargebackInvalidStage ex14
        )

    /**
     * Отмена чарджбэка. Комиссия с мерчанта не взимается.
     */
    void CancelChargeback (
        1: UserInfo user
        2: domain.InvoiceID id
        3: domain.InvoicePaymentID payment_id
        4: domain.InvoicePaymentChargebackID chargeback_id
        5: InvoicePaymentChargebackCancelParams params
    )
        throws (
            1:  InvalidUser ex1
            2:  InvoiceNotFound ex2
            3:  InvoicePaymentNotFound ex3
            4:  InvoicePaymentChargebackNotFound ex4
            11: InvoicePaymentChargebackInvalidStatus ex11
            15: InvoicePaymentChargebackInvalidStage ex15
        )

    /**
     * Сделать возврат платежа.
     */
    domain.InvoicePaymentRefund RefundPayment (
        1: UserInfo user
        2: domain.InvoiceID id,
        3: domain.InvoicePaymentID payment_id
        4: InvoicePaymentRefundParams params
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvoicePaymentNotFound ex3,
            4: InvalidPaymentStatus ex4,
            6: OperationNotPermitted ex6,
            7: InsufficientAccountBalance ex7,
            8: base.InvalidRequest ex8
            9: InvoicePaymentAmountExceeded ex9
            10: InconsistentRefundCurrency ex10
            11: InvalidPartyStatus ex11
            12: InvalidShopStatus ex12
            13: InvalidContractStatus ex13
            14: InvoicePaymentChargebackPending ex14
        )


    /**
     * Сделать ручной возврат.
     */
    domain.InvoicePaymentRefund CreateManualRefund (
        1: UserInfo user
        2: domain.InvoiceID id,
        3: domain.InvoicePaymentID payment_id
        4: InvoicePaymentRefundParams params
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvoicePaymentNotFound ex3,
            4: InvalidPaymentStatus ex4,
            6: OperationNotPermitted ex6,
            7: InsufficientAccountBalance ex7,
            8: InvoicePaymentAmountExceeded ex8
            9: InconsistentRefundCurrency ex9
            10: InvalidPartyStatus ex10
            11: InvalidShopStatus ex11
            12: InvalidContractStatus ex12
            13: base.InvalidRequest ex13
            14: InvoicePaymentChargebackPending ex14
        )

    domain.InvoicePaymentRefund GetPaymentRefund (
        1: UserInfo user
        2: domain.InvoiceID id,
        3: domain.InvoicePaymentID payment_id
        4: domain.InvoicePaymentRefundID refund_id
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvoicePaymentNotFound ex3,
            4: InvoicePaymentRefundNotFound ex4
        )

    void Fulfill (1: UserInfo user, 2: domain.InvoiceID id, 3: string reason)
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvalidInvoiceStatus ex3,
            4: InvalidPartyStatus ex4,
            5: InvalidShopStatus ex5,
            6: InvalidContractStatus ex6
        )

    void Rescind (1: UserInfo user, 2: domain.InvoiceID id, 3: string reason)
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: InvalidInvoiceStatus ex3,
            4: InvoicePaymentPending ex4,
            5: InvalidPartyStatus ex5,
            6: InvalidShopStatus ex6,
            7: InvalidContractStatus ex7
        )

    /* Ad-hoc repairs */

    void Repair (
        1: UserInfo user,
        2: domain.InvoiceID id,
        3: list<InvoiceChange> changes,
        4: repairing.ComplexAction action,
        5: InvoiceRepairParams params
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: base.InvalidRequest ex3
        )

    /* Invoice payments repairs */

    void RepairWithScenario (1: UserInfo user, 2: domain.InvoiceID id, 3: InvoiceRepairScenario Scenario)
        throws (
            1: InvalidUser ex1,
            2: InvoiceNotFound ex2,
            3: base.InvalidRequest ex3
        )
}

service InvoiceTemplating {

    domain.InvoiceTemplate Create (1: UserInfo user, 2: InvoiceTemplateCreateParams params)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: InvalidPartyStatus ex3,
            4: ShopNotFound ex4,
            5: InvalidShopStatus ex5,
            6: base.InvalidRequest ex6
        )

    domain.InvoiceTemplate Get (1: UserInfo user, 2: domain.InvoiceTemplateID id)
        throws (
            1: InvalidUser ex1,
            2: InvoiceTemplateNotFound ex2,
            3: InvoiceTemplateRemoved ex3
        )

    domain.InvoiceTemplate Update (1: UserInfo user, 2: domain.InvoiceTemplateID id, 3: InvoiceTemplateUpdateParams params)
        throws (
            1: InvalidUser ex1,
            2: InvoiceTemplateNotFound ex2,
            3: InvoiceTemplateRemoved ex3,
            4: InvalidPartyStatus ex4,
            5: InvalidShopStatus ex5,
            6: base.InvalidRequest ex6
        )

    void Delete (1: UserInfo user, 2: domain.InvoiceTemplateID id)
        throws (
            1: InvalidUser ex1,
            2: InvoiceTemplateNotFound ex2,
            3: InvoiceTemplateRemoved ex3,
            4: InvalidPartyStatus ex4,
            5: InvalidShopStatus ex5
        )

    /* Terms */

    domain.TermSet ComputeTerms (
        1: UserInfo user,
        2: domain.InvoiceTemplateID id,
        3: base.Timestamp timestamp,
        4: PartyRevisionParam party_revision_param
    )
        throws (
            1: InvalidUser ex1,
            2: InvoiceTemplateNotFound ex2,
            3: InvoiceTemplateRemoved ex3,
            4: PartyNotExistsYet ex4
        )
}

/* Customer management service definitions */

/* Customers */

typedef domain.CustomerID CustomerID
typedef domain.Metadata   Metadata

struct CustomerParams {
    1: required PartyID            party_id
    2: required ShopID             shop_id
    3: required domain.ContactInfo contact_info
    4: required Metadata           metadata
}

struct Customer {
    1: required CustomerID            id
    2: required PartyID               owner_id
    3: required ShopID                shop_id
    4: required CustomerStatus        status
    5: required base.Timestamp        created_at
    6: required list<CustomerBinding> bindings
    7: required domain.ContactInfo    contact_info
    8: required Metadata              metadata
    9: optional CustomerBindingID     active_binding_id
}

/**
 * Статусы плательщика
 *
 * Статус отражает возможость проводить платежи с помощью данного плательщика,
 * то есть существует ли (и она сейчас активна) у него привязка, завершившаяся успешно
 */
union CustomerStatus {
    1: CustomerUnready unready
    2: CustomerReady   ready
}

struct CustomerUnready {}
struct CustomerReady   {}

// События
union CustomerChange {
    1: CustomerCreated        customer_created
    2: CustomerDeleted        customer_deleted
    3: CustomerStatusChanged  customer_status_changed
    4: CustomerBindingChanged customer_binding_changed
}

/**
 * Событие о создании нового плательщика.
 */
struct CustomerCreated {
    2: required CustomerID         customer_id
    3: required PartyID            owner_id
    4: required ShopID             shop_id
    5: required Metadata           metadata
    6: required domain.ContactInfo contact_info
    7: required base.Timestamp     created_at
}

/**
 * Событие об удалении плательщика.
 */
struct CustomerDeleted {}

/**
 * Событие об изменении статуса плательщика.
 */
struct CustomerStatusChanged {
    1: required CustomerStatus status
}

/**
 * Событие, касающееся определённой привязки плательщика.
 */
struct CustomerBindingChanged {
    1: required CustomerBindingID            id
    2: required CustomerBindingChangePayload payload
}


/* Bindings */

typedef domain.CustomerBindingID CustomerBindingID
typedef domain.DisposablePaymentResource DisposablePaymentResource

struct CustomerBindingParams {
    1: required DisposablePaymentResource payment_resource
}

struct CustomerBinding {
    1: required CustomerBindingID         id
    2: required RecurrentPaymentToolID    rec_payment_tool_id
    3: required DisposablePaymentResource payment_resource
    4: required CustomerBindingStatus     status
    5: optional PartyRevision             party_revision
    6: optional domain.DataRevision       domain_revision
}

// Statuses
union CustomerBindingStatus {
    1: CustomerBindingPending   pending
    2: CustomerBindingSucceeded succeeded
    3: CustomerBindingFailed    failed
}

/**
 * Привязка находится в процессе обработки
 */
struct CustomerBindingPending   {}

/**
 * Привязка завершилась успешно
 */
struct CustomerBindingSucceeded {}

/**
 * Привязка завершилась неудачно
 */
struct CustomerBindingFailed    { 1: required domain.OperationFailure failure }

// Events
union CustomerBindingChangePayload {
    1: CustomerBindingStarted started
    2: CustomerBindingStatusChanged status_changed
    3: CustomerBindingInteractionRequested interaction_requested
}

/**
 * Событие о старте процесса привязки
 */
struct CustomerBindingStarted {
    1: required CustomerBinding binding
    2: optional base.Timestamp  timestamp
}

/**
 * Событие об изменении статуса привязки
 */
struct CustomerBindingStatusChanged {
    1: required CustomerBindingStatus status
}

struct CustomerBindingInteractionRequested {
    1: required user_interaction.UserInteraction interaction
}

// Exceptions
exception InvalidCustomerStatus {
    1: required CustomerStatus status
}
exception CustomerNotFound   {}
exception InvalidPaymentTool {}

// Service

service CustomerManagement {

    Customer Create (1: CustomerParams params)
        throws (
            1: InvalidUser           invalid_user
            2: InvalidPartyStatus    invalid_party_status
            3: InvalidShopStatus     invalid_shop_status
            4: ShopNotFound          shop_not_found
            5: PartyNotFound         party_not_found
            6: OperationNotPermitted operation_not_permitted
        )

    Customer Get (1: CustomerID id, 2: EventRange range)
        throws (
            1: InvalidUser      invalid_user
            2: CustomerNotFound not_found
        )

    void Delete (1: CustomerID id)
        throws (
            1: InvalidUser           invalid_user
            2: CustomerNotFound      not_found
            3: InvalidPartyStatus    invalid_party_status
            4: InvalidShopStatus     invalid_shop_status
        )

    CustomerBinding StartBinding (1: CustomerID customer_id, 2: CustomerBindingParams params)
        throws (
            1: InvalidUser           invalid_user
            2: CustomerNotFound      customer_not_found
            3: InvalidPartyStatus    invalid_party_status
            4: InvalidShopStatus     invalid_shop_status
            5: InvalidContractStatus invalid_contract_status
            6: OperationNotPermitted operation_not_permitted
        )

    CustomerBinding GetActiveBinding (1: CustomerID customer_id)
        throws (
            1: InvalidUser           invalid_user
            2: CustomerNotFound      customer_not_found
            3: InvalidCustomerStatus invalid_customer_status
        )

    Events GetEvents (1: CustomerID customer_id, 2: EventRange range)
        throws (
            1: InvalidUser      invalid_user
            2: CustomerNotFound customer_not_found
            3: EventNotFound    event_not_found
        )
}

/* Recurrent Payment Tool */

// Types
typedef domain.RecurrentPaymentToolID RecurrentPaymentToolID

// Model
struct RecurrentPaymentTool {
    1:  required RecurrentPaymentToolID     id
    2:  required ShopID                     shop_id
    3:  required PartyID                    party_id
    11: optional PartyRevision              party_revision
    4:  required domain.DataRevision        domain_revision
    6:  required RecurrentPaymentToolStatus status
    7:  required base.Timestamp             created_at
    8:  required DisposablePaymentResource  payment_resource
    9:  optional domain.Token               rec_token
    10: optional domain.PaymentRoute        route
    12: optional domain.Cash                minimal_payment_cost
}

struct RecurrentPaymentToolParams {
    5: optional RecurrentPaymentToolID    id
    1: required PartyID                   party_id
    4: optional PartyRevision             party_revision
    6: optional domain.DataRevision       domain_revision
    2: required ShopID                    shop_id
    3: required DisposablePaymentResource payment_resource
}

// Statuses
struct RecurrentPaymentToolCreated   {}
struct RecurrentPaymentToolAcquired  {}
struct RecurrentPaymentToolAbandoned {}
struct RecurrentPaymentToolFailed    { 1: required domain.OperationFailure failure }

union RecurrentPaymentToolStatus {
    1: RecurrentPaymentToolCreated   created
    2: RecurrentPaymentToolAcquired  acquired
    3: RecurrentPaymentToolAbandoned abandoned
    4: RecurrentPaymentToolFailed    failed
}

// Events
typedef list<RecurrentPaymentToolEvent> RecurrentPaymentToolEvents

/*
 * События, связанные непосредственно с получением рекуррентных токенов
 */

struct RecurrentPaymentToolEventData {
    1: required list<RecurrentPaymentToolChange> changes
}

struct RecurrentPaymentToolEvent {
    1: required base.EventID                     id
    2: required base.Timestamp                   created_at
    3: required RecurrentPaymentToolID           source
    5: optional base.SequenceID                  sequence
    4: required list<RecurrentPaymentToolChange> payload
}

struct RecurrentPaymentToolSessionChange {
    1: required SessionChangePayload payload
}

union RecurrentPaymentToolChange {
    1: RecurrentPaymentToolHasCreated       rec_payment_tool_created
    6: RecurrentPaymentToolRiskScoreChanged rec_payment_tool_risk_score_changed
    7: RecurrentPaymentToolRouteChanged     rec_payment_tool_route_changed
    2: RecurrentPaymentToolHasAcquired      rec_payment_tool_acquired
    3: RecurrentPaymentToolHasAbandoned     rec_payment_tool_abandoned
    4: RecurrentPaymentToolHasFailed        rec_payment_tool_failed
    5: RecurrentPaymentToolSessionChange    rec_payment_tool_session_changed
}

/*
 * Создано рекуррентное платежное средство
 */
struct RecurrentPaymentToolHasCreated {
    1: required RecurrentPaymentTool rec_payment_tool
    /** deprecated */
    /** Оценка риска платежного средства. */
    2: optional domain.RiskScore     risk_score
    /** Выбранный маршрут обработки платежного средства. */
    3: optional domain.PaymentRoute  route
}

/**
 * Событие об изменении оценки риска платежного средства.
 */
struct RecurrentPaymentToolRiskScoreChanged {
    /** Оценка риска платежного средства. */
    1: required domain.RiskScore risk_score
}

/**
 * Событие об изменении маршрута обработки платежного средства.
 */
struct RecurrentPaymentToolRouteChanged {
    /** Выбранный маршрут обработки платежного средства. */
    1: required domain.PaymentRoute route
}

/*
 * Получен рекуррентный токен => теперь этим платежным средством можно платить
 */
struct RecurrentPaymentToolHasAcquired {
    1: required domain.Token token
}

/*
 * Рекуррентное платежное средство отозвано
 */
struct RecurrentPaymentToolHasAbandoned {}

/*
 * В процессе получения рекуррентного платежного средства произошла ошибка
 */
struct RecurrentPaymentToolHasFailed {
    1: required domain.OperationFailure failure
}


// Exceptions
exception InvalidBinding                    {}
exception BindingNotFound                   {}
exception RecurrentPaymentToolNotFound      {}
exception InvalidPaymentMethod              {}
exception InvalidRecurrentPaymentToolStatus {
    1: required RecurrentPaymentToolStatus status
}

service RecurrentPaymentTools {
    RecurrentPaymentTool Create (1: RecurrentPaymentToolParams params)
        throws (
            1: InvalidUser           invalid_user
            2: InvalidPartyStatus    invalid_party_status
            3: InvalidShopStatus     invalid_shop_status
            4: ShopNotFound          shop_not_found
            5: PartyNotFound         party_not_found
            6: InvalidContractStatus invalid_contract_status
            7: OperationNotPermitted operation_not_permitted
            8: InvalidPaymentMethod  invalid_payment_method
        )

    RecurrentPaymentTool Abandon (1: RecurrentPaymentToolID id)
        throws (
            1: InvalidUser                       invalid_user
            2: RecurrentPaymentToolNotFound      rec_payment_tool_not_found
            3: InvalidRecurrentPaymentToolStatus invalid_rec_payment_tool_status
        )

    RecurrentPaymentTool Get (1: RecurrentPaymentToolID id)
        throws (
            1: InvalidUser                  invalid_user
            2: RecurrentPaymentToolNotFound rec_payment_tool_not_found
        )

    RecurrentPaymentToolEvents GetEvents (1: RecurrentPaymentToolID id, 2: EventRange range)
        throws (
            1: InvalidUser                  invalid_user
            2: RecurrentPaymentToolNotFound rec_payment_tool_not_found
            3: EventNotFound                event_not_found
        )
}

exception NoLastEvent {}

service RecurrentPaymentToolEventSink {
    RecurrentPaymentToolEvents GetEvents (1: EventRange range)
        throws (1: EventNotFound ex1, 2: base.InvalidRequest ex2)

    base.EventID GetLastEventID ()
        throws (1: NoLastEvent ex1)
}

/* Party management service definitions */

// Types

typedef domain.PartyID PartyID
typedef domain.PartyRevision PartyRevision
typedef domain.ShopID  ShopID
typedef domain.ContractID  ContractID
typedef domain.ContractorID ContractorID
typedef domain.PayoutToolID PayoutToolID
typedef domain.WalletID WalletID
typedef domain.ContractTemplateRef ContractTemplateRef
typedef domain.PaymentInstitutionRef PaymentInstitutionRef

struct Varset {
    1: optional domain.CategoryRef category
    2: optional domain.CurrencyRef currency
    3: optional domain.Cash amount
    4: optional domain.PaymentMethodRef payment_method
    5: optional domain.PayoutMethodRef payout_method
    6: optional domain.WalletID wallet_id
    7: optional domain.P2PTool p2p_tool
    8: optional domain.ShopID shop_id
    9: optional domain.ContractorIdentificationLevel identification_level
    10: optional domain.PaymentTool payment_tool
    11: optional domain.PartyID party_id
}

struct PartyParams {
    1: required domain.PartyContactInfo contact_info
}

struct PayoutToolParams {
    1: required domain.CurrencyRef currency
    2: required domain.PayoutToolInfo tool_info
}

struct ShopParams {
    1: optional domain.CategoryRef category
    6: required domain.ShopLocation location
    2: required domain.ShopDetails details
    3: required ContractID contract_id
    4: required domain.PayoutToolID payout_tool_id
}

struct ShopAccountParams {
    1: required domain.CurrencyRef currency
}

struct ContractParams {
    4: optional ContractorID contractor_id
    2: optional ContractTemplateRef template
    3: optional PaymentInstitutionRef payment_institution

    // depricated
    1: optional domain.Contractor contractor
}

struct ContractAdjustmentParams {
    1: required ContractTemplateRef template
}

union PartyModification {
    8: ContractorModificationUnit contractor_modification
    4: ContractModificationUnit contract_modification
    6: ShopModificationUnit shop_modification
    7: WalletModificationUnit wallet_modification
}

struct ContractorModificationUnit {
    1: required ContractorID id
    2: required ContractorModification modification
}

union ContractorModification {
    1: domain.Contractor creation
    2: domain.ContractorIdentificationLevel identification_level_modification
    3: ContractorIdentityDocumentsModification identity_documents_modification
}

struct ContractorIdentityDocumentsModification {
    1: required list<domain.IdentityDocumentToken> identity_documents
}

struct ContractModificationUnit {
    1: required ContractID id
    2: required ContractModification modification
}

union ContractModification {
    1: ContractParams creation
    2: ContractTermination termination
    3: ContractAdjustmentModificationUnit adjustment_modification
    4: PayoutToolModificationUnit payout_tool_modification
    5: domain.LegalAgreement legal_agreement_binding
    6: domain.ReportPreferences report_preferences_modification
    7: ContractorID contractor_modification
}

struct ContractTermination {
    2: optional string reason
}

struct ContractAdjustmentModificationUnit {
    1: required domain.ContractAdjustmentID adjustment_id
    2: required ContractAdjustmentModification modification
}

union ContractAdjustmentModification {
    1: ContractAdjustmentParams creation
}

struct PayoutToolModificationUnit {
    1: required domain.PayoutToolID payout_tool_id
    2: required PayoutToolModification modification
}

union PayoutToolModification {
    1: PayoutToolParams creation
    2: domain.PayoutToolInfo info_modification
}

typedef list<PartyModification> PartyChangeset

struct ShopModificationUnit {
    1: required ShopID id
    2: required ShopModification modification
}

union ShopModification {
    5: ShopParams creation
    6: domain.CategoryRef category_modification
    7: domain.ShopDetails details_modification
    8: ShopContractModification contract_modification
    9: domain.PayoutToolID payout_tool_modification
    11: domain.ShopLocation location_modification
    12: ShopAccountParams shop_account_creation
    13: ScheduleModification payout_schedule_modification

    /* deprecated */
    10: ProxyModification proxy_modification
}

struct ShopContractModification {
    1: required ContractID contract_id
    2: required domain.PayoutToolID payout_tool_id
}

struct ScheduleModification {
    1: optional domain.BusinessScheduleRef schedule
}

/* deprecated */
struct ProxyModification {
    1: optional domain.Proxy proxy
}

struct WalletModificationUnit {
    1: required WalletID id
    2: required WalletModification modification
}

union WalletModification {
    1: WalletParams creation
    2: WalletAccountParams account_creation
}

struct WalletParams {
    1: optional string name
    2: required ContractID contract_id
}

struct WalletAccountParams {
    1: required domain.CurrencyRef currency
}

// Claims

typedef i64 ClaimID
typedef i32 ClaimRevision

struct Claim {
    1: required ClaimID id
    2: required ClaimStatus status
    3: required PartyChangeset changeset
    4: required ClaimRevision revision
    5: required base.Timestamp created_at
    6: optional base.Timestamp updated_at
}

union ClaimStatus {
    1: ClaimPending pending
    2: ClaimAccepted accepted
    3: ClaimDenied denied
    4: ClaimRevoked revoked
}

struct ClaimPending {}

struct ClaimAccepted {
    2: optional ClaimEffects effects
}

struct ClaimDenied {
    1: optional string reason
}

struct ClaimRevoked {
    1: optional string reason
}

// Claim effects

typedef list<ClaimEffect> ClaimEffects

union ClaimEffect {
    /* 1: PartyEffect Reserved for future */
    2: ContractEffectUnit contract_effect
    3: ShopEffectUnit shop_effect
    4: ContractorEffectUnit contractor_effect
    5: WalletEffectUnit wallet_effect
}

struct ContractEffectUnit {
    1: required ContractID contract_id
    2: required ContractEffect effect
}

union ContractEffect {
    1: domain.Contract created
    2: domain.ContractStatus status_changed
    3: domain.ContractAdjustment adjustment_created
    4: domain.PayoutTool payout_tool_created
    8: PayoutToolInfoChanged payout_tool_info_changed
    5: domain.LegalAgreement legal_agreement_bound
    6: domain.ReportPreferences report_preferences_changed
    7: ContractorID contractor_changed
}

struct ShopEffectUnit {
    1: required ShopID shop_id
    2: required ShopEffect effect
}

union ShopEffect {
    1: domain.Shop created
    2: domain.CategoryRef category_changed
    3: domain.ShopDetails details_changed
    4: ShopContractChanged contract_changed
    5: domain.PayoutToolID payout_tool_changed
    7: domain.ShopLocation location_changed
    8: domain.ShopAccount account_created
    9: ScheduleChanged payout_schedule_changed

    /* deprecated */
    6: ShopProxyChanged proxy_changed
}

struct ShopContractChanged {
    1: required ContractID contract_id
    2: required domain.PayoutToolID payout_tool_id
}

struct ScheduleChanged {
    1: optional domain.BusinessScheduleRef schedule
}

struct ContractorEffectUnit {
    1: required ContractorID id
    2: required ContractorEffect effect
}

union ContractorEffect {
    1: domain.PartyContractor created
    2: domain.ContractorIdentificationLevel identification_level_changed
    3: ContractorIdentityDocumentsChanged identity_documents_changed
}

struct ContractorIdentityDocumentsChanged {
    1: required list<domain.IdentityDocumentToken> identity_documents
}

struct PayoutToolInfoChanged {
    1: required domain.PayoutToolID payout_tool_id
    2: required domain.PayoutToolInfo info
}

struct WalletEffectUnit {
    1: required WalletID id
    2: required WalletEffect effect
}

union WalletEffect {
    1: domain.Wallet created
    2: domain.WalletAccount account_created
}

/* deprecated */
struct ShopProxyChanged {
    1: optional domain.Proxy proxy
}

struct AccountState {
    1: required domain.AccountID account_id
    2: required domain.Amount own_amount
    3: required domain.Amount available_amount
    4: required domain.Currency currency
}

// Events
struct PartyEventData {
    1: required list<PartyChange> changes
    2: optional msgpack.Value state_snapshot
}

// changes, marked by '#' may affect Party state and may produce PartyRevisionChanged change as well
union PartyChange {
    1: PartyCreated         party_created           // #
    4: domain.Blocking      party_blocking          // #
    5: domain.Suspension    party_suspension        // #
    6: ShopBlocking         shop_blocking           // #
    7: ShopSuspension       shop_suspension         // #
    12: WalletBlocking      wallet_blocking         // #
    13: WalletSuspension    wallet_suspension       // #
    2: Claim                claim_created
    3: ClaimStatusChanged   claim_status_changed    // #
    8: ClaimUpdated         claim_updated
    9: PartyMetaSet         party_meta_set
    10: domain.PartyMetaNamespace party_meta_removed
    11: PartyRevisionChanged revision_changed
}

struct PartyCreated {
    1: required PartyID id
    7: required domain.PartyContactInfo contact_info
    8: required base.Timestamp created_at
}

struct ShopBlocking {
    1: required ShopID shop_id
    2: required domain.Blocking blocking
}

struct ShopSuspension {
    1: required ShopID shop_id
    2: required domain.Suspension suspension
}

struct WalletBlocking {
    1: required WalletID wallet_id
    2: required domain.Blocking blocking
}

struct WalletSuspension {
    1: required WalletID wallet_id
    2: required domain.Suspension suspension
}

struct ClaimStatusChanged {
    1: required ClaimID id
    2: required ClaimStatus status
    3: required ClaimRevision revision
    4: required base.Timestamp changed_at
}

struct ClaimUpdated {
    1: required ClaimID id
    2: required PartyChangeset changeset
    3: required ClaimRevision revision
    4: required base.Timestamp updated_at
}

struct PartyMetaSet {
    1: required domain.PartyMetaNamespace ns
    2: required domain.PartyMetaData data
}

struct PartyRevisionChanged {
    1: required base.Timestamp timestamp
    2: required domain.PartyRevision revision
}

union PartyRevisionParam {
    1: base.Timestamp timestamp
    2: domain.PartyRevision revision
}

struct PayoutParams {
    1: required ShopID id
    2: required domain.Cash amount
    3: required base.Timestamp timestamp
    4: optional domain.PayoutToolID payout_tool_id
}

// Exceptions

exception PartyExists {}
exception ContractNotFound {}
exception ClaimNotFound {}
exception InvalidClaimRevision {}

exception InvalidClaimStatus {
    1: required ClaimStatus status
}

exception ChangesetConflict { 1: required ClaimID conflicted_id }
exception InvalidChangeset { 1: required InvalidChangesetReason reason }

union InvalidChangesetReason {
    1: InvalidContract invalid_contract
    2: InvalidShop invalid_shop
    3: InvalidWallet invalid_wallet
    4: InvalidContractor invalid_contractor
}

struct InvalidContract {
    1: required ContractID id
    2: required InvalidContractReason reason
}

struct InvalidShop {
    1: required ShopID id
    2: required InvalidShopReason reason
}

struct InvalidWallet {
    1: required WalletID id
    2: required InvalidWalletReason reason
}

struct InvalidContractor {
    1: required ContractorID id
    2: required InvalidContractorReason reason
}

union InvalidContractReason {
    1: ContractID not_exists
    2: ContractID already_exists
    3: domain.ContractStatus invalid_status
    4: domain.ContractAdjustmentID contract_adjustment_already_exists
    5: domain.PayoutToolID payout_tool_not_exists
    6: domain.PayoutToolID payout_tool_already_exists
    7: InvalidObjectReference invalid_object_reference
    8: ContractorNotExists contractor_not_exists
}

union InvalidShopReason {
    1: ShopID not_exists
    2: ShopID already_exists
    3: ShopID no_account
    4: InvalidStatus invalid_status
    5: ContractTermsViolated contract_terms_violated
    6: ShopPayoutToolInvalid payout_tool_invalid
    7: InvalidObjectReference invalid_object_reference
}

union InvalidWalletReason {
    1: WalletID not_exists
    2: WalletID already_exists
    3: WalletID no_account
    4: InvalidStatus invalid_status
    5: ContractTermsViolated contract_terms_violated
}

union InvalidContractorReason {
    1: ContractorID not_exists
    2: ContractorID already_exists
}

struct ContractorNotExists {
    1: optional ContractorID id
}

struct ContractTermsViolated {
    1: required ContractID contract_id
    2: required domain.TermSet terms
}

struct ShopPayoutToolInvalid {
    1: optional domain.PayoutToolID payout_tool_id
}

struct InvalidObjectReference {
    1: optional domain.Reference ref
}

exception AccountNotFound {}

exception ShopAccountNotFound {}

exception PartyMetaNamespaceNotFound {}

exception PaymentInstitutionNotFound {}

exception ContractTemplateNotFound {}

exception ProviderNotFound {}

exception TerminalNotFound {}

exception GlobalsNotFound {}

exception RuleSetNotFound {}

exception VarsetPartyNotMatch {
    1: required PartyID varset_party_id
    2: required PartyID agrument_party_id
}

// Service

service PartyManagement {

    /* Party */

    void Create (1: UserInfo user, 2: PartyID party_id, 3: PartyParams params)
        throws (1: InvalidUser ex1, 2: PartyExists ex2)

    domain.Party Get (1: UserInfo user, 2: PartyID party_id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2)

    PartyRevision GetRevision (1: UserInfo user, 2: PartyID party_id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2)

    domain.Party Checkout (1: UserInfo user, 2: PartyID party_id, 3: PartyRevisionParam revision)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: InvalidPartyRevision ex3)

    void Suspend (1: UserInfo user, 2: PartyID party_id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: InvalidPartyStatus ex3)

    void Activate (1: UserInfo user, 2: PartyID party_id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: InvalidPartyStatus ex3)

    void Block (1: UserInfo user, 2: PartyID party_id, 3: string reason)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: InvalidPartyStatus ex3)

    void Unblock (1: UserInfo user, 2: PartyID party_id, 3: string reason)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: InvalidPartyStatus ex3)

    /* Party Status */

    domain.PartyStatus GetStatus (1: UserInfo user, 2: PartyID party_id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2)

    /* Party Meta */

    domain.PartyMeta GetMeta (1: UserInfo user, 2: PartyID party_id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2)

    domain.PartyMetaData GetMetaData (1: UserInfo user, 2: PartyID party_id, 3: domain.PartyMetaNamespace ns)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: PartyMetaNamespaceNotFound ex3)

    void SetMetaData (1: UserInfo user, 2: PartyID party_id, 3: domain.PartyMetaNamespace ns, 4: domain.PartyMetaData data)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2)

    void RemoveMetaData (1: UserInfo user, 2: PartyID party_id, 3: domain.PartyMetaNamespace ns)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: PartyMetaNamespaceNotFound ex3)

    /* Contract */

    domain.Contract GetContract (1: UserInfo user, 2: PartyID party_id, 3: ContractID contract_id)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: ContractNotFound ex3
        )

    domain.TermSet ComputeContractTerms (
        1: UserInfo user,
        2: PartyID party_id,
        3: ContractID contract_id,
        4: base.Timestamp timestamp
        5: PartyRevisionParam party_revision
        6: domain.DataRevision domain_revision
        7: Varset varset
    )
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: PartyNotExistsYet ex3
            4: ContractNotFound ex4,
            5: VarsetPartyNotMatch ex5
        )

    /* Shop */

    domain.Shop GetShop (1: UserInfo user, 2: PartyID party_id, 3: ShopID id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: ShopNotFound ex3)

    void SuspendShop (1: UserInfo user, 2: PartyID party_id, 3: ShopID id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: ShopNotFound ex3, 4: InvalidShopStatus ex4)

    void ActivateShop (1: UserInfo user, 2: PartyID party_id, 3: ShopID id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: ShopNotFound ex3, 4: InvalidShopStatus ex4)

    void BlockShop (1: UserInfo user, 2: PartyID party_id, 3: ShopID id, 4: string reason)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: ShopNotFound ex3, 4: InvalidShopStatus ex4)

    void UnblockShop (1: UserInfo user, 2: PartyID party_id, 3: ShopID id, 4: string reason)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: ShopNotFound ex3, 4: InvalidShopStatus ex4)

    domain.TermSet ComputeShopTerms (
        1: UserInfo user,
        2: PartyID party_id,
        3: ShopID id,
        4: base.Timestamp timestamp
        5: PartyRevisionParam party_revision
        6: Varset varset
    )
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: PartyNotExistsYet ex3,
            4: ShopNotFound ex4,
            5: VarsetPartyNotMatch ex5
        )

    /* Wallet */

    // deprecated
    // do not use
    domain.TermSet ComputeWalletTermsNew (
        1: UserInfo user,
        2: PartyID party_id,
        3: ContractID contract_id,
        4: base.Timestamp timestamp
        5: Varset varset
    )
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: PartyNotExistsYet ex3,
            4: VarsetPartyNotMatch ex4
        )

    /* Claim */

    Claim CreateClaim (1: UserInfo user, 2: PartyID party_id, 3: PartyChangeset changeset)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: InvalidPartyStatus ex3,
            4: ChangesetConflict ex4,
            5: InvalidChangeset ex5,
            6: base.InvalidRequest ex6
        )

    Claim GetClaim (1: UserInfo user, 2: PartyID party_id, 3: ClaimID id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: ClaimNotFound ex3)

    list<Claim> GetClaims (1: UserInfo user, 2: PartyID party_id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2)

    void AcceptClaim (1: UserInfo user, 2: PartyID party_id, 3: ClaimID id, 4: ClaimRevision revision)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: ClaimNotFound ex3,
            4: InvalidClaimStatus ex4,
            5: InvalidClaimRevision ex5,
            6: InvalidChangeset ex6
        )

    void UpdateClaim (1: UserInfo user, 2: PartyID party_id, 3: ClaimID id, 4: ClaimRevision revision, 5: PartyChangeset changeset)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: InvalidPartyStatus ex3,
            4: ClaimNotFound ex4,
            5: InvalidClaimStatus ex5,
            6: InvalidClaimRevision ex6,
            7: ChangesetConflict ex7,
            8: InvalidChangeset ex8,
            9: base.InvalidRequest ex9
        )

    void DenyClaim (1: UserInfo user, 2: PartyID party_id, 3: ClaimID id, 4: ClaimRevision revision, 5: string reason)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: ClaimNotFound ex3,
            4: InvalidClaimStatus ex4,
            5: InvalidClaimRevision ex5
        )

    void RevokeClaim (1: UserInfo user, 2: PartyID party_id, 3: ClaimID id, 4: ClaimRevision revision, 5: string reason)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: InvalidPartyStatus ex3,
            4: ClaimNotFound ex4,
            5: InvalidClaimStatus ex5,
            6: InvalidClaimRevision ex6
        )

    /* Event polling */

    Events GetEvents (1: UserInfo user, 2: PartyID party_id, 3: EventRange range)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: EventNotFound ex3,
            4: base.InvalidRequest ex4
        )

    /* Accounts */

    domain.ShopAccount GetShopAccount (1: UserInfo user, 2: PartyID party_id, 3: ShopID shop_id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: ShopNotFound ex3, 4: ShopAccountNotFound ex4)

    AccountState GetAccountState (1: UserInfo user, 2: PartyID party_id, 3: domain.AccountID account_id)
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: AccountNotFound ex3)

    /* Provider */

    domain.Provider ComputeProvider (
        1: UserInfo user,
        2: domain.ProviderRef provider_ref,
        3: domain.DataRevision domain_revision,
        4: Varset varset
    )
        throws (
            1: InvalidUser ex1,
            2: ProviderNotFound ex2
        )

    domain.ProvisionTermSet ComputeProviderTerminalTerms (
        1: UserInfo user,
        2: domain.ProviderRef provider_ref,
        3: domain.TerminalRef terminal_ref,
        4: domain.DataRevision domain_revision,
        5: Varset varset
    )
        throws (
            1: InvalidUser ex1,
            2: ProviderNotFound ex2,
            3: TerminalNotFound ex3
        )

    /* Globals */

    domain.Globals ComputeGlobals (
        1: UserInfo user,
        2: domain.GlobalsRef globals_ref,
        3: domain.DataRevision domain_revision,
        4: Varset varset
    )
        throws (
            1: InvalidUser ex1,
            2: GlobalsNotFound ex2
        )

    /* RuleSet */

    // Deprecated, will be replaced by ComputeRoutingRuleset
    domain.RoutingRuleset ComputePaymentRoutingRuleset (
        1: UserInfo user,
        2: domain.RoutingRulesetRef ruleset_ref,
        3: domain.DataRevision domain_revision,
        4: Varset varset
    )
        throws (
            1: InvalidUser ex1,
            2: RuleSetNotFound ex2
        )

    domain.RoutingRuleset ComputeRoutingRuleset (
        1: UserInfo user,
        2: domain.RoutingRulesetRef ruleset_ref,
        3: domain.DataRevision domain_revision,
        4: Varset varset
    )
        throws (
            1: InvalidUser ex1,
            2: RuleSetNotFound ex2
        )

    /* Payment institutions */

    domain.TermSet ComputePaymentInstitutionTerms (
        1: UserInfo user,
        3: PaymentInstitutionRef ref,
        4: Varset varset
    )
        throws (1: InvalidUser ex1, 2: PartyNotFound ex2, 3: PaymentInstitutionNotFound ex3)

    domain.PaymentInstitution ComputePaymentInstitution (
        1: UserInfo user,
        2: PaymentInstitutionRef ref,
        3: domain.DataRevision domain_revision,
        4: Varset varset
    )
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: PaymentInstitutionNotFound ex3
        )

    /* Payouts */
    /* TODO looks like adhoc. Rework after feedback. Or not. */
    domain.FinalCashFlow ComputePayoutCashFlow (1: UserInfo user, 2: PartyID party_id, 3: PayoutParams params)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: PartyNotExistsYet ex3,
            4: ShopNotFound ex4,
            5: OperationNotPermitted ex5,
            6: PayoutToolNotFound ex6
        )
}

/* Event sink service definitions */

service EventSink {

    /**
     * Получить последовательный набор событий из истории системы, от более
     * ранних к более поздним, из диапазона, заданного `range`. Результат
     * выполнения запроса может содержать от `0` до `range.limit` событий.
     *
     * Если в `range.after` указан идентификатор неизвестного события, то есть
     * события, не наблюдаемого клиентом ранее в известной ему истории,
     * бросится исключение `EventNotFound`.
     */
    Events GetEvents (1: EventRange range)
        throws (1: EventNotFound ex1, 2: base.InvalidRequest ex2)

    /**
     * Получить идентификатор наиболее позднего известного на момент исполнения
     * запроса события.
     */
    base.EventID GetLastEventID ()
        throws (1: NoLastEvent ex1)

}
