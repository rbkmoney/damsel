include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.payment_tool_provider
namespace erlang paytoolprv

struct WrappedPayment {
    1: required PaymentRequest request
}

union PaymentRequest {
    1: ApplePayRequest apple
    2: SamsungPayRequest samsung
}

struct ApplePayRequest {
    1: required string merchant_id
    2: required base.Content payment_token
}

struct SamsungPayRequest {
    1: required string service_id
    2: required string reference_id
}

struct UnwrappedPayment {
    1: required CardInfo card_info
    2: required CardPaymentData payment_data
    3: required PaymentDetails details

}

union PaymentDetails {
    1: ApplePayDetails apple
    2: SamsungPayDetails samsung
}

struct ApplePayDetails {
    1: required string transaction_id
    2: required domain.Amount amount
    3: required i16 currency_numeric_code
    4: required string device_id

}

struct SamsungPayDetails {
    1: optional string device_id
}

struct CardInfo {
    1: optional string display_name
    2: optional string cardholder_name
    3: optional string last4digits
    4: optional CardCalss card_class
    5: optional domain.BankCardPaymentSystem payment_system
}

enum CardCalss {
    credit,
    debit,
    prepaid,
    store,
    unknown
}

union CardPaymentData {
    1: TokenizedCard tokenized_card
}

struct TokenizedCard {
    1: required string dpan
    2: required ExpDate exp_date
    3: required AuthType auth_type
}

struct ExpDate {
    /** Месяц 1..12 */
    1: required i8 month
    /** Год 2015..∞ */
    2: required i16 year
}

union AuthType {
    1: Auth3DS auth_3ds
}

struct Auth3DS {
    1: required string cryptogram
    2: optional string eci_indicator
}

service PaymentToolProvier {
    UnwrappedPayment Unwrap(1: WrappedPayment payment) throws (1: base.InvalidRequest ex1)
}

