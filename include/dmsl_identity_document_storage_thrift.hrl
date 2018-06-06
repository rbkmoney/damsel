-ifndef(dmsl_identity_document_storage_thrift_included__).
-define(dmsl_identity_document_storage_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").



%% struct 'RussianDomesticPassport'
-record('id_storage_RussianDomesticPassport', {
    'series' :: binary(),
    'number' :: binary(),
    'issuer' :: binary(),
    'issuer_code' :: binary(),
    'issued_at' :: dmsl_base_thrift:'Timestamp'(),
    'family_name' :: binary(),
    'first_name' :: binary(),
    'patronymic' :: binary() | undefined,
    'birth_date' :: dmsl_base_thrift:'Timestamp'(),
    'birth_place' :: binary()
}).

%% struct 'RussianRetireeInsuranceCertificate'
-record('id_storage_RussianRetireeInsuranceCertificate', {
    'number' :: binary()
}).

%% struct 'SafeIdentityDocumentData'
-record('id_storage_SafeIdentityDocumentData', {
    'token' :: dmsl_identity_document_storage_thrift:'IdentityDocumentToken'(),
    'safe_identity_document' :: dmsl_identity_document_storage_thrift:'SafeIdentityDocument'()
}).

%% struct 'SafeRussianDomesticPassport'
-record('id_storage_SafeRussianDomesticPassport', {
    'series_masked' :: binary(),
    'number_masked' :: binary(),
    'fullname_masked' :: binary()
}).

%% struct 'SafeRussianRetireeInsuranceCertificate'
-record('id_storage_SafeRussianRetireeInsuranceCertificate', {
    'number_masked' :: binary()
}).

%% exception 'IdentityDocumentNotFound'
-record('id_storage_IdentityDocumentNotFound', {}).

-endif.
