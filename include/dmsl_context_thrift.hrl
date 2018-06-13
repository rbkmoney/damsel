-ifndef(dmsl_context_thrift_included__).
-define(dmsl_context_thrift_included__, yeah).

-include("dmsl_msgpack_thrift.hrl").



%% exception 'ObjectNotFound'
-record('ctx_ObjectNotFound', {}).

%% exception 'Forbidden'
-record('ctx_Forbidden', {}).

-endif.
