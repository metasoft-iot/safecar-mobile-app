# Response

Esta carpeta contiene los **modelos de respuesta** (DTOs - Data Transfer Objects) que representan la estructura de los datos recibidos de la API.

## Propósito

Los modelos de respuesta son responsables de:

- **Mapear respuestas de API**: Representar exactamente la estructura JSON que devuelve el backend.
- **Serialización/Deserialización**: Convertir JSON a objetos Dart y viceversa.
- **Validación de datos**: Asegurar que los datos recibidos cumplen con el formato esperado.
- **Desacoplar estructura externa**: Aislar cambios en la API del resto de la aplicación.

## Ejemplo de estructura

```dart
class AppointmentResponse {
  final String id;
  final String workshopId;
  final String customerId;
  final DateTime scheduledDate;
  final String status;
  final List<ServiceResponse> services;
  
  AppointmentResponse({
    required this.id,
    required this.workshopId,
    required this.customerId,
    required this.scheduledDate,
    required this.status,
    required this.services,
  });
  
  factory AppointmentResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentResponse(
      id: json['id'] as String,
      workshopId: json['workshop_id'] as String,
      customerId: json['customer_id'] as String,
      scheduledDate: DateTime.parse(json['scheduled_date'] as String),
      status: json['status'] as String,
      services: (json['services'] as List)
          .map((e) => ServiceResponse.fromJson(e))
          .toList(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workshop_id': workshopId,
      'customer_id': customerId,
      'scheduled_date': scheduledDate.toIso8601String(),
      'status': status,
      'services': services.map((e) => e.toJson()).toList(),
    };
  }
}
```

## Buenas prácticas

- Usar `fromJson` y `toJson` para serialización
- Mantener nombres de campos consistentes con la API
- Incluir validaciones básicas en constructores
- Considerar usar `json_serializable` para automatizar código
- No incluir lógica de negocio en estos modelos
- Documentar campos opcionales o con valores por defecto
