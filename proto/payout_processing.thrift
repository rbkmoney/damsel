include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.payout_processing
namespace erlang payout_processing

typedef base.ID PayoutID
typedef list<Event> Events

typedef base.ID UserID

struct UserInfo {
    1: required UserID id
    2: required UserType type
}

/* Временная замена ролям пользователей для разграничения доступа и лога аудита */
union UserType {
    1: InternalUser internal_user
    2: ExternalUser external_user
    3: ServiceUser  service_user
}

struct InternalUser {}
struct ExternalUser {}
struct ServiceUser {}

/**
 * Событие, атомарный фрагмент истории бизнес-объекта, например выплаты
 */
struct Event {

    /**
     * Идентификатор события.
     * Монотонно возрастающее целочисленное значение, таким образом на множестве
     * событий задаётся отношение полного порядка (total order)
     */
    1: required base.EventID id

    /**
     * Время создания события
     */
    2: required base.Timestamp created_at

    /**
     * Идентификатор бизнес-объекта, источника события
     */
    3: required EventSource source

    /**
     * Содержание события, состоящее из списка (возможно пустого)
     * изменений состояния бизнес-объекта, источника события
     */
    4: required EventPayload payload

}

/**
 * Источник события, идентификатор бизнес-объекта, который породил его в
 * процессе выполнения определённого бизнес-процесса
 */
union EventSource {
    /* Идентификатор выплаты, которая породила событие */
    1: PayoutID payout_id
}

/**
 * Один из возможных вариантов содержания события
 */
union EventPayload {
    /* Набор изменений, порождённых выплатой */
    1: list<PayoutChange> payout_changes
}

/**
 * Один из возможных вариантов события, порождённого выплатой
 */
union PayoutChange {
    1: PayoutCreated        payout_created
    2: PayoutStatusChanged  payout_status_changed
}

/**
 * Событие о создании новой выплаты
 */
struct PayoutCreated {
    /* Данные созданной выплаты */
    1: required Payout payout
    /* Кто инициировал выплату */
    2: required UserInfo initiator
}

/**
  * Виды движения денежных средств
  */
enum CashFlowType {
    payment
    refund
    adjustment
}

/**
* Расшифровка части суммы вывода
* Описание части суммы вывода, сгруппированное по виду движения денежных средств
*/
struct CashFlowDescription {
    1: required domain.Amount amount
    2: required domain.Amount fee
    3: required string currency_symbolic_code
    4: required base.Timestamp from_time
    5: required base.Timestamp to_time
    6: required CashFlowType cash_flow_type
    /* Количество движений данного вида в выводе */
    7: required i32 count
}

/**
* Список описаний денежных сумм, из которых состоит сумма вывода
*/
typedef list<CashFlowDescription> CashFlowDescriptions

struct Payout {
    1: required PayoutID id
    2: required domain.PartyID party_id
    3: required domain.ShopID shop_id
    /* Время формирования платежного поручения, либо выплаты на карту  */
    4: required base.Timestamp created_at
    5: required PayoutStatus status
    6: required domain.FinalCashFlow payout_flow
    7: required PayoutType type
    8: optional CashFlowDescriptions cash_flow_descriptions
}

/**
 * Выплата создается в статусе "unpaid", затем может перейти либо в "paid", если
 * банк подтвердил, что принял ее в обработку (считаем, что она выплачена,
 * а она и будет выплачена в 99% случаев), либо в "cancelled", если не получилось
 * доставить выплату до банка.
 *
 * Из статуса "paid" выплата может перейти либо в "confirmed", если есть подтверждение
 * оплаты, либо в "cancelled", если была получена информация о неуспешном переводе.
 *
 * Может случиться так, что уже подтвержденную выплату нужно отменять, и тогда выплата
 * может перейти из статуса "confirmed" в "cancelled".
 */
union PayoutStatus {
    1: PayoutUnpaid unpaid
    2: PayoutPaid paid
    3: PayoutCancelled cancelled
    4: PayoutConfirmed confirmed
}

/* Создается в статусе unpaid */
struct PayoutUnpaid {}

/* Помечается статусом paid, когда удалось отправить в банк */
struct PayoutPaid {
    1: required PaidDetails details
}

/* Детали выплаты, которые появляются после того, как выплата успешно отправлена */
union PaidDetails {
    1: CardPaidDetails card_details
    2: AccountPaidDetails account_details
}

struct CardPaidDetails {
    1: required ProviderDetails provider_details
}

struct ProviderDetails {
    1: required string name
    2: required string transaction_id
}

struct AccountPaidDetails {}

/**
 * Помечается статусом cancelled, когда не удалось отправить в банк,
 * либо когда полностью откатывается из статуса confirmed с изменением
 * балансов на счетах
 */
struct PayoutCancelled {
    1: required UserInfo user_info
    2: required string details
}

/**
 * Помечается статусом confirmed, когда можно менять балансы на счетах,
 * то есть если выплата confirmed, то балансы уже изменены
 */
struct PayoutConfirmed {
    1: required UserInfo user_info
}

/* Типы выплаты */
union PayoutType {
    1: PayoutCard bank_card
    2: PayoutAccount bank_account
}

/* Выплата на карту */
struct PayoutCard {
    1: required domain.BankCard card
}

/* Вывод на расчетный счет */
union PayoutAccount {
    1: RussianPayoutAccount       russian_payout_account
    2: InternationalPayoutAccount international_payout_account
}

struct RussianPayoutAccount {
    1: required domain.RussianBankAccount bank_account
    2: required string inn
    3: required string purpose
    4: required domain.LegalAgreement legal_agreement
}

struct InternationalPayoutAccount {
   1: required domain.InternationalBankAccount bank_account
   2: required domain.InternationalLegalEntity legal_entity
   3: required string purpose
   4: required domain.LegalAgreement legal_agreement
}

/**
 * Событие об изменении статуса выплаты
 */
struct PayoutStatusChanged {
    /* Новый статус выплаты */
    1: required PayoutStatus status
}

/**
 * Диапазон для выборки событий
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
    2: required i32 limit

}

exception NoLastEvent {}
exception EventNotFound {}

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
     * запроса события
     */
    base.EventID GetLastEventID ()
        throws (1: NoLastEvent ex1)

}

/**
 * Выплаты на карту
 */
struct Pay2CardParams {
    1: required domain.BankCard bank_card
    2: required domain.PartyID party_id
    3: required domain.ShopID shop_id
    4: required domain.Cash sum
}

/* Когда на счете для вывода недостаточно средств */
exception InsufficientFunds {}
/* Когда превышен лимит */
exception LimitExceeded {}

/**
* Диапазон времени
* from_time - начальное время.
* to_time - конечное время.
* Если from > to  - диапазон считается некорректным.
*/
struct TimeRange {
    1: required base.Timestamp from_time
    2: required base.Timestamp to_time
}

struct ShopParams {
    1: required domain.PartyID party_id
    2: required domain.ShopID shop_id
}

/**
* Параметры для генерации выплаты
* time_range - диапазон времени, за который будет сформированы выплаты
* shop - параметры магазина. Если не указан, то генерируются выплаты за все магазины,
* имеющие платежи/возвраты/корректировки за указанный time_range
**/
struct GeneratePayoutParams {
    1: required TimeRange time_range
    2: optional ShopParams shop
}

/**
* Атрибуты поиска выплат
**/
struct PayoutSearchCriteria {
   1: optional PayoutSearchStatus status
   /* Диапазон времени создания выплат */
   2: optional TimeRange time_range
   3: optional list<PayoutID> payout_ids
}

enum PayoutSearchStatus {
    unpaid,
    paid,
    cancelled,
    confirmed
}

/**
* Поисковый запрос по выплатам
* search_criteria - атрибуты поиска выплат
* from_id (exclusive) - начальный идентификатор, после которого будет формироваться выборка
* size - размер выборки. Не может быть отрицательным и больше 1000, в случае если не указан,
* то значение будет равно 1000.
**/
struct PayoutSearchRequest {
   1: required PayoutSearchCriteria search_criteria
   2: optional i64 from_id
   3: optional i32 size
}

/**
* Поисковый ответ по выплатам
* payouts - информация по выплатам
* last_id (inclusive) - уникальный идентификатор, соответствующий последнему элементу выборки
**/
struct PayoutSearchResponse {
   1: required list<PayoutInfo> payouts
   2: required i64 last_id
}

/**
* Info по выплате для отображения в админке
**/
struct PayoutInfo {
    1: required PayoutID id
    2: required domain.PartyID party_id
    3: required domain.ShopID shop_id
    4: required domain.Amount amount
    5: required PayoutType type
    6: required PayoutStatus status
    7: required base.Timestamp from_time
    8: required base.Timestamp to_time
    9: required base.Timestamp created_at
    10: optional CashFlowDescriptions cash_flow_descriptions
}

service PayoutManagement {
    /********************* Вывод на счет ************************/
    /**
     * Сгенерировать и отправить по почте выводы за указанный промежуток времени
     */
    list<PayoutID> GeneratePayouts (1: GeneratePayoutParams params) throws (1: base.InvalidRequest ex1)

    /**
     * Подтвердить выплаты. Вернуть список подтвержденных выплат
     */
    set<PayoutID> ConfirmPayouts (1: set<PayoutID> payout_ids) throws (1: base.InvalidRequest ex1)

    /**
     * Отменить движения по выплатам. Вернуть список отмененных выплат
     */
    set<PayoutID> CancelPayouts (1: set<PayoutID> payout_ids, 2: string details) throws (1: base.InvalidRequest ex1)

    /**
    * Возвращает список Payout-ов согласно запросу поиска
    **/
    PayoutSearchResponse GetPayoutsInfo (1: PayoutSearchRequest request) throws (1: base.InvalidRequest ex1)
}
