/*
 * Базовые, наиболее общие определения
 */

namespace java com.rbkmoney.damsel.base

/** Идентификатор */
typedef string ID

/** Пространство имён */
typedef string Namespace

/** Идентификатор некоторого события */
typedef i64 EventID

/** Непрозрачный для участника общения набор данных */
typedef binary Opaque

/** Набор данных, подлежащий интерпретации согласно типу содержимого. */
struct Content {
    /** Тип содержимого, согласно [RFC2046](https://www.ietf.org/rfc/rfc2046) */
    1: required string type
    2: required binary data
}

/**
 * Отметка во времени согласно RFC 3339.
 *
 * Строка должна содержать дату и время в UTC в следующем формате:
 * `2016-03-22T06:12:27Z`.
 */
typedef string Timestamp

/**
 * Временной интервал
 * не заданное значение границы считается бесконечностью
 */
struct TimestampInterval {
    1: optional TimestampIntervalBound lower_bound
    2: optional TimestampIntervalBound upper_bound
}

struct TimestampIntervalBound {
    1: required BoundType bound_type
    2: required Timestamp bound_time
}

enum BoundType {
    inclusive
    exclusive
}

/**
 * Промежуток во времени.
 *
 * Порядок применения отрезков к моменту времени: от более протяжённых (годы) к
 * менее протяжённым (секунды).
 *
 * Если какой-либо отрезок не задан, предполагается, что он равен 0.
 */
struct TimeSpan {
    1: optional i16 years
    2: optional i16 months
    4: optional i16 days
    5: optional i16 hours
    6: optional i16 minutes
    7: optional i16 seconds
}

/** Отображение из строки в строку */
typedef map<string, string> StringMap

/** Рациональное число. */
struct Rational {
    1: required i64 p
    2: required i64 q
}

/** Отрезок времени в секундах */
typedef i32 Timeout

/** Значение ассоциации */
typedef string Tag

/** Критерий остановки таймера */
union Timer {
    /** Отрезок времени, после истечения которого таймер остановится */
    1: Timeout timeout
    /** Отметка во времени, при пересечении которой таймер остановится */
    2: Timestamp deadline
}

/**
 * Исключение, сигнализирующее о непригодных с точки зрения бизнес-логики входных данных
 */
exception InvalidRequest {
    /** Список пригодных для восприятия человеком ошибок во входных данных */
    1: required list<string> errors
}
