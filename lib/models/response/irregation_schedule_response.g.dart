// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'irregation_schedule_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IrregationScheduleResponse _$IrregationScheduleResponseFromJson(
        Map<String, dynamic> json) =>
    IrregationScheduleResponse(
      id: json['id'] as int,
      dateFrom:
          const CostumDateTimeConverter().fromJson(json['dateFrom'] as String),
      dateTo:
          const CostumDateTimeConverter().fromJson(json['dateTo'] as String),
      time: const CostumTimeOnlyConverter().fromJson(json['time'] as String),
      duration: (json['duration'] as num).toDouble(),
      doNotIrregate: json['doNotIrregate'] as bool,
    );

Map<String, dynamic> _$IrregationScheduleResponseToJson(
        IrregationScheduleResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dateFrom': const CostumDateTimeConverter().toJson(instance.dateFrom),
      'dateTo': const CostumDateTimeConverter().toJson(instance.dateTo),
      'time': const CostumTimeOnlyConverter().toJson(instance.time),
      'duration': instance.duration,
      'doNotIrregate': instance.doNotIrregate,
    };
