// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'res_groups_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResGroupsModel _$ResGroupsModelFromJson(Map<String, dynamic> json) =>
    ResGroupsModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      users: json['users'],
    );

Map<String, dynamic> _$ResGroupsModelToJson(ResGroupsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'users': instance.users,
    };
