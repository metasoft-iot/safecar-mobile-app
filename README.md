# safecar_mobile_app

Aplicación móvil de SafeCar.

## Configuración de variables de entorno

La comunicación con el backend requiere definir las siguientes variables en tiempo de ejecución (con `--dart-define`):

```bash
flutter run \
  --dart-define=SAFE_CAR_BASE_URL=http://localhost:8080 \
  --dart-define=SAFE_CAR_TOKEN=<TOKEN_JWT>
```

- `SAFE_CAR_BASE_URL`: raíz del backend (por defecto `http://localhost:8080`).
- `SAFE_CAR_TOKEN`: token JWT que se enviará en la cabecera `Authorization`.

## Arquitectura DDD para Insights

La funcionalidad de análisis/insights sigue capas claras:

1. **Domain**: entidades, `VehicleInsightRepository` y casos de uso (`GetVehicleInsightUseCase`, `AnalyzeVehicleTelemetryUseCase`).
2. **Data**: modelos/datasource HTTP (`VehicleInsightRemoteDataSource`) y `VehicleInsightRepositoryImpl`.
3. **Presentation**: `VehicleInsightNotifier` (estado) y `VehicleInsightScreen` que replica los mockups y consume los casos de uso.

Accede al flujo desde la pestaña *Status* o la tarjeta "Vehicle status" del dashboard.
