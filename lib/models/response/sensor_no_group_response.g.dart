// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_no_group_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SensorNoGroupResponse _$SensorNoGroupResponseFromJson(
        Map<String, dynamic> json) =>
    SensorNoGroupResponse(
      sensorId: json['sensorId'] as int,
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      mac: json['mac'] as String,
      sensorData:
          SensorData.fromJson(json['sensorData'] as Map<String, dynamic>),
      humidityThreshold: (json['humidityThreshold'] as num).toDouble(),
      lastActive: DateTime.parse(json['lastActive'] as String),
      waterUsageLast: (json['waterUsageLast'] as num).toDouble(),
      waterUsageAllTime: (json['waterUsageAllTime'] as num).toDouble(),
      irregationSchedules: (json['irregationSchedules'] as List<dynamic>)
          .map((e) =>
              IrregationScheduleResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      groupId: json['groupId'] as int?,
      state: json['state'] as bool,
    );

Map<String, dynamic> _$SensorNoGroupResponseToJson(
        SensorNoGroupResponse instance) =>
    <String, dynamic>{
      'sensorId': instance.sensorId,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'mac': instance.mac,
      'sensorData': instance.sensorData,
      'humidityThreshold': instance.humidityThreshold,
      'lastActive': instance.lastActive.toIso8601String(),
      'waterUsageLast': instance.waterUsageLast,
      'waterUsageAllTime': instance.waterUsageAllTime,
      'irregationSchedules': instance.irregationSchedules,
      'groupId': instance.groupId,
      'state': instance.state,
    };
