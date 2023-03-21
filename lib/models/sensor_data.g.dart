// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SensorData _$SensorDataFromJson(Map<String, dynamic> json) => SensorData(
      (json['temperature'] as num?)?.toDouble(),
      (json['humidity'] as num?)?.toDouble(),
      json['state'] as bool,
      json['time'] == null ? null : DateTime.parse(json['time'] as String),
    );

Map<String, dynamic> _$SensorDataToJson(SensorData instance) =>
    <String, dynamic>{
      'temperature': instance.temperature,
      'humidity': instance.humidity,
      'state': instance.state,
      'time': instance.time?.toIso8601String(),
    };
