import 'package:json_annotation/json_annotation.dart';

part 'res_groups_model.g.dart';

@JsonSerializable()
class ResGroupsModel {
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'users')
  final dynamic users;

  ResGroupsModel({this.id, this.name, this.users});

  factory ResGroupsModel.fromJson(Map<String, dynamic> json) =>
      _$ResGroupsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResGroupsModelToJson(this);
}
