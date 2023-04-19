import 'package:irrigation/models/client_credentials.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CredentialsPreference {
  static const ACCESS_TOKEN = "ACCESSTOKEN";
  static const REFRESH_TOKEN = "REFRESHTOKEN";
  static const EXPIRATION = "EXPIRATION";

  setCredentials(ClientCredentials? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (value != null) {
      await prefs.setString(ACCESS_TOKEN, value.accessToken);
      await prefs.setString(REFRESH_TOKEN, value.refreshToken);
      await prefs.setString(EXPIRATION, value.expiration.toString());
    } else {
      await prefs.setString(ACCESS_TOKEN, "");
      await prefs.setString(REFRESH_TOKEN, "");
      await prefs.setString(EXPIRATION, "");
    }
  }

  Future<ClientCredentials?> getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime? expiration;
    String accessToken = prefs.getString(ACCESS_TOKEN) ?? "";
    String refreshToken = prefs.getString(REFRESH_TOKEN) ?? "";
    if (prefs.getString(EXPIRATION) == null ||
        prefs.getString(EXPIRATION) == "") {
      expiration = null;
    } else {
      expiration = DateTime.parse(prefs.getString(EXPIRATION)!);
    }
    if (accessToken.isEmpty) {
      return null;
    } else {
      ClientCredentials clientCredentials = ClientCredentials(
          accessToken: accessToken,
          refreshToken: refreshToken,
          expiration: expiration);
      return clientCredentials;
    }
  }
}
