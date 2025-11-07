import 'package:json_annotation/json_annotation.dart';

part 'register_request_model.g.dart';

@JsonSerializable()
class RegisterRequestModel {
  final String email;
  final String password;
  final String confirmPassword;
  final List<String> roles;

  // Constructor
  RegisterRequestModel({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.roles,
  });

  // El método para CONVERTIR el objeto a un JSON
  Map<String, dynamic> toJson() => _$RegisterRequestModelToJson(this);
}