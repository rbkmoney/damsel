include 'base.thrift'
include 'domain.thrift'

namespace java com.rbkmoney.damsel.limiter
namespace erlang limiter
typedef base.ID PlanID
typedef i64 BatchID
typedef i64 LimitID
typedef i64 CommandID

/**
* Структура данных, описывающая время жизни лимита:
* creation_time - время создания лимита
* end_time - время завершения действия лимита
* auto_reload - если true, то при обращение к лимиту после его срока жизни, его amount
* будет автоматически установлен на начальное значение, а end_time пересчитается в
* соответствии с начальным циклом жизни (разница end_time - creation_time в момент создания лимита)
* Если auto_reload = false, то после срока жизни любое обращение должно перемещать лимит в архив,
* чтобы пользователь мог создать новый лимит с таким же id.
*/
struct LimitLifetime {
    1: required base.Timestamp creation_time
    2: required base.Timestamp end_time
    3: required bool auto_reload
}

/**
* Данные, необходимые для создания лимита:
* id - серилизованное в строчку описание лимита
* amount - значение лимита
* lifetime - продолжительность жизни
* description - описание
*/
struct LimitPrototype {
    1: required string id
    2: required domain.Amount amount
    3: required LimitLifetime lifetime
    4: optional string description
}

/**
* Структура данных, описывающая свойства лимита:
* id - серилизованное в строчку описание лимита
* init_amount - начальное значение лимита, необходимо при auto_reload = true
* current_amount - текущее значение лимита
* lifetime - фактическая продолжительность жизни, может менятся при auto_reload = true
* init_lifetime - начальная продолжительность жизни, необходимо при auto_reload = true
* description - описания (неизменяемо после создания лимита)
*
* У каждого лимита должна быть сериализованная история, то есть наблюдаемая любым клиентом в определённый момент времени
* последовательность событий в истории лимита должна быть идентична.
*/
struct Limit {
    1: required LimitID id
    2: required domain.Amount init_amount
    3: required domain.Amount current_amount
    3: optional LimitLifetime lifetime
    7: optional LimitLifetime init_lifetime
    6: optional string description
}

/**
*  Описывает одну операцию снижения лимита в системе:
*  id - id уменьшаемого лимита
*  amount - значение, на которое уменьшится лимит (не может быть отрицательным)
*  description - описание
*/
struct LimitReduction {
    1: required LimitID id
    3: required domain.Amount amount
    4: required string description
}

/**
* Описывает батч - набор операций уменьшения лимита, служит единицей
* атомарности в системе:
* id -  идентификатор набора, уникален в пределах плана
* LimitReductions - набор операций уменьшения
*/
struct LimitReductionBatch {
    1: required BatchID id
    2: required list<LimitReduction> limit_reductions
}

/**
 * План уменьшения, состоит из набора батчей, который можно пополнить, подтвердить или отменить:
 * id - идентификатор плана, уникален в рамках системы
 * batch_list - набор батчей, связанный с данныс планом
*/
struct Plan {
    1: required PlanID id
    2: required list<LimitReductionBatch> batch_list
}

/**
* Описывает единицу пополнения плана:
* id - id плана, к которому применяется данное изменение
* batch - набор операций уменьшения лимита, который нужно добавить в план
*/
struct PlanChange {
   1: required PlanID id
   2: required LimitReductionBatch batch
}

/**
* Результат применение единицы изменения плана:
* affected_limits - новое состояние задействованных лимитов
*/
struct PlanLog {
    2: required map<LimitID, Limit> affected_limits
}

exception LimitNotFound {
    1: required LimitID Limit_id
}

exception PlanNotFound {
    1: required PlanID plan_id
}

/**
* Возникает в случае, если переданы некорректные параметры в одной или нескольких операциях
*/
exception InvalidLimitReductionParams {
    1: required map<LimitReduction, string> wrong_limit_reductions
}

service Limiter {
    PlanLog Hold(1: PlanChange plan_change) throws (1:InvalidLimitReductionParams ex1, 2:base.InvalidRequest ex2)
    PlanLog CommitPlan(1: Plan plan) throws (1:InvalidLimitReductionParams ex1, 2:base.InvalidRequest ex2)
    PlanLog RollbackPlan(1: Plan plan) throws (1:InvalidLimitReductionParams ex1, 2:base.InvalidRequest ex2)
    Plan GetPlan(1: PlanID id) throws (1: PlanNotFound ex1)

    Limit GetLimitByID(1: LimitID id) throws (1: LimitNotFound ex1)
    CommandID CreateLimit(1: LimitPrototype prototype)

    /**
    * CommandResult PollCompletion(1: CommandID)throws (1: CommandNotFound ex1)
    */
}
