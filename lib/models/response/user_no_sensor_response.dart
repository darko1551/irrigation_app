import 'package:json_annotation/json_annotation.dart';

part 'user_no_sensor_response.g.dart';

@JsonSerializable()
class UserNoSensorResponse {
  int userId;
  String name;
  String surname;
  String email;

  UserNoSensorResponse(
      {required this.userId,
      required this.name,
      required this.surname,
      required this.email});

  factory UserNoSensorResponse.fromJson(Map<String, dynamic> json) =>
      _$UserNoSensorResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserNoSensorResponseToJson(this);
}
