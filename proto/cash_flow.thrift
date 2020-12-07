/**
 * Автомат графа финансовых потоков
 */

namespace java com.rbkmoney.damsel.cash_flow
namespace erlang cash_flow

include "base.thrift"
include "domain.thrift"

/** Предметная область */

typedef base.ID CashFlowID
typedef domain.AccountID AccountID
typedef domain.MerchantCashFlowAccount MerchantCashFlowAccount
typedef domain.ProviderCashFlowAccount ProviderCashFlowAccount
typedef domain.SystemCashFlowAccount SystemCashFlowAccount
typedef domain.ExternalCashFlowAccount ExternalCashFlowAccount
typedef domain.WalletCashFlowAccount WalletCashFlowAccount

struct CashFlow {
    1: required CashFlowID id
    2: required CashFlowSource source
    3: required base.Timestamp created_at
    4: required list<CashFlowTransaction> transactions
}

union CashFlowSource {
    1: PaymentCashFlowSource payment
    2: RefundCashFlowSource refund
}

struct PaymentCashFlowSource {
    1: required domain.InvoiceID invoice_id
    2: required domain.InvoicePaymentID payment_id
}

struct RefundCashFlowSource {
    1: required domain.InvoiceID invoice_id
    2: required domain.InvoicePaymentID payment_id
    3: required domain.InvoicePaymentRefundID refund_id
}

struct CashFlowTransaction {
    1: required CashFlowTransactionAccount source
    2: required CashFlowTransactionAccount destination
    3: required domain.Cash volume
    4: optional string details
}

struct CashFlowTransactionAccount {
    1: required TransactionAccount transaction_account
    2: required AccountID account_id
}

/** Счёт в графе финансовых потоков. */
union TransactionAccount {
    1: MerchantTransactionAccount merchant
    // 2: ProviderTransactionAccount provider
    // 3: SystemTransactionAccount system
    // 4: ExternalTransactionAccount external
}

struct MerchantTransactionAccount {
    1: required MerchantCashFlowAccount account_type
    /**
     * Идентификатор бизнес-объекта, владельца аккаунта.
     */
    2: required MerchantTransactionAccountOwner account_owner
}

union MerchantTransactionAccountOwner {
    1: domain.PartyID party_id
    2: domain.ShopID shop_id
}

/**
 * Один из возможных вариантов события, порождённого графом финансовых потоков.
 */
union Change {
    1: CashFlow created
}
