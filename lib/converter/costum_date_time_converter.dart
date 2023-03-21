import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

class CostumDateTimeConverter implements JsonConverter<DateTime, String> {
  const CostumDateTimeConverter();

  @override
  DateTime fromJson(String json) {
    DateTime dateTime = DateTime.parse(json);
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  @override
  String toJson(DateTime object) {
    return DateFormat('yyyy-MM-dd').format(object);
  }
}
