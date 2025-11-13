// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_profile_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateProfileRequestModel _$CreateProfileRequestModelFromJson(
  Map<String, dynamic> json,
) => CreateProfileRequestModel(
  fullName: json['fullName'] as String,
  city: json['city'] as String,
  country: json['country'] as String,
  phone: json['phone'] as String,
  dni: json['dni'] as String,
);

Map<String, dynamic> _$CreateProfileRequestModelToJson(
  CreateProfileRequestModel instance,
) => <String, dynamic>{
  'fullName': instance.fullName,
  'city': instance.city,
  'country': instance.country,
  'phone': instance.phone,
  'dni': instance.dni,
};
