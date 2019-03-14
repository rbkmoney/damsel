-ifndef(dmsl_withdrawals_domain_thrift_included__).
-define(dmsl_withdrawals_domain_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").
-include("dmsl_domain_thrift.hrl").



%% struct 'Withdrawal'
-record('wthdm_Withdrawal', {
    'body' :: dmsl_domain_thrift:'Cash'(),
    'destination' :: dmsl_withdrawals_domain_thrift:'Destination'(),
    'sender' :: dmsl_withdrawals_domain_thrift:'Identity'() | undefined,
    'receiver' :: dmsl_withdrawals_domain_thrift:'Identity'() | undefined
}).

%% struct 'Identity'
-record('wthdm_Identity', {
    'id' :: dmsl_base_thrift:'ID'(),
    'documents' :: [dmsl_withdrawals_domain_thrift:'IdentityDocument'()] | undefined,
    'contact' :: [dmsl_withdrawals_domain_thrift:'ContactDetail'()] | undefined
}).

%% struct 'RUSDomesticPassport'
-record('wthdm_RUSDomesticPassport', {
    'token' :: binary(),
    'fullname_masked' :: binary() | undefined
}).

-endif.
