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
 * Снэпшот это определенная версия данных
 * конфигурации домена
 */
struct Snapshot {
    1: Version version
    2: domain.Domain domain
}

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

struct CheckoutObjectResult {
    1: Version version
    2: domain.DomainObject
}

/**
 * Требуемая версия отсутствует
 */
exception VersionNotFound {}

/**
 * Объект не найден в домене
 */
exception ObjectNotFound {}

/**
 * Возникает в случаях, если коммит
 * несовместим с уже примененными ранее
 */
exception OperationConflict {}

/**
 * Интерфейс сервиса конфигурации предметной области.
 */
service RepositoryClient {
    
    /**
     * Возвращает объект из домена определенной или последней версии
     */
    CheckoutObjectResult checkoutObject (1: Reference version_ref, 2: domain.Reference object_ref)
        throws (1: VersionNotFound ex1, 2: ObjectNotFound ex2);

}

service Repository {

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
    Snapshot checkout (1: Reference r)
        throws (1: VersionNotFound ex1)

    /**
     * Получить новые коммиты следующие за версией v
     */
    History pull (1: Version v)
        throws (1: VersionNotFound ex1)

}
