# Endpoints

Esta carpeta contiene las definiciones de **endpoints** y **constantes** relacionadas con las URLs de la API.

## Propósito

Los archivos de endpoints son responsables de:

- **Centralizar URLs**: Mantener todas las URLs de la API en un solo lugar.
- **Facilitar mantenimiento**: Cambios en endpoints se realizan en un único punto.
- **Evitar duplicación**: Prevenir URLs hardcodeadas dispersas en el código.
- **Tipado seguro**: Proporcionar constantes tipadas para las rutas de la API.

## Ejemplo de estructura

```dart
class WorkshopEndpoints {
  static const String baseUrl = '/api/v1/workshop';
  
  static const String appointments = '$baseUrl/appointments';
  static const String appointmentById = '$baseUrl/appointments/{id}';
  static const String services = '$baseUrl/services';
  
  static String getAppointmentUrl(String id) {
    return appointmentById.replaceAll('{id}', id);
  }
}
```

## Buenas prácticas

- Usar constantes para los paths
- Agrupar endpoints por módulo o funcionalidad
- Incluir métodos helper para URLs dinámicas
- Documentar parámetros requeridos en los endpoints
