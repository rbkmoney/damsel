-ifndef(dmsl_geo_ip_thrift_included__).
-define(dmsl_geo_ip_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_domain_thrift.hrl").


-define(GEO_IP_GEO_ID_UNKNOWN, -1).

-define(GEO_IP_UNKNOWN, <<"UNKNOWN">>).


%% struct 'LocationInfo'
-record('geo_ip_LocationInfo', {
    'city_geo_id' :: dmsl_geo_ip_thrift:'GeoID'(),
    'country_geo_id' :: dmsl_geo_ip_thrift:'GeoID'(),
    'raw_response' :: binary() | undefined
}).

%% struct 'SubdivisionInfo'
-record('geo_ip_SubdivisionInfo', {
    'level' :: integer(),
    'subdivision_name' :: binary()
}).

%% struct 'GeoIDInfo'
-record('geo_ip_GeoIDInfo', {
    'country_name' :: binary(),
    'subdivisions' :: ordsets:ordset(dmsl_geo_ip_thrift:'SubdivisionInfo'()) | undefined,
    'city_name' :: binary() | undefined
}).

-endif.
