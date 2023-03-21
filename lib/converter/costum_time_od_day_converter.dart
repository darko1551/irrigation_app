import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class CostumTimeOnlyConverter implements JsonConverter<TimeOfDay, String> {
  const CostumTimeOnlyConverter();

  @override
  TimeOfDay fromJson(String json) {
    return TimeOfDay(
        hour: int.parse(json.split(":")[0]),
        minute: int.parse(json.split(":")[1]));
  }

  @override
  String toJson(TimeOfDay object) {
    return '${object.hour.toString().padLeft(2, '0')}:${object.minute.toString().padLeft(2, '0')}:00';
  }
}
