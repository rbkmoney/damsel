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
typedef i64 Version

/**
 * Вариант представления ревизии в истории.
 */
union Reference {
    1: Version version;
    2: Head head;
}

/**
 * Возможные операции над набором объектов.
 */

union Operation {
    1: InsertOp insert;
    2: UpdateOp update;
    3: DeleteOp remove;
}

struct InsertOp {
    1: required domain.DomainObject object;
}

struct UpdateOp {
    1: required domain.DomainObject object;
}

struct DeleteOp {
    1: required domain.Reference ref;
}

exception VersionNotFound {}
exception ObjectNotFound {}
exception OperationConflict {}

/**
 * Интерфейс сервиса конфигурации предметной области.
 */
service Configurator {

    domain.DomainObject checkoutObject (1: Reference version_ref, 2: domain.Reference object_ref)
        throws (1: VersionNotFound ex1, 2: ObjectNotFound ex2);

}

service ConfiguratorAdmin {

    Version commit (1: Version v, 2: list<Operation> ops)
        throws (1: VersionNotFound ex1, 2: OperationConflict ex3);

}
