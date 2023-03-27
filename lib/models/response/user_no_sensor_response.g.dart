// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_no_sensor_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserNoSensorResponse _$UserNoSensorResponseFromJson(
        Map<String, dynamic> json) =>
    UserNoSensorResponse(
      userId: json['userId'] as int,
      name: json['name'] as String,
      surname: json['surname'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$UserNoSensorResponseToJson(
        UserNoSensorResponse instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'surname': instance.surname,
      'email': instance.email,
    };
