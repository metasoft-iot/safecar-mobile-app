/// Workshop model representing a workshop/taller
class WorkshopModel {
  final int id;
  final String name;
  final String address;
  final String? phoneNumber;
  final String? email;
  final int mechanicsCount;
  final int appointmentsCount;

  WorkshopModel({
    required this.id,
    required this.name,
    required this.address,
    this.phoneNumber,
    this.email,
    this.mechanicsCount = 0,
    this.appointmentsCount = 0,
  });

  factory WorkshopModel.fromJson(Map<String, dynamic> json) {
    return WorkshopModel(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      mechanicsCount: json['mechanicsCount'] as int? ?? 0,
      appointmentsCount: json['appointmentsCount'] as int? ?? 0,
    );
  }
}

/// Mechanic model representing a workshop mechanic
class MechanicModel {
  final int id;
  final String firstName;
  final String lastName;
  final String? specialization;
  final String? contactNumber;

  MechanicModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.specialization,
    this.contactNumber,
  });

  factory MechanicModel.fromJson(Map<String, dynamic> json) {
    return MechanicModel(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      specialization: json['specialization'] as String?,
      contactNumber: json['contactNumber'] as String?,
    );
  }

  String get fullName => '$firstName $lastName';
}

