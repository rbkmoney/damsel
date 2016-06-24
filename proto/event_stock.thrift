include "base.thrift"
include "payment_processing.thrift"

namespace java com.rbkmoney.damsel.event_stock
namespace erlang event_stock

typedef list<StockEvent> StockEvents
typedef base.EventID EventID
typedef base.Timestamp Timestamp
typedef base.InvalidRequest InvalidRequest
typedef payment_processing.NoLastEvent NoLastEvent

/**
* Исходное событие, полученное из HG или другого источника.
*/
union SourceEvent {
    1: payment_processing.Event processing_event;
}

/**
* Событие, которое BM отдает клиентам.
* source_event - Исходное событие, к которому применяeтся фильтр.
*/
struct StockEvent {
    1: required SourceEvent source_event;
}

/**
* Диапазон идентификаторов событий.
* from_id - с какого ID (inclusive), если не задан, берется текущее минимальное значение.
* to_id - по какой ID (inclusive), если не задан, берется текущее максимальное значение.
* Если from и to не заданы, либо from > to - диапазон считается некорректным.
*/
struct EventIDRange {
    1: optional EventID from_id;
    2: optional EventID to_id;
}

/**
* Диапазон времени создания событий.
* from_time - начальное время (inclusive), если не задан, берется текущее минимальное значение.
* to_time - конечное время (inclusive), если не задан, берется текущее максимальное значение.
* Если from_time и to_time не заданы, либо from > to  - диапазон считается некорректным.
*/
struct EventTimeRange {
    1: required Timestamp from_time;
    2: optional Timestamp to_time;
}

/**
* Диапазон событий по ID и/или времени создания.
* Если ни один из диапазонов не задан, считается некорректным.
*/
struct EventRange {
    1: optional EventIDRange id_range;
    2: optional EventTimeRange time_range;
}

/**
* Ограничение выборки событий.
* event_range - диапазон выборки. Нужно явно задавать, какой диапазон ID и/или времени должен быть отфильтрован.
* limit - максимальный размер выборки, неотрицательное целое число.
*/
struct EventConstraint {
    1: required EventRange event_range;
    3: optional i32 limit;
}

/**
* Интерфейс BM для клиентов.
*/
service EventRepository {
    /**
    * Возвращает события, удовлетворяющие переданному условию.
    * Возвращаемый набор данных отсортирован по ID. Количество возвращаемых элементов не превышает 10000 независимо от переданного значения limit.
    * Возвращает ошибку InvalidRequest, если диапазон фильтрации или лимит указан некорректно.
    */
    StockEvents getEvents(1: EventConstraint constraint) throws (1: InvalidRequest ex1)

    /**
    * Возвращает идентификатор наиболее позднего известного на момент исполнения
    * запроса события.
    */
    EventID getLastEventID () throws (1: NoLastEvent ex1)
}


