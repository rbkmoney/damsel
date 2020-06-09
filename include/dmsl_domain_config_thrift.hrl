-ifndef(dmsl_domain_config_thrift_included__).
-define(dmsl_domain_config_thrift_included__, yeah).

-include("dmsl_domain_thrift.hrl").



%% struct 'Head'
-record('Head', {}).

%% struct 'Snapshot'
-record('Snapshot', {
    'version' :: dmsl_domain_config_thrift:'Version'(),
    'domain' :: dmsl_domain_thrift:'Domain'()
}).

%% struct 'Commit'
-record('Commit', {
    'ops' :: [dmsl_domain_config_thrift:'Operation'()]
}).

%% struct 'InsertOp'
-record('InsertOp', {
    'object' :: dmsl_domain_thrift:'DomainObject'()
}).

%% struct 'UpdateOp'
-record('UpdateOp', {
    'old_object' :: dmsl_domain_thrift:'DomainObject'(),
    'new_object' :: dmsl_domain_thrift:'DomainObject'()
}).

%% struct 'RemoveOp'
-record('RemoveOp', {
    'object' :: dmsl_domain_thrift:'DomainObject'()
}).

%% struct 'VersionedObject'
-record('VersionedObject', {
    'version' :: dmsl_domain_config_thrift:'Version'(),
    'object' :: dmsl_domain_thrift:'DomainObject'()
}).

%% struct 'ObjectAlreadyExistsConflict'
-record('ObjectAlreadyExistsConflict', {
    'object_ref' :: dmsl_domain_thrift:'Reference'()
}).

%% struct 'ObjectNotFoundConflict'
-record('ObjectNotFoundConflict', {
    'object_ref' :: dmsl_domain_thrift:'Reference'()
}).

%% struct 'ObjectReferenceMismatchConflict'
-record('ObjectReferenceMismatchConflict', {
    'object_ref' :: dmsl_domain_thrift:'Reference'()
}).

%% struct 'ObjectsNotExistConflict'
-record('ObjectsNotExistConflict', {
    'object_refs' :: [dmsl_domain_config_thrift:'NonexistantObject'()]
}).

%% struct 'NonexistantObject'
-record('NonexistantObject', {
    'object_ref' :: dmsl_domain_thrift:'Reference'(),
    'referenced_by' :: [dmsl_domain_thrift:'Reference'()]
}).

%% struct 'ObjectReferenceCycle'
-record('ObjectReferenceCycle', {
    'cycle' :: [dmsl_domain_thrift:'Reference'()]
}).

%% exception 'VersionNotFound'
-record('VersionNotFound', {}).

%% exception 'ObjectNotFound'
-record('ObjectNotFound', {}).

%% exception 'OperationConflict'
-record('OperationConflict', {
    'conflict' :: dmsl_domain_config_thrift:'Conflict'()
}).

%% exception 'OperationInvalid'
-record('OperationInvalid', {
    'errors' :: [dmsl_domain_config_thrift:'OperationError'()]
}).

%% exception 'ObsoleteCommitVersion'
-record('ObsoleteCommitVersion', {}).

-endif.
