class AuthorizationConstants {
  static String authorizationEndpoint =
      "https://id.mobilisis.com/auth/realms/mobilisis.global/protocol/openid-connect/auth";
  static String clientIdentifier = "darko-debeljak-client";
  static String tokenEndpoint =
      "https://id.mobilisis.com/auth/realms/mobilisis.global/protocol/openid-connect/token";
  static String redirectEndpoint = "com.ddebeljak.irrigation://login-callback/";
  static List<String> scopes = [
    'openid',
    'profile',
    'email',
    'roles',
    'web-origins'
  ];
}
