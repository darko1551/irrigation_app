// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SensorUpdate _$SensorUpdateFromJson(Map<String, dynamic> json) => SensorUpdate(
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      groupId: (json['groupId'] as num?)?.toDouble(),
      humidityThreshold: (json['humidityThreshold'] as num).toDouble(),
    );

Map<String, dynamic> _$SensorUpdateToJson(SensorUpdate instance) =>
    <String, dynamic>{
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'groupId': instance.groupId,
      'humidityThreshold': instance.humidityThreshold,
    };
