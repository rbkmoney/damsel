typedef binary MasterKeyShare;
typedef list<MasterKeyShare> MasterKeyShares;
typedef string Token
typedef string Session

enum BankCardPaymentSystem {
    visa,
    mastercard
}

struct CardData {
	1: required string pan
	2: required i8 month
	3: required i8 year
	4: required string cardholder_name
	5: required string cvv
}

struct BankCard {
    1: required Token token
    2: required BankCardPaymentSystem payment_system
    3: required string bin
    4: required string masked_pan
}

struct putCardDataReturn {
	1: required BankCard bank_card
	2: required Session session
}

struct UnlockStatus {
	1: bool unlocked
	2: i16 more_keys_needed
}

exception NoKeyring {}

exception Locked {}

exception NotFound {}

exception KeyringExists {}

service CdsAdmin {
	MasterKeyShares init (1: i16 threshold, 2: i16 num_shares) throws (1: KeyringExists exists)
	UnlockStatus unlock (1: MasterKeyShare key_share) throws (1: NoKeyring no_keyring)
	void lock () throws ()
	void rotate () throws (1: Locked locked)
}

service Cds {
	CardData getCardData (1: Token token) throws (1: NotFound not_found, 2: Locked locked)
	BankCard putCardData (1: CardData card_data) throws (1: Locked locked)
}
