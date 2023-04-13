import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:irrigation/api/api_client.dart';
import 'package:irrigation/constants/exception_strings.dart';
import 'package:irrigation/feature/server_offline/server_offline_page.dart';
import 'package:irrigation/interceptors/interceptors.dart';
import 'package:irrigation/models/request/irrigation_schedule_request.dart';
import 'package:irrigation/models/request/sensor_request.dart';
import 'package:irrigation/models/response/sensor_response.dart';
import 'package:irrigation/models/update/sensor_update.dart';
import 'package:collection/collection.dart';
import 'package:irrigation/provider/user_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SensorProvider extends ChangeNotifier {
  //final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 5)));
  final dio = Dio()..options.connectTimeout = const Duration(seconds: 5);
  late ApiClient apiClient;
  late UserProvider userProvider;
  var es = ExceptionStrings;

  List<SensorResponse> _sensorList = [];
  bool isLoading = false;

  List<SensorResponse> get getSensors {
    return _sensorList;
  }

  Future<void> initializeList() async {
    isLoading = true;
    apiClient = ApiClient(dio);
    dio.interceptors
        .add(ApiInterceptor(clientCredentials: userProvider.clientCredentials));
    dio.interceptors.add(LogInterceptor(requestBody: true));
    try {
      _sensorList = await apiClient.getSensors(userProvider.user.userId);
    } on DioError catch (e) {
      dioExceptionHandler(e);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> refreshList() async {
    isLoading = true;
    notifyListeners();

    try {
      _sensorList = await apiClient.getSensors(userProvider.user.userId);
    } on DioError catch (e) {
      dioExceptionHandler(e);
    }

    isLoading = false;
    notifyListeners();
  }

  SensorResponse? getSensor(String mac) {
    return _sensorList.singleWhereOrNull((element) => element.mac == mac);
  }

  Future<void> removeSensor(int sensorId) async {
    isLoading = true;
    notifyListeners();
    try {
      await apiClient.deleteSensor(userProvider.user.userId, sensorId);
    } on DioError catch (e) {
      dioExceptionHandler(e);
    }
    refreshList();
    isLoading = false;
    notifyListeners();
  }

  Future<int?> addSensor(SensorRequest sensor) async {
    int? res;
    isLoading = true;
    notifyListeners();
    try {
      res = await apiClient.addSensor(sensor);
    } on DioError catch (e) {
      dioExceptionHandler(e);
    }
    refreshList();
    isLoading = false;
    notifyListeners();
    return res;
  }

  Future<int?> editSensor(int sensorId, SensorUpdate sensor) async {
    int? res;
    isLoading = true;
    notifyListeners();
    try {
      res = await apiClient.updateSensor(
          userProvider.user.userId, sensorId, sensor);
    } on DioError catch (e) {
      dioExceptionHandler(e);
    }
    refreshList();
    isLoading = false;
    notifyListeners();
    return res;
  }

  Future<int?> scheduleActivation(int scheduleId, bool status) async {
    int? res;
    isLoading = true;
    notifyListeners();
    try {
      dio.options.contentType = Headers.jsonContentType;
      res = await apiClient.activationActivationUpdate(
          userProvider.user.userId, scheduleId, status);
    } on DioError catch (e) {
      dioExceptionHandler(e);
    }
    refreshList();
    isLoading = false;
    notifyListeners();
    return res;
  }

  Future<int?> addSchedule(
      int sensorId, IrrigationScheduleRequest scheduleRequest) async {
    int? res;
    isLoading = true;
    notifyListeners();
    try {
      //dio.options.contentType = Headers.jsonContentType;
      res = await apiClient.addSchedule(
          userProvider.user.userId, sensorId, scheduleRequest);
    } on DioError catch (e) {
      dioExceptionHandler(e);
    }
    refreshList();
    isLoading = false;
    notifyListeners();
    return res;
  }

  Future<int?> editSchedule(
      int scheduleId, IrrigationScheduleRequest scheduleRequest) async {
    int? res;
    isLoading = true;
    notifyListeners();
    try {
      res = await apiClient.updateSchedule(
          userProvider.user.userId, scheduleId, scheduleRequest);
    } on DioError catch (e) {
      dioExceptionHandler(e);
    }
    refreshList();
    isLoading = false;
    notifyListeners();
    return res;
  }

  Future<void> openValve(String uuid) async {
    isLoading = true;
    notifyListeners();
    try {
      await apiClient.openValve(uuid);
    } on DioError catch (e) {
      dioExceptionHandler(e);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> closeValve(String uuid) async {
    isLoading = true;
    notifyListeners();
    try {
      await apiClient.closeValve(uuid);
    } on DioError catch (e) {
      dioExceptionHandler(e);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> removeSchedule(int scheduleId) async {
    isLoading = true;
    notifyListeners();
    try {
      await apiClient.deleteSchedule(userProvider.user.userId, scheduleId);
    } on DioError catch (e) {
      dioExceptionHandler(e);
    }

    refreshList();
    isLoading = false;
    notifyListeners();
  }

  void dioExceptionHandler(DioError e) {
    AppLocalizations localizations = AppLocalizations.of(Get.context!)!;
    String message = e.error.toString();
    if (e.type == DioErrorType.connectionTimeout) {
      Get.offAll(() => const ServerOfflinePage());
    } else {
      for (String exceptionString in ExceptionStrings.exceptionStringList) {
        if (message.contains(exceptionString)) {
          switch (message) {
            case ExceptionStrings.sensorDoesNotExist:
              throw localizations.sensorDoesNotExist;
            case ExceptionStrings.userDoesNotExist:
              throw localizations.userDoesNotExist;
            case ExceptionStrings.sensorMacAlreadyExists:
              throw localizations.sensorMacAlreadyExists;
            case ExceptionStrings.sensorNameAlreadyExists:
              throw localizations.sensorNameAlreadyExists;
            case ExceptionStrings.macNotValid:
              throw localizations.macNotValid;
            case ExceptionStrings.scheduleAlreadyExists:
              throw localizations.scheduleAlreadyExists;
            case ExceptionStrings.scheduleDoesNotExist:
              throw localizations.scheduleDoesNotExist;
            case ExceptionStrings.scheduleOverlap:
              throw localizations.scheduleOverlap;
            case ExceptionStrings.somethingWentWrong:
              throw localizations.somethingWentWrong;
          }
        }
      }
      throw localizations.somethingWentWrong;
    }
  }
}
