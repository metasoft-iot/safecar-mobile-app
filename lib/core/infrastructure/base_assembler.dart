import 'base_response.dart';

/// Base assembler interface for converting between entities and resources.
/// 
/// [E] - Entity type (domain model)
/// [R] - Resource type (API resource)
/// [T] - Response type (API response)
abstract class BaseAssembler<E, R extends BaseResource, T extends BaseResponse> {
  /// Converts a Resource to an Entity.
  E toEntityFromResource(R resource);

  /// Converts an Entity to a Resource.
  R toResourceFromEntity(E entity);

  /// Converts a Response to a list of Entities.
  List<E> toEntitiesFromResponse(T response);
}

