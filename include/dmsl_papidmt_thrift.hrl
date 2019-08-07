-ifndef(dmsl_papidmt_thrift_included__).
-define(dmsl_papidmt_thrift_included__, yeah).

-include("dmsl_domain_config_thrift.hrl").



%% struct 'HistoryWrapper'
-record('papidmt_HistoryWrapper', {
    'history' :: dmsl_domain_config_thrift:'History'()
}).

-endif.
