import 'package:irrigation/models/response/irregation_schedule_response.dart';
import 'package:irrigation/models/response/user_no_sensor_response.dart';
import 'package:irrigation/models/sensor_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sensor_response.g.dart';

@JsonSerializable()
class SensorResponse {
  int sensorId;
  String uuid;
  String name;
  double latitude;
  double longitude;
  String mac;
  UserNoSensorResponse user;
  SensorData sensorData;
  double humidityThreshold;
  DateTime? lastActive;
  double? waterUsageLast;
  double? waterUsageAllTime;
  List<IrregationScheduleResponse> irregationSchedules;
  int userId;
  bool? state;

  SensorResponse(
      {required this.sensorId,
      required this.uuid,
      required this.name,
      required this.latitude,
      required this.longitude,
      required this.mac,
      required this.user,
      required this.sensorData,
      required this.humidityThreshold,
      this.lastActive,
      this.waterUsageLast,
      this.waterUsageAllTime,
      required this.irregationSchedules,
      required this.userId,
      this.state});

  factory SensorResponse.fromJson(Map<String, dynamic> json) =>
      _$SensorResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SensorResponseToJson(this);
}
