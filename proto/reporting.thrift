include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.reports
namespace erlang reports

typedef base.Timestamp Timestamp
typedef base.InvalidRequest InvalidRequest
typedef i64 ReportID
typedef base.ID FileID
typedef domain.PartyID PartyID
typedef domain.ShopID ShopID
typedef string URL

/**
* Ошибка превышения максимального размера блока данных, доступного для отправки клиенту.
* limit - текущий максимальный размер блока.
*/
exception DatasetTooBig {
    1: i32 limit
}

exception PartyNotFound {}
exception ShopNotFound {}
exception ReportNotFound {}
exception FileNotFound {}

/**
* Диапазон времени отчетов.
* from_time (inclusive) - начальное время.
* to_time (exclusive) - конечное время.
* Если from > to  - диапазон считается некорректным.
*/
struct ReportTimeRange {
    1: required Timestamp from_time
    2: required Timestamp to_time
}

struct ReportRequest {
    1: required PartyID party_id
    2: required ShopID shop_id
    3: required ReportTimeRange time_range
}

/**
* Статусы отчета
*/
enum ReportStatus {
    // в обработке
    pending,
    // создан
    created
}

/**
* Данные по отчету
* report_id - уникальный идентификатор отчета
* time_range - за какой период данный отчет
* report_type - тип отчета
* files - файлы данного отчета (к примеру сам отчет и его подпись)
*/
struct Report {
    1: required ReportID report_id
    2: required ReportTimeRange time_range
    3: required Timestamp created_at
    4: required ReportType report_type
    5: required ReportStatus status
    6: optional list<FileMeta> files
}

/**
* Данные по файлу
* file_id - уникальный идентификатор файла
* signatures - сигнатуры файла (md5, sha256)
*/
struct FileMeta {
    1: required FileID file_id
    2: required string filename
    3: optional Signature signature
}

/**
* Cигнатуры файла
*/
struct Signature {
    1: required string md5
    2: required string sha256
}

/**
* Типы отчетов
*/
enum ReportType {
    // Акт об оказании услуг
    provision_of_service,
    // Реестр платежей
    payment_registry
}

service Reporting {

  /**
  * Получить список отчетов по магазину за указанный промежуток времени с фильтрацией по типу
  * В случае если список report_types пустой, фильтрации по типу не будет
  * Возвращает список отчетов или пустой список, если отчеты по магазину не найдены
  *
  * InvalidRequest, если промежуток времени некорректен
  * DatasetTooBig, если размер списка превышает допустимый лимит
  */
  list<Report> GetReports(1: ReportRequest request, 2: list<ReportType> report_types) throws (1: DatasetTooBig ex1, 2: InvalidRequest ex2)

  /**
  * Сгенерировать отчет с указанным типом по магазину за указанный промежуток времени
  * Возвращает идентификатор отчета
  *
  * PartyNotFound, если party не найден
  * ShopNotFound, если shop не найден
  * InvalidRequest, если промежуток времени некорректен
  */
  ReportID GenerateReport(1: ReportRequest request, 2: ReportType report_type) throws (1: PartyNotFound ex1, 2: ShopNotFound ex2, 3: InvalidRequest ex3)

  /**
  * Запрос на получение отчета
  *
  * ReportNotFound, если отчет не найден
  */
  Report GetReport(1: PartyID party_id, 2: ShopID shop_id, 3: ReportID report_id) throws (1: ReportNotFound ex1)

  /**
  * Сгенерировать ссылку на файл
  * file_id - идентификатор файла
  * expires_at - время до которого ссылка будет считаться действительной
  * Возвращает presigned url
  *
  * FileNotFound, если файл не найден
  * InvalidRequest, если expires_at некорректен
  */
  URL GeneratePresignedUrl(1: FileID file_id, 2: Timestamp expires_at) throws (1: FileNotFound ex1, 2: InvalidRequest ex2)

}
