import 'package:irrigation/models/response/sensor_no_user_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_response.g.dart';

@JsonSerializable()
class UserResponse {
  int userId;
  String name;
  String surname;
  String email;
  List<SensorNoUserResponse> sensors;

  UserResponse(
      {required this.userId,
      required this.name,
      required this.surname,
      required this.email,
      required this.sensors});

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}
