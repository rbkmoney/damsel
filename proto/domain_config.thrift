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
 * Референс может указывать либо на конкретную
 * версию либо на наиболее актуальную.
 */
union Reference {
    1: Version version;
    2: Head head;
}

/**
 * Снэпшот это определенная версии домена
 * в терминлологии конфигуратора
 */
typedef domain.Domain Snapshot

/**
 * Возможные операции над набором объектов.
 */
 
struct Commit {
    1: required list<Operation> ops
}

/**
 * История это последовательность коммитов
 */
typedef map<Version, Commit> History

union Operation {
    1: InsertOp insert;
    2: UpdateOp update;
    3: DeleteOp remove;
}

struct InsertOp {
    1: required domain.DomainObject object;
}

/**
 * Содержит значения до и после внесенных изменений
 */
struct UpdateOp {
    1: required domain.DomainObject old_object;
    2: required domain.DomainObject new_object;
}

struct DeleteOp {
    1: required domain.DomainObject object;
}

exception VersionNotFound {}
exception ObjectNotFound {}
exception OperationConflict {}

/**
 * Интерфейс сервиса конфигурации предметной области.
 */
service Configurator {
    
    /**
     * Возвращает объект из домена определенной или последней версии
     */
    domain.DomainObject checkoutObject (1: Reference version_ref, 2: domain.Reference object_ref)
        throws (1: VersionNotFound ex1, 2: ObjectNotFound ex2);

}

service ConfiguratorAdmin {

    /**
     * Применить изменения к определенной версии v.
     * Возвращает более старшую ближайшую к определенной версию, в которой содержатся
     * изменения, представленные в коммите c
     */
    Version commit (1: Version v, 2: Commit c)
        throws (1: VersionNotFound ex1, 2: OperationConflict ex3);
        
    /**
     * Получить снэпшот конкретной версии
     */
    Snapshot checkout (1: Version v)
        throws (1: VersionNotFound ex1)

    /**
     * Получить новые коммиты начиная с версии v
     */
    History pull (1: Version v)
        throws (1: VersionNotFound ex1)

}
