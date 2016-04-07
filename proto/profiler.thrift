/**
 * Определения структур и сервисов для работы с профилями
 */

include "base.thrift"

namespace java com.rbkmoney.profiler.thrift

/**
 * Уникальный идентификатор
 */
typedef string Uuid

/** Данные для авторизации */
struct LoginPass {
    /** Логин, в качестве которого принимаем e-mail */
    1: string login;
    /** Пароль */
    2: string password;
}

/** Данные необходимые для идентификации */
union Credentials {
    /** Данные для авторизации */
    1: LoginPass loginPass;
}

/**
 * Набор данных по профилю
 */
struct Profile {
    /** Имя */
    1: optional string firstName;
    /** Фамилия */
    2: optional string lastName;
    /** Mobile phone */
    3: optional string mobilePhone;
}

/**
 * Запрос на создание профиля
 */
struct CreateProfileRequest {
    /** Набор данных по профилю */
    1: required Profile profile;
    /** Данные для авторизации */
    2: required LoginPass loginPass;
}

/**
 * Ответ на создание профиля
 * Возвращает уникальный идентификатор присвоенный профилю после его создания
 */
struct CreateProfileResponse {
    /** Уникальный номер присвоенный профилю в случае успешного создания */
    1: required Uuid uuid;
}

/**
 * Запрос на обновление профиля
 */
struct UpdateProfileRequest {
    /** Набор данных по профилю */
    1: required Profile profile;
    /** Уникальный номер присвоенный профилю */
    2: required Uuid uuid;
}

/**
 * Ответ на обновление профиля
 */
struct UpdateProfileResponse {
    /** Уникальный номер присвоенный профилю в случае успешного обновления */
    1: required Uuid uuid;
}

/**
 * Запрос на получение токена
 */
struct GenereateAuthTokenRequest {
    /** Набор данных необходимых для получения токена */
    1: required Credentials credentials;
}

/**
 * Ответ на запрос получения токена
 */
struct GenereateAuthTokenResponse {
    /** Auth Token */
    1: required string authToken;
}

/** Исключение, сигнализирующее о том, что создаваемый профиль уже существует */
exception ProfileExists {
    /** Ошибка, которая привела к возникновению исключения */
    1: required base.Error error;
}

/** Исключение, сигнализирующее о том, что профиль не существует */
exception ProfileNotFound {
    /** Ошибка, которая привела к возникновению исключения */
    1: required base.Error error;
}

/**
 * Сервис управления профилями и токенами
 */
service ProfileService {

    /**
     * Создать новый профиль
     */
    CreateProfileResponse createProfile(1:CreateProfileRequest createProfileRequest) throws (1: ProfileExists pex),

    /**
     * Обновить профиль
     */
    UpdateProfileResponse updateProfile(1:UpdateProfileRequest updateProfileRequest) throws (1: ProfileNotFound pex),

    /**
     * Получить токен
     */
    GenereateAuthTokenResponse generateAuthToken(1:GenereateAuthTokenRequest genereateAuthTokenRequest) throws (1: ProfileNotFound pex),
}
