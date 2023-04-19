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
    ResponseInterceptorHandler newHandler = ResponseInterceptorHandler();
    if (clientCredentials == null) {
      print("No credentials");
    }
    _cancelToken = CancelToken();
    options.cancelToken = _cancelToken;
    print("New Request. Checking token expiration");
    if (clientCredentials!.expiration!.isBefore(DateTime.now())) {
      //if (true) {
      print("Token expired");

      await refreshToken();
      _cancelToken!.cancel();
      super.onRequest(options, handler);
      print("Checking credentials after token refresh");
      if (clientCredentials != null) {
        options.headers['Authorization'] =
            'Bearer ${clientCredentials!.accessToken}';
        print("Credentials OK");
        return newHandler.resolve(await _retry(options));
      } else {
        print("Client credentials not found");
      }
    }
    print(
        "Token not expired, Expiration date: ${clientCredentials!.expiration}");

    if (clientCredentials == null) {
      var prefs = CredentialsPreference();
      var creds = await prefs.getCredentials();
      await logOut();
    } else {
      options.headers['Authorization'] =
          'Bearer ${clientCredentials!.accessToken}';
      print("Executing request");
      super.onRequest(options, handler);
    }
  }

  @override
  void onError(DioError dioError, ErrorInterceptorHandler handler) async {
    if (dioError.response?.statusCode == 401) {
      //await refreshToken();
      if (clientCredentials != null) {
        //return handler.resolve(await _retry(dioError.requestOptions));
      }
    }
    super.onError(dioError, handler);
  }

  @override
  void onResponse(
      dio_response.Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.cancelToken!.isCancelled) {
      print("Done canceled");
    } else {
      print("Done");
    }
    super.onResponse(response, handler);
  }

  Future<void> refreshToken() async {
    // await _tokenLock.synchronized(() async {
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
      //_cancelToken!.cancel();
      await logOut();
    }

    //});
  }

  Future<void> logOut() async {
    clientCredentials = null;
    await Provider.of<UserProvider>(Get.context!, listen: false)
        .setClientCredentials(null);
    await Get.offAll(() => const LoginPage());
  }

  Future<dio_response.Response<dynamic>> _retry(
      RequestOptions requestOptions) async {
    print("Executing retry");
    Dio dio = Dio();
    dio.interceptors.add(this);

    print("Executing retry request");

    var newRequestOptions = requestOptions;
    newRequestOptions.cancelToken = null;

    return dio.request<dynamic>(
      requestOptions.baseUrl + requestOptions.path,
      data: newRequestOptions.data,
      queryParameters: newRequestOptions.queryParameters,
      //options: options,
    );
  }
}
