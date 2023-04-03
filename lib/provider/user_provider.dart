import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:irrigation/api/api_client.dart';
import 'package:irrigation/interceptors/interceptors.dart';
import 'package:irrigation/models/client_credentials.dart';
import 'package:irrigation/models/response/user_response.dart';
import 'package:irrigation/preferences/credential_preference.dart';

class UserProvider extends ChangeNotifier {
  CredentialsPreference credentialsPreference = CredentialsPreference();
  late UserResponse _user;
  late ClientCredentials? _clientCredentials;

  UserResponse get user => _user;
  ClientCredentials? get clientCredentials => _clientCredentials;

  initUser() async {
    final dio = Dio();
    dio.interceptors.add(ApiInterceptor(clientCredentials: _clientCredentials));
    final apiClient = ApiClient(dio);
    List<UserResponse> users = await apiClient.getUsers();
    _user = users.last;
    notifyListeners();
  }

  initClientCredentials() async {
    _clientCredentials = await credentialsPreference.getCredentials();
    notifyListeners();
  }

  setClientCredentials(ClientCredentials? credentials) async {
    await credentialsPreference.setCredentials(credentials);
    _clientCredentials = credentials;
    notifyListeners();
  }

  errorInterceptor(DioError dioError) {
    print(dioError);
  }
}
