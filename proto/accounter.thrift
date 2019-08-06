include 'base.thrift'
include 'domain.thrift'

namespace java com.rbkmoney.damsel.accounter
namespace erlang accounter
typedef base.ID PlanID
typedef i64 BatchID
typedef string AccountID

/**
* Данные, необходимые для создания счета:
* currency_sym_code - символьный код валюты
* description - описание
* creation_time - время создания аккаунта
*/
struct AccountPrototype {
    1: required domain.CurrencySymbolicCode currency_sym_code
    2: optional string description
    3: optional base.Timestamp creation_time
}

/**
* Структура данных, описывающая свойства счета:
* id - номер сета (генерируется аккаунтером)
* own_amount - собственные средства (объём средств на счёте с учётом только подтвержденных операций)
* max_available_amount - максимально возможные доступные средства
* min_available_amount - минимально возможные доступные средства
* Где минимально возможные доступные средства - это объем средств с учетом подтвержденных и не подтвержденных
* операций в определённый момент времени в предположении, что все планы с батчами, где баланс этого счёта изменяется в
* отрицательную сторону, подтверждены, а планы, где баланс изменяется в положительную сторону,
* соответственно, отменены.
* Для максимального значения действует обратное условие.
* currency_sym_code - символьный код валюты (неизменяем после создания счета)
* description - описания (неизменяемо после создания счета)
*
*У каждого счёта должна быть сериализованная история, то есть наблюдаемая любым клиентом в определённый момент времени
* последовательность событий в истории счёта должна быть идентична.
*/
struct Account {
    1: required AccountID id
    2: required domain.Amount own_amount
    3: required domain.Amount max_available_amount
    4: required domain.Amount min_available_amount
    5: required domain.CurrencySymbolicCode currency_sym_code
    6: optional string description
    7: optional base.Timestamp creation_time
}

/**
*  Описывает одну проводку в системе (перевод спедств с одного счета на другой):
*  from_id - id счета, с которого производится списание
*  to_id - id счета, на который производится зачисление
*  amount - объем переводимых средств (не может быть отрицательным)
*  currency_sym_code - код валюты, должен совпадать с кодами задействованных счетов
*  description - описание проводки
*/
struct Posting {
    1: required AccountID from_id
    2: required AccountID to_id
    3: required domain.Amount amount
    4: required domain.CurrencySymbolicCode currency_sym_code
    5: required string description
}

/**
* Описывает батч - набор проводок, служит единицей атомарности операций в системе:
* id -  идентификатор набора, уникален в пределах плана
* postings - набор проводок
*/
struct PostingBatch {
    1: required BatchID id
    2: required list<Posting> postings
}

/**
* План проводок, состоит из набора батчей, который можно пополнить, подтвердить или отменить:
 * id - идентификатор плана, уникален в рамках системы
 * batch_list - набор батчей, связанный с данныс планом
*/
struct PostingPlan {
    1: required PlanID id
    2: required list<PostingBatch> batch_list
}

/**
* Описывает единицу пополнения плана:
* id - id плана, к которому применяется данное изменение
* batch - набор проводок, который нужно добавить в план
*/
struct PostingPlanChange {
   1: required PlanID id
   2: required PostingBatch batch
}

union Clock {
    1: VectorClock vector
    2: LatestClock latest
}

struct VectorClock {
    1: required base.Opaque state
}

struct LatestClock {
}

/**
* Результат применение единицы пополнения плана:
* affected_accounts - новое состояние задействованных счетов
*/
struct PostingPlanLog {
    2: required map<AccountID, Account> affected_accounts
}

exception AccountNotFound {
    1: required AccountID account_id
}

exception PlanNotFound {
    1: required PlanID plan_id
}

/**
* Возникает в случае, если переданы некорректные параметры в одной или нескольких проводках
*/
exception InvalidPostingParams {
    1: required map<Posting, string> wrong_postings
}
exception ClockInFuture {}
//exception

service Accounter {
    Clock Hold(1: PostingPlanChange plan_change) throws (1: InvalidPostingParams e1, 2: base.InvalidRequest e2)
    Clock CommitPlan(1: PostingPlan plan) throws (1: InvalidPostingParams e1, 2: base.InvalidRequest e2)
    Clock RollbackPlan(1: PostingPlan plan) throws (1: InvalidPostingParams e1, 2: base.InvalidRequest e2)
    PostingPlan GetPlan(1: PlanID id) throws (1: PlanNotFound e1)
    Account GetAccountByID(1: AccountID id, 2: Clock clock) throws (1:AccountNotFound e1, 3: ClockInFuture e2)
}