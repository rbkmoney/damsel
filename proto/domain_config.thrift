/**
 * Интерфейс и связанные с ним определения сервиса конфигурации предметной
 * области (domain config).
 */

include "domain.thrift"

namespace erl domain

/**
 * Маркер вершины истории.
 */
struct Head {}

/**
 * Вариант представления ревизии в истории.
 */
union Revision {
    1: i64 rev;
    2: Head head;
}

/**
 * Монотонно возрастающая версия монолитного набора объектов, определённая
 * точка в его истории набора объектов.
 */
struct Version {
    1: required i32 schema = domain.REVISION;
    2: required Revision data;
}

/**
 * Возможные операции над набором объектов.
 */
union Operation {
    1: InsertOp insert;
    2: UpdateOp update;
    3: RemoveOp remove;
}

struct InsertOp {
    1: required domain.Object object;
}

struct UpdateOp {
    1: required domain.Object object;
}

struct RemoveOp {
    1: required domain.Reference ref;
}

exception VersionNotFound {}
exception ObjectNotFound {}
exception OperationConflict {}

/**
 * Интерфейс сервиса конфигурации предметной области.
 */
service Configurator {

    Version head ()
        throws (1: VersionNotFound ex1);

    Version pollHead ()
        throws ();

    domain.Domain checkout (1: Version v)
        throws (1: VersionNotFound ex1);

    domain.Object checkoutObject (1: Version v, 2: domain.Reference ref)
        throws (1: VersionNotFound ex1, 2: ObjectNotFound ex2);

    Version commit (1: Version v, 2: Operation op)
        throws (1: VersionNotFound ex1, 2: OperationConflict ex3);

}
