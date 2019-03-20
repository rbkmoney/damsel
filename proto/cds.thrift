include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.cds

/** Часть мастер-ключа */
typedef binary MasterKeyShare;

/** Зашиврованная часть мастер-ключа и кому он предназначается */
struct EncryptedMasterKeyShare {
    1: required string id
    2: required string owner
    3: required binary encrypted_share
}

typedef list<EncryptedMasterKeyShare> EncryptedMasterKeyShares;

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

enum Initialization {
    validation
}

struct Idling {}

struct Rotation {}

union Status {
    1: Initialization initialization
    2: Uninitialized uninitialized
    3: Idling idling
    4: Rotation rotation
}

exception InvalidStatus {
    1: required Status status
}

exception InvalidCardData {
    1: optional string reason
}

exception CardDataNotFound {}

exception SessionDataNotFound {}

exception NoKeyring {}

exception KeyringLocked {}

exception WrongMasterKey {}

exception FailedMasterKeyRecovery {}

exception InvalidArguments {
    1: optional string reason
}

/** Интерфейс для администраторов */
service Keyring {

    /** Создать новый кейринг при начальном состоянии
     *  threshold - минимально необходимое количество ключей для восстановления мастер ключа
     */
    EncryptedMasterKeyShares StartInit (1: i16 threshold)
        throws (1: InvalidStatus invalid_status,
                2: InvalidArguments invalid_args)

    /** Валидирует и завершает операцию над Keyring
     *  Вызывается после Init и Rekey (CDS-25)
     *  key_share - MasterKeyShare в расшифрованном виде
     */
    KeyringOperationStatus ValidateInit (1: MasterKeyShare key_share)
        throws (1: InvalidStatus invalid_status,
                // Исключения ниже переводят машину в состояние `uninitialized`
                2: WrongMasterKey wrong_masterkey,
                3: FailedMasterKeyRecovery failed_to_recover)

    /** Отменяет Init не прошедший валидацию и дает возможность запустить его заново */
    Success CancelInit () throws (1: InvalidStatus invalid_status)

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
        throws (1: InvalidStatus invalid_status,
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
