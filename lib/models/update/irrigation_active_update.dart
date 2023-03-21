import 'package:json_annotation/json_annotation.dart';

part 'irrigation_active_update.g.dart';

@JsonSerializable()
class IrrigationActiveUpdate {
  bool status;

  IrrigationActiveUpdate({required this.status});

  factory IrrigationActiveUpdate.fromJson(Map<String, dynamic> json) =>
      _$IrrigationActiveUpdateFromJson(json);
  Map<String, dynamic> toJson() => _$IrrigationActiveUpdateToJson(this);
}
