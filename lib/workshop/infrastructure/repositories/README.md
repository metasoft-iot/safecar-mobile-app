# Repositories

Esta carpeta contiene las **implementaciones concretas** de los repositorios definidos en la capa de dominio.

## Propósito

Los repositorios de infraestructura son responsables de:

- **Implementar interfaces del dominio**: Proporcionar la implementación real de los contratos definidos en el dominio.
- **Gestionar fuentes de datos**: Interactuar con APIs, bases de datos locales, o cualquier otra fuente de datos.
- **Manejo de errores**: Capturar y transformar excepciones de infraestructura en errores del dominio.
- **Transformación de datos**: Usar assemblers para convertir DTOs en entidades de dominio.

## Ejemplo de estructura

```dart
class AppointmentRepositoryImpl implements AppointmentRepository {
  final HttpClient httpClient;
  final LocalDatabase localDatabase;
  
  AppointmentRepositoryImpl({
    required this.httpClient,
    required this.localDatabase,
  });
  
  @override
  Future<Either<Failure, List<AppointmentEntity>>> getAppointments() async {
    try {
      final response = await httpClient.get(WorkshopEndpoints.appointments);
      final appointments = response.map((e) => 
        AppointmentAssembler.fromResponse(e)
      ).toList();
      return Right(appointments);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
```

## Buenas prácticas

- Implementar todas las interfaces del dominio
- Inyectar dependencias (HTTP client, database, etc.)
- Usar Either para manejar errores (patrón funcional)
- Mantener la lógica de negocio fuera del repositorio
- Utilizar assemblers para conversión de datos
