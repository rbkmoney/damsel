/**
 * Автомат графа финансовых потоков
 */

namespace java com.rbkmoney.damsel.cash_flow
namespace erlang cash_flow

include "base.thrift"
include "domain.thrift"

/** Предметная область */

typedef domain.AccountID AccountID
typedef domain.MerchantCashFlowAccount MerchantCashFlowAccount
typedef domain.ProviderCashFlowAccount ProviderCashFlowAccount
typedef domain.SystemCashFlowAccount SystemCashFlowAccount
typedef domain.ExternalCashFlowAccount ExternalCashFlowAccount

struct CashFlow {
    1: required list<CashFlowTransaction> transactions
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
    2: ProviderTransactionAccount provider
    3: SystemTransactionAccount system
    4: ExternalTransactionAccount external
}

struct MerchantTransactionAccount {
    1: required MerchantCashFlowAccount account_type
    /**
     * Идентификатор бизнес-объекта, владельца аккаунта.
     */
    2: required MerchantTransactionAccountOwner account_owner
}

struct MerchantTransactionAccountOwner {
    1: required domain.PartyID party_id
    2: required domain.ShopID shop_id
}

struct ProviderTransactionAccount {
    1: required ProviderCashFlowAccount account_type
    /**
     * Идентификатор бизнес-объекта, владельца аккаунта.
     */
    2: required ProviderTransactionAccountOwner account_owner
}

struct ProviderTransactionAccountOwner {
    1: required domain.ProviderRef provider_ref
    2: required domain.ProviderTerminalRef terminal_ref
}

struct SystemTransactionAccount {
    1: required SystemCashFlowAccount account_type
}

struct ExternalTransactionAccount {
    1: required ExternalCashFlowAccount account_type
}
