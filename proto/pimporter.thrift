include "base.thrift"

namespace java com.rbkmoney.damsel.pimporter
namespace erlang pimporter

typedef string ImportId

enum PaymentTransactionStatus{
    // платеж подтвержден
    confirmed,
    // ошибка при импорте платежа
    error,
    // данный платеж будет проигнорирован
    ignored
}

struct PaymentTransaction{
    // Сокращенный идентификатор платежа
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
    7: required string reciept_purpose
    // Статус проверки платежа
    8: required PaymentTransactionStatus status
    // Описание статуса или ошибки
    9: required string description
}

enum ImportStatus{
       processing,
       ready,
       failed
}

struct ImportResult {
    1: required ImportStatus status
    2: optional list<PaymentTransaction> result;
    3: optional string description
}

/**
* Сервис для подтверждения платежей заведенных в системе
*
* Загружаемый файл анализируется и платежи попавшие в него помечаются прошедшими или возвращается описание ошибки
*
**/
service PaymentImporter {
    /**
     * Загрузить файл для импорта платежей в систему
     * возвращает идентификатор задачи на его обработку - ImportId
     **/
    ImportId ImportPayments(1: base.Content payments_data);

    /**
    * Получить результат обработки файла
    **/
    ImportResult GetImportResult(1: ImportId id)

}





