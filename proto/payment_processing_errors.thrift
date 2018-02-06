/**
 * TODO
 *  - RefundError
 *  - RecurrentsError
 *  - WalletError
 *  - ForbiddenIssuerCountry
 *  - CashRegistrationFailed
 *  -
 */

/**
  * Статическое представление ошибок.
  * (динамическое представление — domain.Failure)
  *
  * Формат динамического представления следующий.
  * При переводе из статического в динамический вид в поле code пишется строковое представления имени типа.
  * Далее если это не структура, а юнион, то в поле sub пишется SubFailure,
  * в поле code которой пишется строковое представления имени типа и т.д.
  *
  * Например (по контексту применения известно, что это за операция, и её тип ошибки
  *  в данном случае PaymentFailed):
  *
  * domain.Failure{
  *     code = "AuthorizationFailed",
  *     reason = "sngb error '87' — 'Invalid CVV'",
  *     sub = domain.SubFailure{
  *         code = "PaymentToolRejected",
  *         sub = domain.SubFailure{
  *             code = "BankCardRejected",
  *             sub = domain.SubFailure{
  *                 code = "InvalidCVV"
  *             }
  *         }
  *     }
  * }
  *
  */

union PaymentFailed {
    1: RejectedByInspector      rejected_by_inspector
    2: PreauthorizationFailed   preauthorization_failed
    3: AuthorizationFailed      authorization_failed
}

struct RejectedByInspector   {}
struct PreauthorizationFailed {}

union AuthorizationFailed {
    1: SilentReject             silent_reject
    2: MerchantBlocked          merchant_blocked
    3: OperationDisabled        operation_disabled
    4: AccountNotFound          account_not_found
    5: AccountBlocked           account_blocked
    6: AccountStolen            account_stolen
    7: InsufficientFunds        insufficient_funds
    8: LimitExceeded            limit_exceeded
    9: PaymentToolRejected      payment_tool_rejected
}

struct SilentReject      {}
struct MerchantBlocked   {}
struct OperationDisabled {}
struct AccountNotFound   {}
struct AccountBlocked    {}
struct AccountStolen     {}
struct InsufficientFunds {}


union LimitExceeded {
  1: AmountLimit amount_limit
  2: NumberLimit number_limit
}

union AmountLimit {
  1: Onetime onetime
  2: Daily   daily
  3: Weekly  weekly
  4: Monthly monthly
}

union NumberLimit {
  1: Onetime onetime
  2: Daily   daily
  3: Weekly  weekly
  4: Monthly monthly
}

struct Onetime {}
struct Daily   {}
struct Weekly  {}
struct Monthly  {}


union PaymentToolRejected {
    1: BankCardRejected bank_card_rejected
}

union BankCardRejected {
    1: InvalidCardNumber  invalid_card_number
    2: ExpiredCard        expired_card
    3: InvalidCardHolder  invalid_card_holder
    4: InvalidCVV         invalid_cvv
    5: CardUnsupported    card_unsupported // ?
    6: IssuerNotFound     issuer_not_found // ?
    7: RestictedCard      resticted_card   // ?
}

struct InvalidCardNumber {}
struct ExpiredCard       {}
struct InvalidCardHolder {}
struct InvalidCVV        {}
struct CardUnsupported   {}
struct IssuerNotFound    {}
struct RestictedCard     {}
