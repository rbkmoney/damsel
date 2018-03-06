-ifndef(dmsl_event_stock_thrift_included__).
-define(dmsl_event_stock_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_payment_processing_thrift.hrl").
-include("dmsl_payout_processing_thrift.hrl").



%% struct 'StockEvent'
-record('event_stock_StockEvent', {
    'source_event' :: dmsl_event_stock_thrift:'SourceEvent'(),
    'id' :: dmsl_event_stock_thrift:'EventID'() | undefined,
    'time' :: dmsl_event_stock_thrift:'Timestamp'() | undefined,
    'version' :: binary() | undefined
}).

%% struct 'RawEvent'
-record('event_stock_RawEvent', {
    'content' :: dmsl_base_thrift:'Content'()
}).

%% struct 'EventIDRange'
-record('event_stock_EventIDRange', {
    'from_id' :: dmsl_event_stock_thrift:'EventIDBound'(),
    'to_id' :: dmsl_event_stock_thrift:'EventIDBound'() | undefined
}).

%% struct 'EventTimeRange'
-record('event_stock_EventTimeRange', {
    'from_time' :: dmsl_event_stock_thrift:'EventTimeBound'(),
    'to_time' :: dmsl_event_stock_thrift:'EventTimeBound'() | undefined
}).

%% struct 'EventConstraint'
-record('event_stock_EventConstraint', {
    'event_range' :: dmsl_event_stock_thrift:'EventRange'(),
    'limit' :: integer()
}).

%% exception 'DatasetTooBig'
-record('event_stock_DatasetTooBig', {
    'limit' :: integer()
}).

%% exception 'NoStockEvent'
-record('event_stock_NoStockEvent', {}).

-endif.
