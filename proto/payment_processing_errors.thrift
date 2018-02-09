namespace java com.rbkmoney.damsel.payment_processing.errors
namespace erlang payprocerr

/**
 * TODO
 *  - RefundFailure
 *  - RecurrentsFailure
 *  - WalletReject
 *  - ForbiddenIssuerCountry
 *  - CashRegistrationFailure
 *  -
 */

/**
  *
  *
  * # Статическое представление ошибок. (динамическое представление — domain.Failure)
  *
  * При переводе из статического в динамические формат представления следующий.
  * В поле code пишется строковое представления имени варианта в union,
  * далее если это не структура, а юнион, то в поле sub пишется SubFailure,
  * который рекурсивно обрабатывается по аналогичном правилам.
  *
  * Текстовое представление аналогично через имена вариантов в юнион с разделителем в виде двоеточия.
  *
  *
  * ## Например
  *
  *
  * ### Статически типизированное представление
  *
  * ```
  * PaymentFailure{
  *     authorization_failure = AuthorizationFailed{
  *         payment_tool_reject = PaymentToolRejected{
  *             bank_card_reject = BankCardRejected{
  *                 invalid_cvv = GeneralFailure{}
  *             }
  *         }
  *     }
  * }
  * ```
  *
  *
  * ### Текстовое представление
  *
  * `authorization_failure:payment_tool_reject:bank_card_reject:invalid_cvv`
  *
  *
  * ### Динамически типизированное представление
  *
  * ```
  * domain.Failure{
  *     code = "authorization_failure",
  *     reason = "sngb error '87' — 'Invalid CVV'",
  *     sub = domain.SubFailure{
  *         code = "payment_tool_reject",
  *         sub = domain.SubFailure{
  *             code = "bank_card_reject",
  *             sub = domain.SubFailure{
  *                 code = "invalid_cvv"
  *             }
  *         }
  *     }
  * }
  * ```
  *
  */

union PaymentFailure {
    1: GeneralFailure      reject_by_inspector
    2: GeneralFailure      preauthorization_failure
    3: AuthorizationFailed authorization_failure
}

union AuthorizationFailed {
     1: GeneralFailure      unknown // "silent reject" / "do not honor" / ...
     2: GeneralFailure      merchant_blocked
     3: GeneralFailure      operation_blocked
     4: GeneralFailure      account_not_found
     5: GeneralFailure      account_blocked
     6: GeneralFailure      account_stolen
     7: GeneralFailure      insufficient_funds
     8: LimitExceeded       account_limit_exceeded
     9: LimitExceeded       provider_limit_exceeded
    10: PaymentToolRejected payment_tool_reject
}

union LimitExceeded {
  1: GeneralFailure unknown
  2: GeneralFailure amount
  3: GeneralFailure number
}

union PaymentToolRejected {
    1: BankCardRejected bank_card_reject
}

union BankCardRejected {
    2: GeneralFailure invalid_card_number
    3: GeneralFailure expired_card
    4: GeneralFailure invalid_card_holder
    5: GeneralFailure invalid_cvv
    6: GeneralFailure card_unsupported // ?
    7: GeneralFailure issuer_not_found // ?
}

struct GeneralFailure {}
