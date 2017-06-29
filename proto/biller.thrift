include "base.thrift"
include "domain.thrift"


namespace java com.rbkmoney.damsel.biller
namespace erlang biller

typedef string TaskId

    enum PaymentTransactionStatus{
        // платеж подтвержден
        confirmed,
        // ошибка при разобре платежа
        error,
        // данный платеж будет проигнорирован
        ignored
    }

    struct PaymentTransaction{
        // Сокрашенный идетификатор платежа
        1: optional string short_payment_id;
        // Идентификатор инвойса
        2: optional string invoice_id

        // Порядковый номер строки записи
        3: required i32 id
        // Дата транзакции
        4: required string transaction_date
        // Наименование клиента плательщика
        5: required string payer_name
        // Оборот в рублях
        6: required i64 amount
        // Назначение платежа
        7: required string purpose
        // Статус проверки платежа
        8: required PaymentTransactionStatus status
        // Описание статуса или ошибки
        9: required string description
    }

    enum TaskResultStatus{
           in_progress,
           ready,
           error
    }

    struct TaskResult {
        1: required TaskResultStatus status
        2: optional list<PaymentTransaction> result;
        3: optional string description
    }

    /**
    * Сервис для подтверждения платежей заведенных в системе
    *
    * Загружаемый файл анализируется и платежи попавшие в него помечаются прошедшими в HG или возвращают описание ошибки
    *
    **/
    service Biller {
        /**
        * Файл загружается и возвращает идентификатор задачи на его обработку - PaymentsFileId
         **/
        TaskId markCaptured(1: base.Content payments_data);

        /**
        * Получить результат обработки файла
        **/
        TaskResult getTaskResult(1: TaskId id)

    }





