/// Workshop entity for the workshops domain.
class Workshop {
  final int id;
  final String name;
  final String address;
  final String? phoneNumber;
  final String? email;
  final int mechanicsCount;
  final int appointmentsCount;

  Workshop({
    required this.id,
    required this.name,
    required this.address,
    this.phoneNumber,
    this.email,
    this.mechanicsCount = 0,
    this.appointmentsCount = 0,
  });

  Workshop copyWith({
    int? id,
    String? name,
    String? address,
    String? phoneNumber,
    String? email,
    int? mechanicsCount,
    int? appointmentsCount,
  }) {
    return Workshop(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      mechanicsCount: mechanicsCount ?? this.mechanicsCount,
      appointmentsCount: appointmentsCount ?? this.appointmentsCount,
    );
  }
}

/// Mechanic entity representing a workshop mechanic.
class Mechanic {
  final int id;
  final String firstName;
  final String lastName;
  final String? specialization;
  final String? contactNumber;

  Mechanic({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.specialization,
    this.contactNumber,
  });

  String get fullName => '$firstName $lastName';

  Mechanic copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? specialization,
    String? contactNumber,
  }) {
    return Mechanic(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      specialization: specialization ?? this.specialization,
      contactNumber: contactNumber ?? this.contactNumber,
    );
  }
}

