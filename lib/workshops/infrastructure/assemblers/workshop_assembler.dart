import '../../../core/infrastructure/base_assembler.dart';
import '../../domain/model/workshop.entity.dart';
import '../resources/workshops_response.dart';

/// Assembler for converting between Workshop entities and Workshop resources.
class WorkshopAssembler implements BaseAssembler<Workshop, WorkshopResource, WorkshopsResponse> {
  @override
  Workshop toEntityFromResource(WorkshopResource resource) {
    return Workshop(
      id: resource.id,
      name: resource.businessName,
      address: resource.businessAddress,
      mechanicsCount: resource.totalMechanics,
    );
  }

  @override
  WorkshopResource toResourceFromEntity(Workshop entity) {
    return WorkshopResource(
      id: entity.id,
      businessName: entity.name,
      businessAddress: entity.address,
      workshopDescription: entity.name,
      totalMechanics: entity.mechanicsCount,
    );
  }

  @override
  List<Workshop> toEntitiesFromResponse(WorkshopsResponse response) {
    return response.workshops.map((resource) => toEntityFromResource(resource)).toList();
  }
}

