import 'dart:async';
import 'package:dio/dio.dart';
import 'package:dio/src/response.dart' as dio_response;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:get/get.dart';
import 'package:irrigation/constants/authorization_constants.dart';
import 'package:irrigation/feature/login/login_page.dart';
import 'package:irrigation/models/client_credentials.dart';
import 'package:irrigation/preferences/credential_preference.dart';
import 'package:irrigation/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ApiInterceptor extends QueuedInterceptor {
  ClientCredentials? clientCredentials;
  CancelToken? _cancelToken;
  ApiInterceptor({required this.clientCredentials});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    RequestInterceptorHandler newHandler = RequestInterceptorHandler();
    if (clientCredentials == null) {
      print("No credentials");
    }
    _cancelToken = CancelToken();
    options.cancelToken = _cancelToken;
    print("New Request. Checking token expiration");
    if (clientCredentials!.expiration!.isBefore(DateTime.now())) {
      print("Token expired");
      await refreshToken();
      _cancelToken!.cancel();
      super.onRequest(options, handler);
      print("Checking credentials after token refresh");
      if (clientCredentials != null) {
        options.headers['Authorization'] =
            'Bearer ${clientCredentials!.accessToken}';
        print("Credentials OK");
        print("execute retry");
        var newRequestOptions = options;
        newRequestOptions.cancelToken = null;
        super.onRequest(newRequestOptions, newHandler);
      } else {
        print("Client credentials not found");
      }
    } else {
      print(
          "Token not expired, Expiration date: ${clientCredentials!.expiration}");
      options.headers['Authorization'] =
          'Bearer ${clientCredentials!.accessToken}';
      super.onRequest(options, handler);
    }
  }

  @override
  void onError(DioError dioError, ErrorInterceptorHandler handler) async {
    super.onError(dioError, handler);
  }

  @override
  void onResponse(
      dio_response.Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.cancelToken == null) {
      print("retry done");
    } else {
      print("done");
    }
    super.onResponse(response, handler);
  }

  Future<void> refreshToken() async {
    print("Refreshing");
    FlutterAppAuth appAuth = const FlutterAppAuth();
    try {
      final TokenResponse? result = await appAuth.token(TokenRequest(
          AuthorizationConstants.clientIdentifier,
          AuthorizationConstants.redirectEndpoint,
          serviceConfiguration: AuthorizationServiceConfiguration(
              authorizationEndpoint:
                  AuthorizationConstants.authorizationEndpoint,
              tokenEndpoint: AuthorizationConstants.tokenEndpoint),
          refreshToken: clientCredentials!.refreshToken,
          scopes: AuthorizationConstants.scopes));

      ClientCredentials? newCredentials = ClientCredentials(
          accessToken: result!.accessToken!,
          refreshToken: result.refreshToken!,
          expiration: result.accessTokenExpirationDateTime);
      clientCredentials = newCredentials;

      CredentialsPreference prefs = CredentialsPreference();
      await prefs.setCredentials(newCredentials);
      print("Refreshed");
      return;
    } catch (e) {
      print('Error refreshing token: $e');
      print("Logging out");
      await logOut();
    }
  }

  Future<void> logOut() async {
    clientCredentials = null;
    await Provider.of<UserProvider>(Get.context!, listen: false)
        .setClientCredentials(null);
    _cancelToken!.cancel();
    await Get.offAll(() => const LoginPage());
  }
}
