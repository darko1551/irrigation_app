import 'package:json_annotation/json_annotation.dart';

part 'group_request.g.dart';

@JsonSerializable()
class GroupRequest {
  String name;

  GroupRequest({required this.name});

  factory GroupRequest.fromJson(Map<String, dynamic> json) =>
      _$GroupRequestFromJson(json);
  Map<String, dynamic> toJson() => _$GroupRequestToJson(this);
}
