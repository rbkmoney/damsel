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
  * Формат динамического представления следующий
  * (по контексту применения известно, что это за операция, и её тип ошибки
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
  * При переводе из статического в динамический вид в поле code пишется строковое представления имени типа.
  * Далее если это не структура, а юнион, то в поле sub пишется SubFailure,
  * в поле code которой пишется строковое представления имени типа
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
    1: SingleOperationLimitExceeded single_operation_limit_exceeded
    2: DailyLimitExceeded           daily_limit_exceeded
    3: WeeklyLimitExceeded          weekly_limit_exceeded
    4: MonthlyLimitExceeded         monthly_limit_exceeded
    5: AttemptsNumberLimitExceeded  attempts_number_exceeded
}

struct SingleOperationLimitExceeded {}
struct DailyLimitExceeded           {}
struct WeeklyLimitExceeded          {}
struct MonthlyLimitExceeded         {}
struct AttemptsNumberLimitExceeded  {}


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
