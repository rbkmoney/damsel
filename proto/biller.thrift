include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.biller
namespace erlang biller


    struct InvoiceValidation{
        // Может быть незарезолвен
        1: optional String invoiceId
        // Порядковый номер записи
        2: required String id
        // Дата транзакции
        3: required String transaction_date
        // Наименование клиента плательщика
        4: required String payer_name
        // Оборот в рублях
        5: required i64 amount
        // Назначение платежа
        6: required String purpose
        // Платеж корректен
        7: required bool valid
        // Причина не валидности
        8: optional String reason
    }

    /**
    * Сервис для генерации платежных извещений(квитанций) и ввода платежей по ним в систему
    **/
    service billler {
       /**
       * сгенерировать и отдать pdf с извещением по указанному платежу
       *
       * ?? нужен номер платежа?
       **/
       binary generatebilldocument(1: string invoiceid);

       list<InvoiceValidation> validateInvoice(1: binary report_file);

       void accept(1: String invoiceId);



    }





