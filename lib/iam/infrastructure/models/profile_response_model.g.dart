// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileResponseModel _$ProfileResponseModelFromJson(
  Map<String, dynamic> json,
) => ProfileResponseModel(
  profileId: (json['profileId'] as num).toInt(),
  fullName: json['fullName'] as String,
  city: json['city'] as String,
  country: json['country'] as String,
  phone: json['phone'] as String,
  dni: json['dni'] as String,
  companyName: json['companyName'] as String?,
  specializations: (json['specializations'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  yearsOfExperience: (json['yearsOfExperience'] as num).toInt(),
);

Map<String, dynamic> _$ProfileResponseModelToJson(
  ProfileResponseModel instance,
) => <String, dynamic>{
  'profileId': instance.profileId,
  'fullName': instance.fullName,
  'city': instance.city,
  'country': instance.country,
  'phone': instance.phone,
  'dni': instance.dni,
  'companyName': instance.companyName,
  'specializations': instance.specializations,
  'yearsOfExperience': instance.yearsOfExperience,
};
