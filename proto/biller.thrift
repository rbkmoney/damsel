include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.biller
namespace erlang biller

    exception FileParsingError {}

    enum ValidationStatus{
        // платеж подтвержден
        confirmed,
        // ошибка при разобре платежа
        error,
        // данный платеж будет проигнорирован
        ignored
    }

    struct InvoiceValidation{
        // Сокрашенный идетификатор платежа
        1: optional string short_payment_id;
        // Идентификатор инвойса
        2: optional string invoiceId

        // Порядковый номер строки записи
        3: required string id
        // Дата транзакции
        4: required string transaction_date
        // Наименование клиента плательщика
        5: required string payer_name
        // Оборот в рублях
        6: required i64 amount
        // Назначение платежа
        7: required string purpose
        // Статус проверки платежа
        8: required ValidationStatus status
        // Описание статуса или ошибки
        9: required string description

    }

    /**
    * Сервис для подтверждения платежей заведенных в системе
    *
    * Загружаемый файл анализируется и платежи попавшие в него помечаются прошедшими
    **/
    service Biller {
       list<InvoiceValidation> validateInvoice(1: binary report_file) throws (1:FileParsingError ex1);
    }





