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

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'city': city,
      'country': country,
      'phone': phone,
      'dni': dni,
    };
  }
}
