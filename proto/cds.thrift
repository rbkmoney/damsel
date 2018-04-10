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
    3: optional string cardholder_name
    /** Deprecated */
    /** Код верификации [0-9]{3,4} */
    4: optional string cvv
}

struct PutCardDataResult {
    1: required domain.BankCard bank_card
    2: required domain.PaymentSessionID session_id
}

/** Данные сессии */
struct SessionData {
    1: required VerificationData verification_data
}

/** Данные, необходимые для проверки подлинности транзакции */
union VerificationData {
    /** Код верификации [0-9]{3,4} */
    1: string cvv
    2: PaymentToken payment_token
}

/** Данные верификации платежного токена */
struct PaymentToken {
    /** Криптограмма для проверки подлинности */
    1: required string cryptogram
    /** Тип транзакции */
    2: optional string eci
}

struct Unlocked {}

union UnlockStatus {
    /** Успешно. */
    1: Unlocked unlocked
    /** Сколько частей ключа нужно еще ввести, чтобы расшифровать хранилище. */
    2: i16 more_keys_needed
}

exception InvalidCardData {}

exception CardDataNotFound {}

exception SessionDataNotFound {}

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
    void Lock () throws (1: NoKeyring no_keyring)

    /** Добавить новый ключ в кейринг */
    void Rotate () throws (1: KeyringLocked locked, 2: NoKeyring no_keyring)

}

/**
 * Интерфейс для приложений
 *
 * При недоступности (отсутствии или залоченности) кейринга сервис сигнализирует об этом с помощью
 * woody-ошибки `Resource Unavailable`.
 */
service Storage {

    /** Получить карточные данные без CVV */
    CardData GetCardData (1: domain.Token token)
        throws (1: CardDataNotFound not_found)

    /** Получить карточные данные c CVV */
    CardData GetSessionCardData (1: domain.Token token, 2: domain.PaymentSessionID session_id)
        throws (1: CardDataNotFound not_found)

    /** Получить данные сессии */
    SessionData GetSessionData (1: domain.Token token, 2: domain.PaymentSessionID session_id)
        throws (1: SessionDataNotFound not_found)

    /** Сохранить карточные данные */
    PutCardDataResult PutCardData (1: CardData card_data, 2: SessionData session_data)
        throws (1: InvalidCardData invalid)

}
