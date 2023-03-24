import 'package:flutter/material.dart';
import 'package:irrigation/converter/costum_date_time_converter.dart';
import 'package:irrigation/converter/costum_time_od_day_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'irregation_schedule_response.g.dart';

@JsonSerializable()
class IrregationScheduleResponse {
  int id;
  @CostumDateTimeConverter()
  DateTime dateFrom;
  @CostumDateTimeConverter()
  DateTime dateTo;
  @CostumTimeOnlyConverter()
  TimeOfDay time;
  double duration;
  bool activated;

  IrregationScheduleResponse(
      {required this.id,
      required this.dateFrom,
      required this.dateTo,
      required this.time,
      required this.duration,
      required this.activated});

  factory IrregationScheduleResponse.fromJson(Map<String, dynamic> json) =>
      _$IrregationScheduleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$IrregationScheduleResponseToJson(this);
}
