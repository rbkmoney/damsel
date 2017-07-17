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

struct Report {
    1: required ReportID report_id;
    2: required Timestamp from_time;
    3: required Timestamp to_time;
    4: required string report_type;
    5: required FileMeta report_file_meta;
    6: optional FileMeta sign_file_meta;
}

struct FileMeta {
    1: required FileID file_id;
    2: required string bucket_name;
    3: optional string md5;
}

service Reports {

  list<Report> GetReports(1: ReportRequest request) throws (1: InvalidRequest ex1, 2: DatasetTooBig ex2)

  void RegenerateReport(1: ReportID report_id) throws (1: InvalidRequest ex1)

}