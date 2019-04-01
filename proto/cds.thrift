include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.cds

/** Часть мастер-ключа */
typedef binary MasterKeyShare;

typedef string ShareholderId;

/** Зашиврованная часть мастер-ключа и кому он предназначается */
struct EncryptedMasterKeyShare {
    // Уникальный ID, для однозначного определения владения
    1: required ShareholderId id
    // Неуникальный идентификатор с ФИО/email/etc владельца
    2: required string owner
    // Зашиврованный MasterKeyShare
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
    uninitialized
    validation
}

enum ReKeying {
    uninitialized
    confirmation
    postconfirmation
    validation
}

enum Rotation {
    uninitialized
    validation
}

enum Unlock {
    uninitialized
    validation
}

enum Status {
    // Global machine status
    not_initialized
    unlocked
    locked
}

enum ActivityType {
    initialization
    rekeying
    rotation
}

union Activity {
    1: Initialization initialization
    2: ReKeying rekeying
    3: Rotation rotation
    4: Unlock unlock
}

exception InvalidStatus {
    1: required Status status
}

exception InvalidActivity {
    1: required Activity activity
}

exception InvalidCardData {
    1: optional string reason
}

exception CardDataNotFound {}

exception SessionDataNotFound {}

exception InvalidArguments {
    1: optional string reason
}

exception OperationAborted {
    1: optional string reason
}

exception VerificationFailed {}

/** Интерфейс для администраторов */
service Keyring {

    /** Создать новый кейринг при начальном состоянии
     *  threshold - минимально необходимое количество ключей для восстановления мастер ключа
     */
    EncryptedMasterKeyShares StartInit (1: i16 threshold)
        throws (1: InvalidStatus invalid_status,
                2: InvalidActivity invalid_activity,
                3: InvalidArguments invalid_args)

    /** Валидирует и завершает операцию над Keyring
     *  Вызывается после Init и Rekey (CDS-25)
     *  key_share - MasterKeyShare в расшифрованном виде
     */
    KeyringOperationStatus ValidateInit (1: ShareholderId shareholder_id,
                                         2: MasterKeyShare key_share)
        throws (1: InvalidStatus invalid_status,
                2: InvalidActivity invalid_activity,
                3: VerificationFailed verification_failed,
                // Исключения ниже переводят машину в состояние `uninitialized`
                4: OperationAborted operation_aborted)

    /** Отменяет Init не прошедший валидацию и дает возможность запустить его заново */
    void CancelInit () throws (1: InvalidStatus invalid_status)

    /** Создать новый masterkey при наличии уже имеющегося
     *  threshold - минимально необходимое количество ключей для восстановления мастер ключа
     */
    void StartRekey (1: i16 threshold)
        throws (1: InvalidStatus invalid_status,
                2: InvalidActivity invalid_activity,
                3: InvalidArguments invalid_args)

    /** Подтвердить операцию создания нового masterkey
     *  key_share - старый masterkey share в количестве threshold
     */
    KeyringOperationStatus ConfirmReKey (1: MasterKeyShare key_share)
        throws (1: InvalidStatus invalid_status,
                2: InvalidActivity invalid_activity,
                3: OperationAborted operation_aborted)

    /** Начать валидацию операции и получить зашиврованные masterkey share */
    EncryptedMasterKeyShares StartReKeyValidation ()
        throws (1: InvalidStatus invalid_status,
                2: InvalidActivity invalid_activity)

    /** Провалидировать расшифрованными фрагментами нового ключа
     *  key_share - новый masterkey share в количестве num
     */
    KeyringOperationStatus ValidateReKey (1: MasterKeyShare key_share)
        throws (1: InvalidStatus invalid_status,
                2: InvalidActivity invalid_activity,
                3: OperationAborted operation_aborted)

    /** Отменить операцию создания нового masterkey */
    void CancelReKey () throws (1: InvalidStatus invalid_status)

    /** Получить состояние операции */
    Activity GetState (1: ActivityType activity_type)

    /** Начинает процесс блокировки */
    void StartUnlock ()
        throws (1: InvalidStatus invalid_status,
                2: InvalidActivity invalid_activity)

    /** Предоставить часть мастер-ключа для расшифровки кейринга.
     *  Необходимо вызвать с разными частами мастер столько раз, сколько было указано в качестве
     *  параметра threshold при создании кейринга
     */
    KeyringOperationStatus ValidateUnlock (1: ShareholderId shareholder_id,
                                           2: MasterKeyShare key_share)
        throws (1: InvalidStatus invalid_status,
                2: InvalidActivity invalid_activity,
                3: VerificationFailed verification_failed,
                4: OperationAborted operation_aborted)

    /** Отменяет процесс блокировки */
    void CancelUnlock () throws (1: InvalidStatus invalid_status)

    /** Зашифровать кейринг */
    void Lock () throws (1: InvalidStatus invalid_status)

    /** Начать процесс добавления нового ключа в кейринг */
    void StartRotate ()
        throws (1: InvalidStatus invalid_status,
                2: InvalidActivity invalid_activity)

    /*  Предоставить часть мастер-ключа для зашифровки нового инстанса кейринга.
     *  См. `Unlock`
     */    
    KeyringOperationStatus ValidateRotate (1: ShareholderId shareholder_id,
                                           2: MasterKeyShare key_share)
        throws (1: InvalidStatus invalid_status,
                2: InvalidActivity invalid_activity,
                3: VerificationFailed verification_failed,
                4: OperationAborted operation_aborted)

    /** Отменяет процесс добавления нового ключа в кейринг */
    void CancelRotate () throws (1: InvalidStatus invalid_status)
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
