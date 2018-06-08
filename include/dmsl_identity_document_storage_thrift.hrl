-ifndef(dmsl_identity_document_storage_thrift_included__).
-define(dmsl_identity_document_storage_thrift_included__, yeah).

-include("dmsl_base_thrift.hrl").



%% struct 'RussianDomesticPassport'
-record('ident_doc_store_RussianDomesticPassport', {
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
-record('ident_doc_store_RussianRetireeInsuranceCertificate', {
    'number' :: binary()
}).

%% exception 'IdentityDocumentNotFound'
-record('ident_doc_store_IdentityDocumentNotFound', {}).

-endif.
