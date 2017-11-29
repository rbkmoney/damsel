-ifndef(dmsl_walker_thrift_included__).
-define(dmsl_walker_thrift_included__, yeah).

-include("dmsl_domain_thrift.hrl").
-include("dmsl_base_thrift.hrl").
-include("dmsl_payment_processing_thrift.hrl").



%% struct 'PartyModificationUnit'
-record('walker_PartyModificationUnit', {
    'modifications' :: [dmsl_payment_processing_thrift:'PartyModification'()]
}).

%% struct 'ClaimInfo'
-record('walker_ClaimInfo', {
    'party_id' :: binary(),
    'claim_id' :: dmsl_walker_thrift:'ClaimID'(),
    'status' :: binary(),
    'assigned_user_id' :: binary() | undefined,
    'description' :: binary() | undefined,
    'reason' :: binary() | undefined,
    'modifications' :: dmsl_walker_thrift:'PartyModificationUnit'(),
    'revision' :: binary(),
    'created_at' :: binary(),
    'updated_at' :: binary()
}).

%% struct 'ClaimSearchRequest'
-record('walker_ClaimSearchRequest', {
    'party_id' :: binary() | undefined,
    'claim_id' :: ordsets:ordset(dmsl_walker_thrift:'ClaimID'()) | undefined,
    'contains' :: binary() | undefined,
    'assigned_user_id' :: binary() | undefined,
    'claim_status' :: binary() | undefined
}).

%% struct 'Comment'
-record('walker_Comment', {
    'text' :: binary(),
    'created_at' :: binary(),
    'user' :: dmsl_walker_thrift:'UserInformation'()
}).

%% struct 'Action'
-record('walker_Action', {
    'created_at' :: binary(),
    'user' :: dmsl_walker_thrift:'UserInformation'(),
    'type' :: atom(),
    'before' :: binary() | undefined,
    'after' :: binary()
}).

%% struct 'UserInformation'
-record('walker_UserInformation', {
    'userID' :: binary(),
    'user_name' :: binary() | undefined,
    'email' :: binary() | undefined
}).

-endif.
