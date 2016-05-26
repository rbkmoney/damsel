include "base.thrift"
include "domain.thrift"

typedef binary MasterKeyShare;
typedef list<MasterKeyShare> MasterKeyShares;

struct ExpDate {
    1: required i8 month
    2: required i16 year
}

struct CardData {
    1: required string pan
    2: required ExpDate exp_date
    3: required string cardholder_name
    4: required string cvv
}

struct PutCardDataResult {
    1: required domain.BankCard bank_card
    2: required domain.PaymentSession session
}

union UnlockStatus {
    1: base.Ok ok
    2: i16 more_keys_needed
}

exception InvalidCardData {}

exception NoKeyring {}

exception KeyringLocked {}

exception KeyringExists {}

service Keyring {
    MasterKeyShares Init (1: i16 threshold, 2: i16 num_shares) throws (1: KeyringExists exists)
    UnlockStatus Unlock (1: MasterKeyShare key_share) throws (1: NoKeyring no_keyring)
    void Lock () throws ()
    void Rotate () throws (1: KeyringLocked locked)
}

service Storage {
    CardData GetCardData (1: domain.Token token)
        throws (1: base.NotFound not_found, 2: KeyringLocked locked)
    CardData GetSessionCardData (1: domain.Token token, 2: domain.PaymentSession session)
        throws (1: base.NotFound not_found, 2: KeyringLocked locked)
    PutCardDataResult PutCardData (1: CardData card_data)
        throws (1: InvalidCardData invalid, 2: KeyringLocked locked)
}
