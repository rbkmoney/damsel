/**
 * Определения структур и сервисов для работы с профилями
 */

include "base.thrift"

namespace java com.rbkmoney.profiler.thrift

/**
 * Набор данных по профилю
 */
struct Profile {
    /** Логин, может быть и e-mail-ом, но для внутренних сервисов, не обязательно e-mail */
    1: required string login;
    /** Пароль */
    2: required string password;
    /** E-mail */
    3: required string email;
    /** Имя */
    4: optional string firstName;
    /** Фамилия */
    5: optional string lastName;
}

/**
 * Запрос на создание профиля
 */
struct CreateProfileRequest {
    1: required Profile profile;
}

/**
 * Ответ на создание профиля.
 * Возвращает профиль со всеми входящими данными и uuid, который присвоен данному профилю
 */
struct CreateProfileResponse {
    /** Набор данных по профилю */
    1: required Profile profile;
    /** Уникальный номер присвоенный профилю в случае успешного создания */
    2: required string uuid;
}

/**
 * Запрос на получение токена
 */
struct GetProfileTokenRequest {
    /** Набор данных по профилю */
    1: required Profile profile;
    /** Название Realm в keycloack в который необходимо отправить запрос на получение токена */
    2: required string realm;
    /** Название публичного приложения в Keycloak через которое будем получать токен */
    3: required string clientId;
}

/**
 * Ответ на запрос получения токена
 */
struct GetProfileTokenResponse {
    1: required string token;
}

/**
 * Сервис управления профилями и токенами
 */
service ProfileService {

    /**
     * Создать новый профиль
     */
    CreateProfileResponse createProfile(1:CreateProfileRequest createProfileRequest) throws (1: base.Failure ex),

    /**
     * Получить токен профиля для последущего запроса по токену
     */
    GetProfileTokenResponse getProfileToken(1:GetProfileTokenRequest getProfileTokenRequest) throws (1: base.Failure ex),
}
