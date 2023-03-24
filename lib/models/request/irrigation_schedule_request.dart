import 'package:flutter/material.dart';
import 'package:irrigation/converter/costum_date_time_converter.dart';
import 'package:irrigation/converter/costum_time_od_day_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'irrigation_schedule_request.g.dart';

@JsonSerializable()
class IrrigationScheduleRequest {
  @CostumDateTimeConverter()
  DateTime dateFrom;
  @CostumDateTimeConverter()
  DateTime dateTo;
  @CostumTimeOnlyConverter()
  TimeOfDay time;
  double duration;
  bool activated;

  IrrigationScheduleRequest(
      {required this.dateFrom,
      required this.dateTo,
      required this.time,
      required this.duration,
      required this.activated});

  factory IrrigationScheduleRequest.fromJson(Map<String, dynamic> json) =>
      _$IrrigationScheduleRequestFromJson(json);
  Map<String, dynamic> toJson() => _$IrrigationScheduleRequestToJson(this);
}
