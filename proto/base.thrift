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
    3: optional i16 weeks
    4: optional i16 days
    5: optional i16 hours
    6: optional i16 minutes
    7: optional i16 seconds
}

/** День недели */
enum DayOfWeek { Mon Tue Wed Thu Fri Sat Sun }

/** Год */
typedef i32 Year

/** Месяц года */
enum Month { Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec }

/** День месяца */
typedef i8 DayOfMonth

/**
 * Расписание.
 *
 * Модель по аналогии с записью в [crontab][1], за исключением максимального
 * разрешения, которое составляет 1 секунду.
 *
 * Как и в случае с [crontab][1], если задан как некоторый `day_of_month`, так и
 * некоторый `day_of_week`, то запланированные согласно этому расписанию события
 * должны произойти при наступлении _любого_ из них.
 *
 * Например, если событие запланировано следующим образом:
 *
 * - year         = every
 * - month        = every
 * - day of month = on { 15 25 }
 * - day of week  = on { Fri }
 * - hour         = on { 9 }
 * - minute       = on { 0 }
 * - second       = on { 0 }
 *
 * ...то в июне 2018 года оно должно выполнится в следующие моменты:
 *
 * - 2018 Jun 01 09:00:00 (потому что пятница),
 * - 2018 Jun 08 09:00:00 (потому что пятница),
 * - 2018 Jun 15 09:00:00 (потому что пятница и 15-е число),
 * - 2018 Jun 22 09:00:00 (потому что пятница),
 * - 2018 Jun 25 09:00:00 (потому что 25-е число),
 * - 2018 Jun 29 09:00:00 (потому что пятница).
 *
 * [1]: http://man7.org/linux/man-pages/man5/crontab.5.html
 */
struct Schedule {
    1: required ScheduleYear year
    2: required ScheduleMonth month
    3: required ScheduleFragment day_of_month
    4: required ScheduleDayOfWeek day_of_week
    5: required ScheduleFragment hour
    6: required ScheduleFragment minute
    7: required ScheduleFragment second
}

struct ScheduleEvery {
    /** Шаг.
     *
     * Как отсутствие, так и указание любого значения ≤ 1 равнозначно поведению
     * _каждый первый фрагмент времени_.
     */
    1: optional i8 nth
}

union ScheduleFragment {
    1: ScheduleEvery every
    2: set<i8> on
}

union ScheduleDayOfWeek {
    1: set<DayOfWeek> on
}

union ScheduleMonth {
    1: set<Month> on
}

union ScheduleYear {
    1: ScheduleEvery every
    2: set<Year> on
}

/** Часовой пояс, согласно IANA Timezone Database. */
typedef string Timezone

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
