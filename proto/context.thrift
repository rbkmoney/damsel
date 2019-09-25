/**
 * Сервис для манипуляции непрозрачным контекстом объектов.
 */

include "msgpack.thrift"

namespace java com.rbkmoney.damsel.context
namespace erlang ctx

// Types

/**
 * Пространство имён, отделяющее конексты одного сервиса.
 *
 * Например, `com.rbkmoney.capi`.
 */
typedef string                  Namespace

/**
 * Структурированное значение контекста в формате msgpack.
 *
 * Например, `{"metadata": {"order": "N1488"}}`.
 */
typedef msgpack.Value           Context

typedef map<Namespace, Context> ContextSet

union Change {
    1: ContextSet   put
    2: Namespace    deleted
}

// Service

exception ObjectNotFound {}
exception Forbidden      {}

typedef string ObjectID

service Contexts {

    Context Get (
        1: ObjectID  id
        2: Namespace ns
    ) throws (
        1: ObjectNotFound ex1
    )

    void Put (
        1: ObjectID  id
        2: Namespace ns
        3: Context   context
    ) throws (
        1: ObjectNotFound ex1
        2: Forbidden      ex2
    )

    void Delete (
        1: ObjectID  id
        2: Namespace ns
    ) throws (
        1: ObjectNotFound ex1
        2: Forbidden      ex2
    )

}
