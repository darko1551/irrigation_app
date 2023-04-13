import 'package:json_annotation/json_annotation.dart';

part 'sensor_data.g.dart';

@JsonSerializable()
class SensorData {
  double? temperature;
  double? humidity;
  bool? state;
  DateTime? time;

  SensorData(this.temperature, this.humidity, this.state, this.time);

  factory SensorData.fromJson(Map<String, dynamic> json) =>
      _$SensorDataFromJson(json);
  Map<String, dynamic> toJson() => _$SensorDataToJson(this);
}
