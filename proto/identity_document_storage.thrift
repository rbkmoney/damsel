include "base.thrift"

namespace java com.rbkmoney.damsel.identity_document_storage
namespace erlang ident_doc_store

/**
 * Интерфейс для безопасного хранения идентификационных данных
 */

typedef string IdentityDocumentToken

union IdentityDocument {
    1: RussianDomesticPassport russian_domestic_passport
    2: RussianRetireeInsuranceCertificate russian_retiree_insurance_certificate
}

struct RussianDomesticPassport {
    1: required string series
    2: required string number
    /* Наименование выдавшего паспорт органа */
    3: required string issuer
    /* Код подразделения выдавшего паспорт органа */
    4: required string issuer_code
    /* Дата выдачи паспорта */
    5: required base.Timestamp issued_at
    /* Фамилия гражданина */
    6: required string family_name
    /* Имя гражданина */
    7: required string first_name
    /* Отчество гражданина */
    8: optional string patronymic
    /* Дата рождения гражданина */
    9: required base.Timestamp birth_date
    /* Место рождения гражданина */
    10: required string birth_place
}

/* Страховое свидетельство обязательного пенсионного страхования */
struct RussianRetireeInsuranceCertificate {
    /* СНИЛС */
    1: required string number
}

struct SafeIdentityDocumentData {
    1: required IdentityDocumentToken token
    2: required SafeIdentityDocument safe_identity_document
}

union SafeIdentityDocument {
    1: SafeRussianDomesticPassport safe_russian_domestic_passport
    2: SafeRussianRetireeInsuranceCertificate safe_russian_retiree_insurance_certificate
}

struct SafeRussianDomesticPassport {
    1: required string series_masked
    2: required string number_masked
    3: required string fullname_masked
}

struct SafeRussianRetireeInsuranceCertificate {
    1: required string number_masked
}

exception IdentityDocumentNotFound {}

service IdentityDocumentStorage {

    SafeIdentityDocumentData Put (1: IdentityDocument identity_document)

    IdentityDocument Get (1: IdentityDocumentToken token)
        throws (1: IdentityDocumentNotFound not_found)
}
