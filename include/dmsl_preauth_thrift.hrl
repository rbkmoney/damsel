-ifndef(dmsl_preauth_thrift_included__).
-define(dmsl_preauth_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").



%% struct 'Granted'
-record('preauth_Granted', {
    'state' :: dmsl_preauth_thrift:'State'()
}).

%% struct 'Denied'
-record('preauth_Denied', {
    'state' :: dmsl_preauth_thrift:'State'()
}).

%% struct 'Unavailable'
-record('preauth_Unavailable', {
    'state' :: dmsl_preauth_thrift:'State'()
}).

%% struct 'State3DSecure'
-record('preauth_State3DSecure', {
    'eci' :: integer() | undefined,
    'cavv' :: binary() | undefined,
    'cavv_algo' :: integer() | undefined,
    'xid' :: binary() | undefined
}).

-endif.
