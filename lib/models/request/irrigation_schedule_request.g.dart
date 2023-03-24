// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'irrigation_schedule_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IrrigationScheduleRequest _$IrrigationScheduleRequestFromJson(
        Map<String, dynamic> json) =>
    IrrigationScheduleRequest(
      dateFrom:
          const CostumDateTimeConverter().fromJson(json['dateFrom'] as String),
      dateTo:
          const CostumDateTimeConverter().fromJson(json['dateTo'] as String),
      time: const CostumTimeOnlyConverter().fromJson(json['time'] as String),
      duration: (json['duration'] as num).toDouble(),
      activated: json['activated'] as bool,
    );

Map<String, dynamic> _$IrrigationScheduleRequestToJson(
        IrrigationScheduleRequest instance) =>
    <String, dynamic>{
      'dateFrom': const CostumDateTimeConverter().toJson(instance.dateFrom),
      'dateTo': const CostumDateTimeConverter().toJson(instance.dateTo),
      'time': const CostumTimeOnlyConverter().toJson(instance.time),
      'duration': instance.duration,
      'activated': instance.activated,
    };
