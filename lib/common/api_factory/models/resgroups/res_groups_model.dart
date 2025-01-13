part 'res_groups_model.g.dart';

class ResGroupsModel {
  final int? id;
  final String? name;
  final dynamic users;

  ResGroupsModel({this.id, this.name, this.users});

  factory ResGroupsModel.fromJson(Map<String, dynamic> json) =>
      _$ResGroupsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResGroupsModelToJson(this);
}
