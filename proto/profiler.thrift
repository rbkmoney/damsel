/**
 * Определения структур и сервисов для работы с профилями
 */

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
    /** Данные для авторизации */
    1: required LoginPass loginPass;
    /** Имя */
    2: optional string firstName;
    /** Фамилия */
    3: optional string lastName;
    /** Mobile phone */
    4: optional string mobilePhone;
}

/**
 * Запрос на создание профиля
 */
struct CreateProfileRequest {
    1: required Profile profile;
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
    1: required Profile profile;
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
    1: required string authToken;
}

/**
 * Сервис управления профилями и токенами
 */
service ProfileService {

    /**
     * Создать новый профиль
     */
    CreateProfileResponse createProfile(1:CreateProfileRequest createProfileRequest),

    /**
     * Обновить профиль
     */
    UpdateProfileResponse updateProfile(1:UpdateProfileRequest updateProfileRequest),

    /**
     * Получить токен
     */
    GenereateAuthTokenResponse generateAuthToken(1:GenereateAuthTokenRequest genereateAuthTokenRequest),
}
