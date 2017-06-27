/**
 * Интерфейс и связанные с ним определения сервиса конфигурации предметной
 * области (domain config).
 */

include "domain.thrift"

namespace java com.rbkmoney.damsel.domain_config
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
    3: RemoveOp remove;
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

struct RemoveOp {
    1: required domain.DomainObject object;
}

struct VersionedObject {
    1: Version version
    2: domain.DomainObject object
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
exception OperationConflict { 1: required Conflict conflict }

union Conflict {
    1: ObjectAlreadyExistsConflict object_already_exists
    2: ObjectNotFoundConflict object_not_found
    3: ObjectReferenceMismatchConflict object_reference_mismatch
    4: ObjectsNotExistConflict objects_not_exist
}

struct ObjectAlreadyExistsConflict {
    1: required domain.DomainObject object
}

struct ObjectNotFoundConflict {
    1: required domain.Reference object_ref
}

struct ObjectReferenceMismatchConflict {
    1: required domain.Reference object_ref
}

struct ObjectsNotExistConflict {
    1: required list<NonexistantObject> refs
}

struct NonexistantObject {
    1: required Reference ref
    2: required list<Reference> referenced_by
}

/**
 * Попытка совершить коммит на устаревшую версию
 */
exception ObsoleteCommitVersion {}

/**
 * Интерфейс сервиса конфигурации предметной области.
 */
service RepositoryClient {
    
    /**
     * Возвращает объект из домена определенной или последней версии
     */
    VersionedObject checkoutObject (1: Reference version_ref, 2: domain.Reference object_ref)
        throws (1: VersionNotFound ex1, 2: ObjectNotFound ex2);

}

service Repository {

    /**
     * Применить изменения к определенной версии.
     * Возвращает следующую версию
     */
    Version Commit (1: Version version, 2: Commit commit)
        throws (1: VersionNotFound ex1, 2: OperationConflict ex2, 3: ObsoleteCommitVersion ex3);
        
    /**
     * Получить снэпшот конкретной версии
     */
    Snapshot Checkout (1: Reference reference)
        throws (1: VersionNotFound ex1)

    /**
     * Получить новые коммиты следующие за указанной версией
     */
    History Pull (1: Version version)
        throws (1: VersionNotFound ex1)

}
