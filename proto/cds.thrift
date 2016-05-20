include "base.thrift"

typedef binary MasterKeyShare;
typedef list<MasterKeyShare> MasterKeyShares;
typedef string Token
typedef string Session

enum BankCardPaymentSystem {
    visa
    mastercard
}

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

struct BankCard {
    1: required Token token
    2: required BankCardPaymentSystem payment_system
    3: required string bin
    4: required string masked_pan
}

struct PutCardDataResult {
    1: required BankCard bank_card
    2: required Session session
}

union UnlockStatus {
    1: bool unlocked
    2: i16 more_keys_needed
}

exception Invalid {}

exception NoKeyring {}

exception Locked {}

exception KeyringExists {}

service Keyring {
    MasterKeyShares Init (1: i16 threshold, 2: i16 num_shares) throws (1: KeyringExists exists)
    UnlockStatus Unlock (1: MasterKeyShare key_share) throws (1: NoKeyring no_keyring)
    void Lock () throws ()
    void Rotate () throws (1: Locked locked)
}

service Storage {
    CardData GetCardData (1: Token token) throws (1: base.NotFound not_found, 2: Locked locked)
    CardData GetSessionCardData (1: Token token, 2: Session session)
        throws (1: base.NotFound not_found, 2: Locked locked)
    BankCard PutCardData (1: CardData card_data) throws (1: Locked locked, 2: Invalid invalid)
}
