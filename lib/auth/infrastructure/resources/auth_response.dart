import '../../../core/infrastructure/base_response.dart';

/// Resource interface for authentication data.
/// Represents the authentication response from the API.
class AuthResource implements BaseResource {
  final int id;
  final String username;
  final String token;

  AuthResource({
    required this.id,
    required this.username,
    required this.token,
  });

  factory AuthResource.fromJson(Map<String, dynamic> json) {
    return AuthResource(
      id: json['id'] as int,
      username: json['username'] as String,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'token': token,
    };
  }
}

/// Response interface for sign-in API calls.
class SignInResponse implements BaseResponse {
  final AuthResource auth;

  SignInResponse({required this.auth});

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      auth: AuthResource.fromJson(json),
    );
  }
}

/// Resource interface for person profile data.
class PersonProfileResource implements BaseResource {
  final int profileId;
  final String fullName;
  final String email;
  final String? phone;
  final String? dni;
  final String? city;
  final String? country;

  PersonProfileResource({
    required this.profileId,
    required this.fullName,
    required this.email,
    this.phone,
    this.dni,
    this.city,
    this.country,
  });

  factory PersonProfileResource.fromJson(Map<String, dynamic> json) {
    return PersonProfileResource(
      profileId: json['profileId'] as int,
      fullName: json['fullName'] as String,
      email: (json['userEmail'] ?? json['email']) as String,
      phone: json['phone'] as String?,
      dni: json['dni'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
    );
  }
}

/// Resource interface for driver data.
class DriverResource implements BaseResource {
  final int driverId;
  final int? profileId; // Optional because backend doesn't always return it

  DriverResource({
    required this.driverId,
    this.profileId,
  });

  factory DriverResource.fromJson(Map<String, dynamic> json) {
    return DriverResource(
      driverId: json['driverId'] as int,
      profileId: json['profileId'] as int?,
    );
  }
}

