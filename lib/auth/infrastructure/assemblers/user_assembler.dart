import '../../../core/infrastructure/base_assembler.dart';
import '../../domain/model/user.entity.dart';
import '../resources/auth_response.dart';

/// Assembler for converting between User entities and Auth resources.
class UserAssembler implements BaseAssembler<User, AuthResource, SignInResponse> {
  @override
  User toEntityFromResource(AuthResource resource) {
    return User(
      id: resource.id,
      username: resource.username,
      email: '', // Email is provided separately during sign-in
      roles: ['ROLE_DRIVER'], // Default role for mobile app users
    );
  }

  @override
  AuthResource toResourceFromEntity(User entity) {
    return AuthResource(
      id: entity.id,
      username: entity.username,
      token: '', // Token is managed separately
    );
  }

  @override
  List<User> toEntitiesFromResponse(SignInResponse response) {
    return [toEntityFromResource(response.auth)];
  }

  /// Convert AuthResource to User entity with email
  User toEntityFromResourceWithEmail(AuthResource resource, String email) {
    return User(
      id: resource.id,
      username: resource.username,
      email: email,
      roles: ['ROLE_DRIVER'],
    );
  }
}

