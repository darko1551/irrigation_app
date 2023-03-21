import 'package:json_annotation/json_annotation.dart';

part 'group_no_sensor_response.g.dart';

@JsonSerializable()
class GroupNoSensorResponse {
  int? groupId;
  String? name;

  GroupNoSensorResponse(this.groupId, this.name);

  factory GroupNoSensorResponse.fromJson(Map<String, dynamic> json) =>
      _$GroupNoSensorResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GroupNoSensorResponseToJson(this);
}
