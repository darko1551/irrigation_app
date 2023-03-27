import 'package:irrigation/models/response/irregation_schedule_response.dart';
import 'package:irrigation/models/sensor_data.dart';

import 'package:json_annotation/json_annotation.dart';

part 'sensor_no_user_response.g.dart';

@JsonSerializable()
class SensorNoUserResponse {
  int sensorId;
  String name;
  double latitude;
  double longitude;
  String mac;
  SensorData sensorData;
  double humidityThreshold;
  DateTime? lastActive;
  double? waterUsageLast;
  double? waterUsageAllTime;
  List<IrregationScheduleResponse> irregationSchedules;
  int userId;
  bool state;

  SensorNoUserResponse(
      {required this.sensorId,
      required this.name,
      required this.latitude,
      required this.longitude,
      required this.mac,
      required this.sensorData,
      required this.humidityThreshold,
      required this.lastActive,
      required this.waterUsageLast,
      required this.waterUsageAllTime,
      required this.irregationSchedules,
      required this.userId,
      required this.state});

  factory SensorNoUserResponse.fromJson(Map<String, dynamic> json) =>
      _$SensorNoUserResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SensorNoUserResponseToJson(this);
}
