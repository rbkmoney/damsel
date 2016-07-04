include "base.thrift"
include "payment_processing.thrift"

namespace java com.rbkmoney.damsel.event_stock
namespace erlang event_stock

typedef list<StockEvent> StockEvents
typedef base.EventID EventID
typedef base.Timestamp Timestamp
typedef base.InvalidRequest InvalidRequest

/**
* Исходное событие, полученное из HG или другого источника.
*/
union SourceEvent {
    1: payment_processing.Event processing_event
}

/**
* Событие, которое BM отдает клиентам.
* source_event - Исходное событие, к которому применяeтся фильтр.
*/
struct StockEvent {
    1: required SourceEvent source_event
}

/**
* Граница диапазона EventId.
*/
union EventIDBound {
    1: EventID inclusive
    2: EventID exclusive
}

/**
* Диапазон идентификаторов событий.
* from_id - с какого ID.
* to_id - по какой ID. Если не задано - запрашиваются все данные от from_id.
* Если from > to - диапазон считается некорректным.
*/
struct EventIDRange {
    1: required EventIDBound from_id
    2: optional EventIDBound to_id
}

/**
* Граница диапазона Timestamp.
*/
union EventTimeBound {
    1: Timestamp inclusive;
    2: Timestamp exclusive;
}

/**
* Диапазон времени создания событий.
* from_time - начальное время.
* to_time - конечное время. Если не задано - запрашиваются все данные от from_time.
* Если from > to  - диапазон считается некорректным.
*/
struct EventTimeRange {
    1: required EventTimeBound from_time;
    2: optional EventTimeBound to_time;
}

/**
* Диапазон событий по ID или времени создания.
* Если границы диапазона выборки указавают на не существующие значения, то в выборку попадут ближайшие удовлетворяющее условию значения.
*/
union EventRange {
    1: EventIDRange id_range;
    2: EventTimeRange time_range;
}

/**
* Ограничение выборки событий.
* event_range - диапазон выборки. Нужно явно задавать, какой диапазон ID или времени должен быть отфильтрован.
* limit - максимальный размер выборки, неотрицательное целое число.
*/
struct EventConstraint {
    1: required EventRange event_range;
    3: required i32 limit;
}

/**
* Ошибка превышения максимального размера блока данных, доступного для отправки клиенту.
* limit - текущий максимальный размер блока.
*/
exception DatasetTooBig {
    1: i32 limit;
}

/***
* Ошибка доступа к отсутствующему элементу в хранилище событий.
**/
exception NoStockEvent {
}


/**
* Интерфейс BM для клиентов.
*/
service EventRepository {
    /**
    * Возвращает события, удовлетворяющие переданному условию.
    * Возвращаемый набор данных отсортирован по ID.
    * Возвращает ошибку InvalidRequest, если диапазон фильтрации или лимит указан некорректно.
    * Возвращает ошибку DatasetTooBig, если результирующий блок данных слишком большой.
    */
    StockEvents GetEvents(1: EventConstraint constraint) throws (1: InvalidRequest ex1, 2: DatasetTooBig ex2)

    /**
    * Возвращает наиболее позднее известное на момент исполнения запроса событие.
    */
    StockEvent GetLastEvent () throws (1: NoStockEvent ex1)

    /**
     * Возвращает наиболее раннее событие, имеющееся в хранилище.
     */
    StockEvent GetFirstEvent () throws (1: NoStockEvent ex1)
}


