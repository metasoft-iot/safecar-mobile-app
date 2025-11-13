# Assembler

Esta carpeta contiene los **assemblers** o **mappers** que transforman datos entre diferentes capas de la aplicación.

## Propósito

Los assemblers son responsables de:

- **Convertir DTOs a Entidades de Dominio**: Transforman los modelos de respuesta (response) de la API en entidades del dominio.
- **Convertir Entidades a DTOs**: Transforman entidades del dominio en modelos para enviar a la API (request).
- **Desacoplar capas**: Mantienen la independencia entre la capa de infraestructura y la capa de dominio.

## Ejemplo de estructura

```dart
class AppointmentAssembler {
  static AppointmentEntity fromResponse(AppointmentResponse response) {
    // Mapeo de response a entity
  }
  
  static AppointmentRequest toRequest(AppointmentEntity entity) {
    // Mapeo de entity a request
  }
}
```

## Buenas prácticas

- Usar métodos estáticos para las conversiones
- Manejar valores nulos de forma segura
- Mantener la lógica de transformación simple y clara
- No incluir lógica de negocio en los assemblers
