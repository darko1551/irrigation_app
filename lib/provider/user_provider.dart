import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:irrigation/api/api_client.dart';
import 'package:irrigation/models/response/user_response.dart';

class UserProvider extends ChangeNotifier {
  late UserResponse _user;

  UserResponse get user => _user;

  initUser() async {
    final dio = Dio();
    final apiClient = ApiClient(dio);
    List<UserResponse> users = await apiClient.getUsers();
    _user = users.last;
    notifyListeners();
  }
}
