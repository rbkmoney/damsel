typedef binary MasterKeyShare;
typedef list<MasterKeyShare> MasterKeyShares;
typedef binary Token;
typedef binary CardData;

struct UnlockStatus {
	1: bool unlocked
	2: i16 more_keys_needed
}

exception NoKeyring {}

exception Locked {}

exception NotFound {}

exception KeyringExists {}

service Cds {
	MasterKeyShares init (1: i16 threshold, 2: i16 num_shares) throws (1: KeyringExists exists)
	UnlockStatus unlock (1: MasterKeyShare key_share) throws (1: NoKeyring no_keyring)
	void lock () throws ()
	void rotate () throws (1: Locked locked)

	CardData getCardData (1: Token token) throws (1: NotFound not_found, 2: Locked locked)
	Token putCardData (1: CardData card_data) throws (1: Locked locked)
}
