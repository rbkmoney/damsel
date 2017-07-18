include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.reports
namespace erlang reports

typedef base.Timestamp Timestamp
typedef base.InvalidRequest InvalidRequest
typedef base.ID ReportID
typedef base.ID FileID
typedef domain.PartyID PartyID
typedef domain.ShopID ShopID
typedef string URL

/**
* Ошибка превышения максимального размера блока данных, доступного для отправки клиенту.
* limit - текущий максимальный размер блока.
*/
exception DatasetTooBig {
    1: i32 limit;
}

/**
* Диапазон времени отчетов.
* from_time (inclusive) - начальное время.
* to_time (exclusive) - конечное время.
* Если from > to  - диапазон считается некорректным.
*/
struct ReportTimeRange {
    1: required Timestamp from_time;
    2: required Timestamp to_time;
}

struct ReportRequest {
    1: required PartyID party_id;
    2: required ShopID shop_id;
    3: required ReportTimeRange time_range;
}

/**
* Данные по отчету
* report_id - уникальный идентификатор отчета
* from_time, to_time - за какой период данный отчет
* report_type - тип отчета TODO стоит ли вывести типы отчетов в протокол?
* report_file_meta - данные по файлу отчета
* sign_file_meta - данные по файлу подписи
*/
struct Report {
    1: required ReportID report_id;
    2: required ReportTimeRange time_range;
    3: required string report_type;
    4: required FileMeta report_file_meta;
    5: optional FileMeta sign_file_meta;
}

/**
* Данные по файлу
* file_id - уникальный идентификатор файла
* md5 - md5 содержимого файла TODO нужно ли?
*/
struct FileMeta {
    1: required FileID file_id;
    2: optional string md5;
}

service Reporting {

  /**
  * Получить список отчетов по магазину за указанный промежуток времени
  * Возвращает список отчетов
  */
  list<Report> GetReports(1: ReportRequest request) throws (1: InvalidRequest ex1, 2: DatasetTooBig ex2)

  /**
  * Сгенерировать акт об оказании услуг по магазину за указанный промежуток времени TODO act of acceptance of services?
  * Возвращает идентификатор отчета
  */
  ReportID GenerateProvisionOfServiceReport(1: ReportRequest request) throws (1: InvalidRequest ex1)

  /**
  * Сгенерировать ссылку на файл
  * file_id - идентификатор файла
  * expired_at - время до которого ссылка будет считаться действительной
  * Возвращает presigned url
  */
  URL GeneratePresignedUrl(1: FileID file_id, 2: Timestamp expired_at) throws (1: InvalidRequest ex1)

}