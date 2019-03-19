include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.cds

/** Часть мастер-ключа */
typedef binary MasterKeyShare;

typedef list<MasterKeyShare> MasterKeyShares;

/** Публичный ключ и кому он принадлежит */
struct PublicKey {
    /** Уникальный идентификатор */
    1: required string id
    /** Владелец ключа */
    2: required string owner
    /** Публичный ключ */
    3: required string key
}

typedef list<PublicKey> PublicKeys

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

/** Код проверки подлинности банковской карты */
struct CardSecurityCode {
    /** Код верификации [0-9]{3,4} */
    1: required string value
}

/** Данные, необходимые для авторизации по 3DS протоколу */
struct Auth3DS {
    /** Криптограмма для проверки подлинности */
    1: required string cryptogram
    /** Тип транзакции */
    2: optional string eci
}

/** Данные, необходимые для проверки подлинности банковской карты */
union AuthData {
    1: CardSecurityCode card_security_code
    2: Auth3DS auth_3ds
}

/** Данные сессии */
struct SessionData {
    1: required AuthData auth_data
}

struct Success {}

union KeyringOperationStatus {
    /** Успешно. */
    1: Success success
    /** Сколько частей ключа нужно еще ввести, чтобы провести манипуляцию над Keyring. */
    2: i16 more_keys_needed
}

exception InvalidCardData {
    1: optional string reason
}

exception CardDataNotFound {}

exception SessionDataNotFound {}

exception NoKeyring {}

exception KeyringLocked {}

exception KeyringExists {}

exception NothingToValidate {}

exception WrongMasterKey {}

exception FailedMasterKeyRecovery {}

/** Интерфейс для администраторов */
service Keyring {

    /** Создать новый кейринг
     *  threshold - минимально необходимое количество ключей для восстановления мастер ключа
     *  public_keys - публичные ключи которыми будут подписываться MasterKeyShare
     */
    MasterKeyShares Init (1: i16 threshold, 2: PublicKeys public_keys) throws (1: KeyringExists exists)

    /** Валидирует и завершает операцию над Keyring
     *  Вызывается после Init и Rekey (CDS-25)
     *  key_share - MasterKeyShare в расшифрованном виде
     */
    KeyringOperationStatus Validate (1: MasterKeyShare key_share)
        throws (1: NoKeyring no_keyring,
                2: NothingToValidate no_validate,
                3: WrongMasterKey wrong_masterkey,
                4: FailedMasterKeyRecovery failed_to_recover)

    /** Предоставить часть мастер-ключа для расшифровки кейринга.
     *  Необходимо вызвать с разными частами мастер столько раз, сколько было указано в качестве
     *  параметра threshold при создании кейринга
     */
    KeyringOperationStatus Unlock (1: MasterKeyShare key_share) throws (1: NoKeyring no_keyring)

    /** Зашифровать кейринг */
    void Lock () throws (1: NoKeyring no_keyring)

    /** Добавить новый ключ в кейринг
     *  Предоставить часть мастер-ключа для зашифровки нового инстанса кейринга.
     *  См. `Unlock`
     */
    KeyringOperationStatus Rotate (1: MasterKeyShare key_share)
        throws (1: KeyringLocked locked,
                2: NoKeyring no_keyring,
                3: WrongMasterKey wrong_masterkey,
                4: FailedMasterKeyRecovery failed_to_recover)

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
    SessionData GetSessionData (1: domain.PaymentSessionID session_id)
        throws (1: SessionDataNotFound not_found)

    /** Сохранить карточные данные */
    PutCardDataResult PutCardData (1: CardData card_data, 2: SessionData session_data)
        throws (1: InvalidCardData invalid)

}
