import 'package:json_annotation/json_annotation.dart';

part 'create_profile_request_model.g.dart';

@JsonSerializable()
class CreateProfileRequestModel {
  final String fullName;
  final String city;
  final String country;
  final String phone;
  final String dni;

  CreateProfileRequestModel({
    required this.fullName,
    required this.city,
    required this.country,
    required this.phone,
    required this.dni,
  });

  Map<String, dynamic> toJson() => _$CreateProfileRequestModelToJson(this);
}