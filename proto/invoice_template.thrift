/**
 * Управление шаблонами инвойсов.
 */

include "base.thrift"
include "domain.thrift"
include "payment_processing.thrift"

namespace java com.rbkmoney.damsel.invoice_template
namespace erlang inv_tpl

typedef domain.InvoiceTemplateID TemplateID

/**
 * Шаблон инвойса.
 * Согласно https://github.com/rbkmoney/coredocs/blob/0a5ae1a79f977be3134c3b22028631da5225d407/docs/domain/entities/invoice.md#шаблон-инвойса
 */
struct Template {
    1: required TemplateID id
    2: required domain.PartyID owner_id
    4: required TemplateStatus status
    4: optional TemplateSpecs specs
}

union TemplateStatus {
    1: TemplateValid valid
    2: TemplateInvalid invalid
}

struct TemplateValid {}
struct TemplateInvalid { 1: required TemplateSpecs invalid_specs }

typedef set<TemplateSpec> TemplateSpecs

struct TemplateSpec {
    1: required bool configurable
    2: required domain.InvoiceTemplateParam p
}

exception UserInvoiceTemplateNotFound {}
exception InvalidCurrencyRef { 1: required domain.CurrencyRef currency }

// Service

typedef payment_processing.UserInfo UserInfo
typedef payment_processing.InvalidUser InvalidUser
typedef payment_processing.PartyNotFound PartyNotFound
typedef payment_processing.ShopNotFound ShopNotFound
typedef payment_processing.InvalidPartyStatus InvalidPartyStatus
typedef payment_processing.InvalidShopStatus InvalidShopStatus

service InvoiceTemplate {

    TemplateID Create (1: UserInfo user, 2: domain.PartyID party_id, 3: TemplateSpecs specs
    )
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: InvalidPartyStatus ex3,
            4: ShopNotFound ex4,
            5: InvalidShopStatus ex5,
            6: InvalidCurrencyRef ex6,
            7: base.InvalidRequest ex7
        )

    Template Get (1: UserInfo user, 2: domain.PartyID party_id, 3: TemplateID id)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: UserInvoiceTemplateNotFound ex3,
            4: InvalidPartyStatus ex4
        )

    Template Update (1: UserInfo user, 2: domain.PartyID party_id, 3: TemplateID id, 4: TemplateSpecs new_specs)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: UserInvoiceTemplateNotFound ex3,
            4: InvalidPartyStatus ex4,
            5: ShopNotFound ex5,
            6: InvalidShopStatus ex6,
            7: InvalidCurrencyRef ex7,
            8: base.InvalidRequest ex8
        )
    void Delete (1: UserInfo user, 2: domain.PartyID party_id, 3: TemplateID id)
        throws (
            1: InvalidUser ex1,
            2: PartyNotFound ex2,
            3: UserInvoiceTemplateNotFound ex3,
            4: InvalidPartyStatus ex4
        )
}
