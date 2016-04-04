namespace java com.rbkmoney.profiler.thrift

struct User {
    1: required string login;
    2: required string password;
    3: required string email;
    4: optional string firstName;
    5: optional string lastName;
}

struct CreateUserRequest {
    1: required User user;
}

struct CreateUserResponse {
    1: required User user;
    2: required string userUuid;
}

struct GetUserTokenRequest {
    1: required User user;
    2: required string realm;
    3: required string clientId;
}

struct GetUserTokenResponse {
    1: required string token;
}

struct Error {
    1: required string code;
    2: optional string description;
}

exception Failure {
    1: required Error error;
}

service UserService {
    CreateUserResponse createUser(1:CreateUserRequest createUserRequest) throws (1: Failure ex),
    GetUserTokenResponse getUserToken(1:GetUserTokenRequest getUserTokenRequest) throws (1: Failure ex),
}
