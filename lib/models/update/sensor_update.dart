import 'package:json_annotation/json_annotation.dart';

part 'sensor_update.g.dart';

@JsonSerializable()
class SensorUpdate {
  String name;
  double latitude;
  double longitude;
  double? groupId;
  double humidityThreshold;

  SensorUpdate(
      {required this.name,
      required this.latitude,
      required this.longitude,
      this.groupId,
      required this.humidityThreshold});

  factory SensorUpdate.fromJson(Map<String, dynamic> json) =>
      _$SensorUpdateFromJson(json);
  Map<String, dynamic> toJson() => _$SensorUpdateToJson(this);
}
