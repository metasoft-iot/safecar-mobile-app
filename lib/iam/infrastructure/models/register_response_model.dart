import 'package:json_annotation/json_annotation.dart';

part 'register_response_model.g.dart';

@JsonSerializable()
class RegisterResponseModel {
  final int id;
  final String email;
  final List<String> roles;

  // Constructor
  RegisterResponseModel({
    required this.id,
    required this.email,
    required this.roles,
  });

  // El factory para CONSTRUIR un objeto desde un JSON
  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseModelFromJson(json);
}