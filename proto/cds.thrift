include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.cds

/** Часть мастер-ключа */
typedef binary MasterKeyShare;

typedef list<MasterKeyShare> MasterKeyShares;

/** Дата экспирации */
struct ExpDate {
    /** Месяц 1..12 */
    1: required i8 month
    /** Год 2015..∞ */
    2: required i16 year
}

/** Открытые карточные данные (в отличие от domain.BankCard) */
struct CardData {
    /** Номер карточки без пробелов [0-9]{14,19} */
    1: required string pan
    2: required ExpDate exp_date
    /** Имя держателя */
    3: required string cardholder_name
}

struct SessionData {
    1: SessionState state
    /** возможно здесь будет ещё что-то */
}

/** возможные состояния сессии */
union SessionState {
    /** состояние в котором хранится код верификации [0-9]{3,4} */
    1: string cvv
    /** состояние когда cvv был удалён с помощью вызова InvalidateSession */
    2: base.Opaque invalidated
    /** возможно, здесь будет состояние для рекуррентных платежей */
}

struct PutCardDataResult {
    1: required domain.BankCard bank_card
    2: required domain.PaymentSession session
}

union UnlockStatus {
    1: base.Ok ok
    /** сколько частей ключа нужно еще ввести, чтобы расшифровать хранилище */
    2: i16 more_keys_needed
}

exception InvalidCardData {}

exception NoKeyring {}

exception KeyringLocked {}

exception KeyringExists {}

/** Интерфейс для администраторов */
service Keyring {
    /** Создать новый кейринг
     *  threshold - минимально необходимое количество ключей для восстановления мастер ключа
     *  num_shares - общее количество частей, на которое нужно разбить мастер-ключ
     */
    MasterKeyShares Init (1: i16 threshold, 2: i16 num_shares) throws (1: KeyringExists exists)
    /** Предоставить часть мастер-ключа для расшифровки кейринга.
     *  Необходимо вызвать с разными частами мастер столько раз, сколько было указано в качестве
     *  параметра threshold при создании кейринга
     */
    UnlockStatus Unlock (1: MasterKeyShare key_share) throws (1: NoKeyring no_keyring)
    /** Зашифровать кейринг */
    void Lock () throws ()
    /** Добавить новый ключ в кейринг */
    void Rotate () throws (1: KeyringLocked locked)
}

/** Интерфейс для приложений */
service Storage {
    /** Получить карточные данные */
    CardData GetCardData (1: domain.Token token)
        throws (1: base.NotFound not_found, 2: KeyringLocked locked)
    /** Получить сессию */
    SessionData GetSession (1: domain.PaymentSession session)
        throws (1: base.NotFound not_found, 2: KeyringLocked locked)
    /** Удалить cvv и оставить данные о состоянии сессии */
    void InvalidateSession(1: domain.PaymentSession session, 2: base.Opaque custom_data)
        throws (1: base.NotFound not_found, 2: KeyringLocked locked)
    /** Сохранить карточные данные */
    PutCardDataResult PutCardData (1: CardData card_data, 2: string cvv)
        throws (1: InvalidCardData invalid, 2: KeyringLocked locked)
}
