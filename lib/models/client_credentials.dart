class ClientCredentials {
  String accessToken;
  String refreshToken;
  DateTime? expiration;

  ClientCredentials(
      {required this.accessToken,
      required this.refreshToken,
      required this.expiration});
}
