import 'dart:async';
import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:dio/src/response.dart' as dio_response;
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:get/get.dart';
import 'package:irrigation/constants/authorization_constants.dart';
import 'package:irrigation/feature/login/login_page.dart';
import 'package:irrigation/models/client_credentials.dart';
import 'package:irrigation/preferences/credential_preference.dart';
import 'package:irrigation/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ApiInterceptor extends Interceptor {
  ClientCredentials? clientCredentials;
  ApiInterceptor({required this.clientCredentials});
  final _tokenLock = Lock();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (clientCredentials!.expiration!.isBefore(DateTime.now())) {
      await refreshToken();
      if (clientCredentials != null) {
        return handler.resolve(await _retry(options));
      } else {
        Get.offAll(() => const LoginPage());
      }
    }

    /*options.headers['Authorization'] =
        'Bearer ${clientCredentials!.accessToken}';*/

    int maxAttempts = 3;
    int retry = 0;
    while (retry < maxAttempts) {
      if (clientCredentials != null) {
        options.headers['Authorization'] =
            'Bearer ${clientCredentials!.accessToken}';
        retry = 0;
        super.onRequest(options, handler);
        break;
      } else {
        retry++;
        await Future.delayed(const Duration(seconds: 1));
        if (retry == maxAttempts) {
          Get.snackbar(AppLocalizations.of(Get.context!)!.error,
              AppLocalizations.of(Get.context!)!.somethingWentWrong,
              backgroundColor: Theme.of(Get.context!).cardColor);
          logOut();
        }
      }
    }
  }

  @override
  void onError(DioError dioError, ErrorInterceptorHandler handler) async {
    if (dioError.response?.statusCode == 401) {
      await refreshToken();
      if (clientCredentials != null) {
        return handler.resolve(await _retry(dioError.requestOptions));
      }
    }
    super.onError(dioError, handler);
  }

  @override
  void onResponse(
      dio_response.Response response, ResponseInterceptorHandler handler) {
    print('done');
    super.onResponse(response, handler);
  }

  Future<void> refreshToken() async {
    await _tokenLock.synchronized(() async {
      if (clientCredentials!.expiration!.isBefore(DateTime.now())) {
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
        } catch (e) {
          print('Error refreshing token: $e');
          await logOut();
        }
      }
    });
  }

  Future<void> logOut() async {
    clientCredentials = null;
    await Provider.of<UserProvider>(Get.context!, listen: false)
        .setClientCredentials(null);
    Get.offAll(() => const LoginPage());
  }

  Future<dio_response.Response<dynamic>> _retry(
      RequestOptions requestOptions) async {
    final Dio dio = Dio();
    dio.interceptors.add(this);
    final options = Options(
      method: requestOptions.method,
      headers: {"Authorization": "Bearer ${clientCredentials!.accessToken}"},
    );

    return dio.request<dynamic>(
      requestOptions.baseUrl + requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}

class Lock {
  Completer<void>? _completer;

  Future<void> synchronized(Future<void> Function() callback) async {
    if (_completer != null) {
      await _completer!.future;
    }
    _completer = Completer();
    try {
      await callback();
    } finally {
      _completer!.complete();
      _completer = null;
    }
  }
}
