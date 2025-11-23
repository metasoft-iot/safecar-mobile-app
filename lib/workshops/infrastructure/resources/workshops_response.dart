import '../../../core/infrastructure/base_response.dart';

/// Resource interface for workshop data.
class WorkshopResource implements BaseResource {
  final int id;
  final int? businessProfileId;
  final String workshopDescription;
  final int totalMechanics;

  WorkshopResource({
    required this.id,
    this.businessProfileId,
    required this.workshopDescription,
    required this.totalMechanics,
  });

  factory WorkshopResource.fromJson(Map<String, dynamic> json) {
    return WorkshopResource(
      id: json['id'] as int,
      businessProfileId: json['businessProfileId'] as int?,
      workshopDescription: json['workshopDescription'] as String? ?? '',
      totalMechanics: json['totalMechanics'] as int? ?? 0,
    );
  }
}

/// Response interface for workshops API calls.
class WorkshopsResponse implements BaseResponse {
  final List<WorkshopResource> workshops;

  WorkshopsResponse({required this.workshops});

  factory WorkshopsResponse.fromJson(List<dynamic> json) {
    return WorkshopsResponse(
      workshops: json.map((w) => WorkshopResource.fromJson(w as Map<String, dynamic>)).toList(),
    );
  }
}

