-ifndef(dmsl_reporting_thrift_included__).
-define(dmsl_reporting_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_domain_thrift.hrl").



%% struct 'ReportTimeRange'
-record('reports_ReportTimeRange', {
    'from_time' :: dmsl_reporting_thrift:'Timestamp'(),
    'to_time' :: dmsl_reporting_thrift:'Timestamp'()
}).

%% struct 'ReportRequest'
-record('reports_ReportRequest', {
    'party_id' :: dmsl_reporting_thrift:'PartyID'(),
    'shop_id' :: dmsl_reporting_thrift:'ShopID'(),
    'time_range' :: dmsl_reporting_thrift:'ReportTimeRange'()
}).

%% struct 'Report'
-record('reports_Report', {
    'report_id' :: dmsl_reporting_thrift:'ReportID'(),
    'time_range' :: dmsl_reporting_thrift:'ReportTimeRange'(),
    'created_at' :: dmsl_reporting_thrift:'Timestamp'(),
    'report_type' :: dmsl_reporting_thrift:'ReportType'(),
    'status' :: atom(),
    'files' :: [dmsl_reporting_thrift:'FileMeta'()] | undefined
}).

%% struct 'FileMeta'
-record('reports_FileMeta', {
    'file_id' :: dmsl_reporting_thrift:'FileID'(),
    'filename' :: binary(),
    'signature' :: dmsl_reporting_thrift:'Signature'()
}).

%% struct 'Signature'
-record('reports_Signature', {
    'md5' :: binary(),
    'sha256' :: binary()
}).

%% exception 'DatasetTooBig'
-record('reports_DatasetTooBig', {
    'limit' :: integer()
}).

%% exception 'PartyNotFound'
-record('reports_PartyNotFound', {}).

%% exception 'ShopNotFound'
-record('reports_ShopNotFound', {}).

%% exception 'ReportNotFound'
-record('reports_ReportNotFound', {}).

%% exception 'FileNotFound'
-record('reports_FileNotFound', {}).

-endif.
