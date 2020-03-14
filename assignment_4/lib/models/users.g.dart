// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Users _$UsersFromJson(Map<String, dynamic> json) {
  return Users()..users = json['posts'] as List;
}

Map<String, dynamic> _$UsersToJson(Users instance) =>
    <String, dynamic>{'posts': instance.users};
