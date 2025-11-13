// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterResponseModel _$RegisterResponseModelFromJson(
  Map<String, dynamic> json,
) => RegisterResponseModel(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$RegisterResponseModelToJson(
  RegisterResponseModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'roles': instance.roles,
};
