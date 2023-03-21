import 'package:json_annotation/json_annotation.dart';

part 'sensor_request.g.dart';

@JsonSerializable()
class SensorRequest {
  String name;
  double latitude;
  double longitude;
  String mac;
  double humidityThreshold;
  int? groupId;

  SensorRequest(
      {required this.name,
      required this.latitude,
      required this.longitude,
      required this.mac,
      required this.humidityThreshold,
      this.groupId});

  factory SensorRequest.fromJson(Map<String, dynamic> json) =>
      _$SensorRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SensorRequestToJson(this);
}
