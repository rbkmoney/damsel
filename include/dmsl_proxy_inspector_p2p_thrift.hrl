-ifndef(dmsl_proxy_inspector_p2p_thrift_included__).
-define(dmsl_proxy_inspector_p2p_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_domain_thrift.hrl").



%% struct 'Context'
-record('p2p_insp_Context', {
    'info' :: dmsl_proxy_inspector_p2p_thrift:'TransferInfo'(),
    'options' = #{} :: dmsl_domain_thrift:'ProxyOptions'() | undefined
}).

%% struct 'TransferInfo'
-record('p2p_insp_TransferInfo', {
    'transfer' :: dmsl_proxy_inspector_p2p_thrift:'Transfer'()
}).

%% struct 'Transfer'
-record('p2p_insp_Transfer', {
    'id' :: dmsl_base_thrift:'ID'(),
    'identity' :: dmsl_proxy_inspector_p2p_thrift:'Identity'(),
    'created_at' :: dmsl_base_thrift:'Timestamp'(),
    'sender' :: dmsl_proxy_inspector_p2p_thrift:'Payer'(),
    'receiver' :: dmsl_proxy_inspector_p2p_thrift:'Payer'(),
    'cost' :: dmsl_domain_thrift:'Cash'()
}).

%% struct 'Identity'
-record('p2p_insp_Identity', {
    'id' :: dmsl_base_thrift:'ID'()
}).

%% struct 'Raw'
-record('p2p_insp_Raw', {
    'payer' :: dmsl_domain_thrift:'Payer'()
}).

%% struct 'InspectResult'
-record('p2p_insp_InspectResult', {
    'scores' :: #{dmsl_domain_thrift:'ScoreID'() => atom()}
}).

-endif.
