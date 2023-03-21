// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SensorRequest _$SensorRequestFromJson(Map<String, dynamic> json) =>
    SensorRequest(
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      mac: json['mac'] as String,
      humidityThreshold: (json['humidityThreshold'] as num).toDouble(),
      groupId: json['groupId'] as int?,
    );

Map<String, dynamic> _$SensorRequestToJson(SensorRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'mac': instance.mac,
      'humidityThreshold': instance.humidityThreshold,
      'groupId': instance.groupId,
    };
