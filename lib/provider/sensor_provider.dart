import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:irrigation/api/api_client.dart';
import 'package:irrigation/models/request/irrigation_schedule_request.dart';
import 'package:irrigation/models/request/sensor_request.dart';
import 'package:irrigation/models/response/sensor_response.dart';
import 'package:irrigation/models/update/sensor_update.dart';
import 'package:collection/collection.dart';

class SensorProvider extends ChangeNotifier {
  final dio = Dio();

  List<SensorResponse> _sensorList = [];
  bool isLoading = false;

  List<SensorResponse> get getSensors {
    return _sensorList;
  }

  Future<void> initializeList() async {
    isLoading = true;

    final apiClient = ApiClient(dio);
    _sensorList = await apiClient.getSensors();
    isLoading = false;
    notifyListeners();
  }

  Future<void> refreshList() async {
    isLoading = true;
    notifyListeners();
    final dio = Dio();
    final apiClient = ApiClient(dio);
    _sensorList = await apiClient.getSensors();
    isLoading = false;
    notifyListeners();
  }

  SensorResponse? getSensor(String mac) {
    return _sensorList.singleWhereOrNull((element) => element.mac == mac);
  }

  Future<void> removeSensor(int id) async {
    isLoading = true;
    notifyListeners();
    final dio = Dio();
    final apiClient = ApiClient(dio);
    await apiClient.deleteSensor(id);
    refreshList();
    isLoading = false;
    notifyListeners();
  }

  Future<int?> addSensor(SensorRequest sensor) async {
    int? res;
    isLoading = true;
    notifyListeners();
    try {
      final apiClient = ApiClient(dio);
      res = await apiClient.addSensor(sensor);
    } on DioError catch (e) {
      e.error.printError();
      if (e.error.toString().contains("mac already exists")) {
        throw "Sensor with specified mac already exists";
      }
    }
    refreshList();
    isLoading = false;
    notifyListeners();
    return res;
  }

  Future<int?> editSensor(int id, SensorUpdate sensor) async {
    int? res;
    isLoading = true;
    notifyListeners();
    try {
      final dio = Dio();
      final apiClient = ApiClient(dio);
      res = await apiClient.editSensor(id, sensor);
    } on DioError catch (e) {
      if (e.error.toString().contains("name already exists")) {
        throw "Sensor with specified name already exists";
      }
    }
    refreshList();
    isLoading = false;
    notifyListeners();
    return res;
  }

  Future<int?> scheduleActivation(int id, bool status) async {
    int? res;
    isLoading = true;
    notifyListeners();
    try {
      dio.options.contentType = Headers.jsonContentType;
      final apiClient = ApiClient(dio);
      res = await apiClient.scheduleActivation(id, status);
    } on DioError catch (e) {
      if (e.error.toString().contains("Schedule does not exist")) {
        throw "Schedule does not exist";
      } else {
        throw "Something went wrong";
      }
    }
    refreshList();
    isLoading = false;
    notifyListeners();
    return res;
  }

  Future<int?> addSchedule(
      int id, IrrigationScheduleRequest scheduleRequest) async {
    int? res;
    isLoading = true;
    notifyListeners();
    try {
      //dio.options.contentType = Headers.jsonContentType;
      final apiClient = ApiClient(dio);
      res = await apiClient.addSchedule(id, scheduleRequest);
    } on DioError catch (e) {
      if (e.error.toString().contains("Specified sensor does not exist")) {
        throw "Specified sensor does not exist";
      } else if (e.error
          .toString()
          .contains("Schedule with same parameters already exists")) {
        throw "Schedule with same parameters already exists";
      } else {
        throw "Something went wrong";
      }
    }
    refreshList();
    isLoading = false;
    notifyListeners();
    return res;
  }

  Future<int?> editSchedule(
      int id, IrrigationScheduleRequest scheduleRequest) async {
    int? res;
    isLoading = true;
    notifyListeners();
    try {
      //dio.options.contentType = Headers.jsonContentType;
      final apiClient = ApiClient(dio);
      res = await apiClient.editSchedule(id, scheduleRequest);
    } on DioError catch (e) {
      if (e.error.toString().contains("Schedule does not exist")) {
        throw "Schedule does not exist";
      } else {
        throw "Something went wrong";
      }
    }
    refreshList();
    isLoading = false;
    notifyListeners();
    return res;
  }

  Future<void> removeSchedule(int id) async {
    isLoading = true;
    notifyListeners();
    final dio = Dio();
    final apiClient = ApiClient(dio);
    await apiClient.deleteSchedule(id);
    refreshList();
    isLoading = false;
    notifyListeners();
  }
}
