/*
 * Базовые, наиболее общие определения
 */

/** Идентификатор */
typedef string ID;

/**
 * Отметка во времени согласно ISO 8601.
 *
 * Строка должна содержать дату и время в UTC в следующем формате:
 * `2016-03-22T06:12:27Z`.
 */
typedef string Timestamp;

/** Рациональное число. */
struct Rational {
    1: required i64 p
    2: required i64 q
}

/** Отрезок времени в секундах */
typedef i32 Timeout;

/** Значение ассоциации */
typedef string Tag;

/** Критерий остановки таймера */
union Timer {
    /** Отрезок времени, после истечения которого таймер остановится */
    1: Timeout timeout;
    /** Отметка во времени, при пересечении которой таймер остановится */
    2: Timestamp deadline;
}

/** Общая ошибка */
struct Error {
    /** Уникальный признак ошибки, пригодный для обработки машиной */
    1: required string code;
    /** Описание ошибки, пригодное для восприятия человеком */
    2: optional string description;
}

/** Общее исключение */
exception Failure {
    /** Ошибка, которая привела к возникновению исключения */
    1: required Error error;
}

/** Исключение, сигнализирующее об отсутствии объекта или процесса */
exception NotFound {}
exception EventNotFound {}
exception MachineNotFound {}
