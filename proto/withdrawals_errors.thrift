namespace java com.rbkmoney.damsel.withdrawals.errors
namespace erlang wtherr

union WithdrawalFailure {
    1: AuthorizationFailure authorization_failed
}

union AuthorizationFailure {
    01: GeneralFailure    unknown
    03: GeneralFailure    operation_blocked
    04: GeneralFailure    account_not_found
    05: GeneralFailure    account_blocked
    06: GeneralFailure    account_stolen
    08: LimitExceeded     account_limit_exceeded
    09: LimitExceeded     provider_limit_exceeded
    10: DestinationReject destination_rejected
    11: GeneralFailure    security_policy_violated
    12: GeneralFailure    temporarily_unavailable
}

union LimitExceeded {
  1: GeneralFailure unknown
  2: GeneralFailure amount
  3: GeneralFailure number
}

union DestinationReject {
    2: GeneralFailure unknown
    1: BankCardReject bank_card_rejected
}

union BankCardReject {
    1: GeneralFailure unknown
    2: GeneralFailure card_number_invalid
}

struct GeneralFailure {}
