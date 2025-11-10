import '../../domain/entities/insight_recommendation.dart';

class InsightRecommendationModel extends InsightRecommendation {
  const InsightRecommendationModel({required super.title, required super.detail});

  factory InsightRecommendationModel.fromJson(Map<String, dynamic> json) {
    return InsightRecommendationModel(
      title: json['title'] as String? ?? 'Sin título',
      detail: json['detail'] as String? ?? 'Sin detalle',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'detail': detail,
    };
  }
}
