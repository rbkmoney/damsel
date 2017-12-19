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
    fee
    refund
    adjustment
    guarantee
}

/**
 * Расшифровка части суммы вывода
 * Описание части суммы вывода, сгруппированное по виду движения денежных средств
 */
struct CashFlowDescription {
    1: required domain.Cash cash
    2: required CashFlowType cash_flow_type
    /* Количество движений данного вида в выводе */
    3: required i32 count
    4: optional string details
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
struct PayoutAccount {
    1: required domain.BankAccount account
    2: required string inn
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
* to_time - конечное время. Если не задано - запрашиваются все данные от from_time.
* Если from > to  - диапазон считается некорректным.
*/
struct TimeRange {
    1: required base.Timestamp from_time
    2: optional base.Timestamp to_time
}

struct GeneratePayoutParams {
    1: required TimeRange time_range
    2: required domain.PartyID party_id
    3: required domain.ShopID shop_id
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
}

service PayoutManagement {
    /********************* Вывод на счет ************************/
    /**
     * Сгенерировать и отправить по почте выводы за указанный промежуток времени
     */
    PayoutID GeneratePayout (1: GeneratePayoutParams params) throws (1: base.InvalidRequest ex1)

    /**
     * Подтвердить выплаты. Вернуть список подтвержденных выплат
     */
    list<PayoutID> ConfirmPayouts (1: list<PayoutID> payout_ids) throws (1: base.InvalidRequest ex1)

    /**
     * Отменить движения по выплатам. Вернуть список отмененных выплат
     */
    list<PayoutID> CancelPayouts (1: list<PayoutID> payout_ids) throws (1: base.InvalidRequest ex1)

    /**
    * Возвращает список Payout-ов согласно запросу поиска
    **/
    list<PayoutInfo> GetPayoutsInfo (1: PayoutSearchCriteria search_criteria) throws (1: base.InvalidRequest ex1)
}
