import 'package:json_annotation/json_annotation.dart';

part 'profile_response_model.g.dart';

@JsonSerializable()
class ProfileResponseModel {
  final int profileId;
  final String fullName;
  final String city;
  final String country;
  final String phone;
  final String dni;
  final String? companyName; // Puede ser nulo
  final List<String> specializations;
  final int yearsOfExperience;

  ProfileResponseModel({
    required this.profileId,
    required this.fullName,
    required this.city,
    required this.country,
    required this.phone,
    required this.dni,
    this.companyName,
    required this.specializations,
    required this.yearsOfExperience,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseModelFromJson(json);
}