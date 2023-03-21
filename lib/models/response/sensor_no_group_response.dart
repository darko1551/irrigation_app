import 'package:irrigation/models/response/irregation_schedule_response.dart';
import 'package:irrigation/models/sensor_data.dart';

import 'package:json_annotation/json_annotation.dart';

part 'sensor_no_group_response.g.dart';

@JsonSerializable()
class SensorNoGroupResponse {
  int sensorId;
  String name;
  double latitude;
  double longitude;
  String mac;
  SensorData sensorData;
  double humidityThreshold;
  DateTime lastActive;
  double waterUsageLast;
  double waterUsageAllTime;
  List<IrregationScheduleResponse> irregationSchedules;
  int? groupId;
  bool state;

  SensorNoGroupResponse(
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
      this.groupId,
      required this.state});

  factory SensorNoGroupResponse.fromJson(Map<String, dynamic> json) =>
      _$SensorNoGroupResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SensorNoGroupResponseToJson(this);
}
