    include "base.thrift"
    include "domain.thrift"

    namespace java com.rbkmoney.damsel.shitter
    namespace erlang shitter

    typedef base.ID PayoutID

    /**
    * Диапазон времени
    * from_time - начальное время.
    * to_time - конечное время. Если не задано - запрашиваются все данные от from_time.
    * Если from > to  - диапазон считается некорректным.
    */
    struct TimeRange {
       1: required base.Timestamp from_time
       2: optional base.Timestamp to_time
    }

    /**
     * Статус выплаты
     * new - выплата создана, но сумма платежей еще не вычисленна и остальные атрибуты не заполненны
     * ready - выплата готова и заполненна данными
     * accepted - корректность выплаты подтверждена АБС и 1С.
     **/
    enum PayoutStatus {
        created,
        ready,
        accepted
    }

    /**
    * Тип отчета сгенерированного по выплате
    **/
    enum PayoutReportType {
        /* АБС НКО */
        ABS,
        /* 1C */
        OneS
    }

    /**
    * Описание выплаты
    **/
    struct Payout {
       1: required PayoutID id
       2: required PayoutStatus status
       3: required string from_time
       4: required string to_time
       5: required string abs_status
       6: required string ones_status
       7: optional string abs_report
       8: optional string ones_report
       9: optional string created_at
    }
    /**
    * Информация о платаже сохраняемая в Shiter-e
    **/
    struct PayoutPaymentInfo {
        1: required string id
        2: required string invoice_id
        3: required string payment_id
        4: required string party_id
        5: required string shop_id
        6: required string amount
        7: required string provider_comission
        8: required string rbk_comission
        9: optional string payout_id
        10: optional string created_at
    }

    /**
    * Атрибуты поиска выплат
    **/
    struct PayoutSearchCriteria{
       1: optional PayoutStatus status
       2: optional TimeRange timeRange
       3: optional list<PayoutID> payoutIDs
    }

    /**
    * Сервис для вывода платажей из системы
    **/
    service Shitter {
       /**
       * Сгенерировать и отправить по почте выгрузку за указанный промежуток времени
       * возвращает идентификатор сгенерированной выплаты.
       * ?? payoutMEthoID? ?
       **/
       PayoutID GeneratePayout (1: TimeRange timeRange) throws (1: base.InvalidRequest ex1)
       /**
       * Перегенерирует отчет о выплате только по бизнес атрибутам и отправляет письмо с отчетом.
       * Суммы остаются не изменными
       **/
       PayoutID RegenerateReport(1: PayoutID payoutID, 2: PayoutReportType reportType )
       /**
       * Подтвердить загрузку выплаты в ABS
       **/
       bool AcceptAbsPayout(1: PayoutID payoutID)
       /**
       * Подтвердить загрузку выплаты в OneS
       **/
       bool AcceptOneSPayout(1: PayoutID payoutID)
       /**
       * Возвращает список Payout-ов согласно запросу поиска.
       * Payout подтвержденный и АБС и 1С переводется в статус выплачен
       **/
       list<Payout> GetPayouts(1: PayoutSearchCriteria searchCriteria)
       /**
       *  Получить список платежей попавших в Payout
       **/
       list<PayoutPaymentInfo> GetPayments(1: PayoutID payoutID)
    }
