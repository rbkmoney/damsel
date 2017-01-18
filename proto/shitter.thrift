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
   * Pending - ожидается подтверждение от АБС и 1С
   * Done - средства переведены - выплата завершена
   **/
   union PayoutStatus {
       1: string pending
       2: string send
       3: string done
   }

   /**
   * Тип отчета сгенерированного по выплате
   **/
   union PayoutReportType {
       /* АБС НКО */
       1: string ABS
       /* 1C */
       2: string OneS
   }

   /**
   * Описание выплаты
   **/
   struct Payout {
       1: PayoutID id
       2: PayoutStatus status
       //todo: more fields
   }
   /**
   * Информация о платаже сохраняемая в Shiter-e
   **/
   struct PayoutPaymentInfo {}

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
