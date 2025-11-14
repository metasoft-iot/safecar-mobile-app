class ProfileResponseModel {
  final int profileId;
  final String fullName;
  final String city;
  final String country;
  final String phone;
  final String dni;
  final String? companyName;
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

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileResponseModel(
      profileId: json['profileId'] ?? 0,
      fullName: json['fullName'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      phone: json['phone'] ?? '',
      dni: json['dni'] ?? '',
      companyName: json['companyName'],
      specializations: json['specializations'] != null
          ? List<String>.from(json['specializations'])
          : [],
      yearsOfExperience: json['yearsOfExperience'] ?? 0,
    );
  }
}
