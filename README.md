# SafeCar Mobile App - Portal del Conductor

Aplicación móvil Flutter para conductores que les permite ver sus citas de servicio vehicular con talleres asociados.

## 📱 Características

### Autenticación
- ✅ Registro de nuevo conductor
- ✅ Inicio de sesión
- ✅ Persistencia de sesión (SharedPreferences)
- ✅ Cierre de sesión

### Citas de Servicio
- ✅ Ver lista de citas creadas por el taller
- ✅ Ver detalles completos de cada cita:
  - Fecha y hora
  - Tipo de servicio
  - Estado (Pendiente, Confirmada, En Progreso, Completada, Cancelada)
  - Mecánico asignado
  - Vehículo asociado
  - Notas del servicio
- ✅ Indicadores visuales de estado con colores
- ✅ Actualización manual (pull to refresh)

### Vehículos
- ✅ Vista preparada para lista de vehículos del conductor
- 🔄 Integración con API (próxima versión)

### Taller
- ✅ Vista preparada para información del taller vinculado
- 🔄 Integración con API (próxima versión)

## 🏗️ Arquitectura

### Estructura del Proyecto

```
lib/
├── core/                         # Núcleo de la aplicación
│   ├── constants/
│   │   └── api_constants.dart   # URLs y endpoints del backend
│   └── services/
│       └── api_service.dart     # Cliente HTTP con manejo de tokens
│
├── features/                     # Características por dominio
│   ├── auth/                    # Autenticación
│   │   ├── models/
│   │   │   └── user_model.dart
│   │   ├── providers/
│   │   │   └── auth_provider.dart
│   │   └── screens/
│   │       ├── sign_in_screen.dart
│   │       └── sign_up_screen.dart
│   │
│   ├── appointments/            # Gestión de citas
│   │   ├── models/
│   │   │   └── appointment_model.dart
│   │   ├── providers/
│   │   │   └── appointment_provider.dart
│   │   └── screens/
│   │       ├── appointments_screen.dart
│   │       └── appointment_detail_screen.dart
│   │
│   ├── vehicles/                # Vehículos del conductor
│   │   ├── models/
│   │   │   └── vehicle_model.dart
│   │   └── screens/
│   │       └── vehicles_screen.dart
│   │
│   ├── workshops/               # Información del taller
│   │   ├── models/
│   │   │   └── workshop_model.dart
│   │   └── screens/
│   │       └── workshop_info_screen.dart
│   │
│   └── home/                    # Pantalla principal
│       └── screens/
│           └── home_screen.dart
│
└── main.dart                    # Punto de entrada
```

### Tecnologías y Dependencias

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # HTTP client para llamadas API
  http: ^1.1.0
  
  # State management con BLoC
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  
  # Almacenamiento local (tokens, preferencias)
  shared_preferences: ^2.2.2
  
  # Navegación
  go_router: ^14.0.0
  
  # Formateo de fechas
  intl: ^0.19.0
```

### Arquitectura y Patrones de Diseño

#### 1. **BLoC Pattern** (State Management) ✨
- Implementación del patrón BLoC (Business Logic Component)
- **Un solo BLoC por bounded context** siguiendo el [learning-center](https://github.com/upc-pre-202520-1asi0730-7461/learning-center)
- `AuthBloc`: Maneja toda la lógica de autenticación
- `AppointmentsBloc`: Maneja toda la lógica de citas
- Separación clara entre presentación y lógica de negocio

#### 2. **Clean Architecture** (Capas)
```
domain/ (Entidades y modelos)
  ↓
application/ (BLoCs - Lógica de negocio)
  ↓
presentation/ (Screens - UI)
```

#### 3. **Domain-Driven Design (DDD)**
- Bounded Contexts: Auth, Appointments, Vehicles, Workshops
- Modelos de dominio separados por contexto
- **Models**: Entidades de dominio con lógica de transformación
- **BLoCs**: Lógica de negocio centralizada
- **Screens**: UI reactiva sin lógica de negocio

📖 **Ver [BLOC_ARCHITECTURE.md](BLOC_ARCHITECTURE.md) para documentación detallada de la arquitectura**

## 🚀 Configuración e Instalación

### Requisitos Previos

```bash
# Verificar instalación de Flutter
flutter --version
# Flutter 3.9.2 o superior

# Verificar dispositivos disponibles
flutter devices
```

### Instalación

```bash
# 1. Clonar el repositorio (si aún no lo has hecho)
cd safecar-mobile-app

# 2. Instalar dependencias
flutter pub get

# 3. Ejecutar la aplicación
flutter run
```

### Configuración del Backend

**IMPORTANTE**: Antes de ejecutar, configura la URL del backend en:

```dart
// lib/core/constants/api_constants.dart
class ApiConstants {
  // ⚠️ CAMBIAR ESTA URL según tu entorno
  
  // Para emulador Android:
  static const String baseUrl = 'http://10.0.2.2:8080/api/v1';
  
  // Para iOS Simulator:
  // static const String baseUrl = 'http://localhost:8080/api/v1';
  
  // Para dispositivo físico (reemplazar con tu IP):
  // static const String baseUrl = 'http://192.168.1.XXX:8080/api/v1';
  
  // ... rest of file
}
```

### Ejecución en Diferentes Plataformas

```bash
# Android (emulador o dispositivo)
flutter run -d android

# iOS (solo en macOS)
flutter run -d ios

# Web (para pruebas rápidas)
flutter run -d chrome
```

## 📡 Integración con API

### Endpoints Utilizados

#### Autenticación
```http
POST /api/v1/authentication/sign-in
Body: { "username": "juan", "password": "123456" }
Response: { "id": 1, "username": "juan", "token": "eyJ..." }

POST /api/v1/authentication/sign-up
Body: {
  "username": "juan",
  "password": "123456",
  "roles": ["ROLE_DRIVER"]
}
```

#### Citas
```http
GET /api/v1/workshops/{workshopId}/appointments?driverId={driverId}
Response: [
  {
    "id": 1,
    "workshopId": 1,
    "vehicleId": 5,
    "driverId": 3,
    "startAt": "2025-12-15T10:00:00Z",
    "endAt": "2025-12-15T12:00:00Z",
    "status": "CONFIRMED",
    "serviceType": "OIL_CHANGE",
    "mechanicId": 7,
    "notes": [...]
  }
]

GET /api/v1/workshops/{workshopId}/appointments/{id}
Response: { ... }  # Detalle completo de una cita
```

#### Vehículos (próxima implementación)
```http
GET /api/v1/drivers/{driverId}/vehicles
Response: [
  {
    "id": 5,
    "licensePlate": "ABC-123",
    "brand": "Toyota",
    "model": "Corolla",
    "year": 2020
  }
]
```

#### Talleres (próxima implementación)
```http
GET /api/v1/workshops/{workshopId}
Response: {
  "id": 1,
  "name": "AutoService",
  "address": "Av. Principal 123",
  "phoneNumber": "+51 987654321",
  "email": "contact@autoservice.com"
}
```

### Manejo de Tokens

```dart
// Almacenar token después del login
await _apiService.storeToken(authResponse.token);
await _apiService.storeUserId(authResponse.id);

// Los tokens se incluyen automáticamente en todas las peticiones
Future<Map<String, String>> _getHeaders() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  if (token != null) {
    headers['Authorization'] = 'Bearer $token';
  }
  
  return headers;
}
```

## 🎨 Interfaz de Usuario

### Pantallas Principales

#### 1. Sign In
- Input de usuario y contraseña
- Validación de campos
- Indicador de carga
- Enlace a Sign Up

#### 2. Sign Up
- Formulario completo con:
  - Información personal (nombre, apellido, email, teléfono)
  - Información de cuenta (usuario, contraseña)
- Validaciones en tiempo real
- Confirmación de contraseña

#### 3. Home (Bottom Navigation)
- **Citas** (tab principal)
  - Lista de citas con tarjetas
  - Colores según estado:
    - 🟠 Naranja: Pendiente
    - 🔵 Azul: Confirmada
    - 🟣 Morado: En Progreso
    - 🟢 Verde: Completada
    - 🔴 Rojo: Cancelada
  - Información resumida:
    - Tipo de servicio
    - Fecha y hora
    - Estado
- **Vehículos** (tab secundario)
  - Placeholder para futura implementación
- **Taller** (tab terciario)
  - Placeholder para futura implementación

#### 4. Detalle de Cita
- Banner de estado con icono y color
- Secciones organizadas:
  - Tipo de servicio
  - Descripción (si existe)
  - Fecha completa
  - Horario
  - Vehículo
  - Mecánico asignado
  - Notas del servicio (si existen)

### Tema y Diseño

```dart
ThemeData(
  primaryColor: Color(0xFF4A60D0),  // Azul corporativo SafeCar
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFF4A60D0),
  ),
  useMaterial3: true,
  
  // AppBar con color primario
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF4A60D0),
    foregroundColor: Colors.white,
  ),
  
  // Botones elevados con color primario
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF4A60D0),
      foregroundColor: Colors.white,
    ),
  ),
)
```

## 🔍 Flujo de Uso

### Primera Vez (Nuevo Usuario)

1. Usuario abre la app → ve Sign In
2. Toca "¿No tienes cuenta? Regístrate"
3. Llena formulario de registro
4. Toca "Registrarse"
5. Sistema crea cuenta y hace login automático
6. Redirige a Home → tab de Citas

### Usuario Existente

1. Usuario abre la app → ve Sign In
2. Ingresa usuario y contraseña
3. Toca "Iniciar Sesión"
4. Sistema valida y almacena token
5. Redirige a Home → tab de Citas

### Navegación Principal

```
Home (BottomNavigationBar)
├── Citas (appointments_screen)
│   └── [Toca cita] → Detalle (appointment_detail_screen)
│       └── [Back button] → Vuelve a lista
├── Vehículos (vehicles_screen)
│   └── [Placeholder por ahora]
└── Taller (workshop_info_screen)
    └── [Placeholder por ahora]
```

### Ver Citas

1. Usuario está en tab "Citas"
2. Ve lista de sus citas (cargadas del backend)
3. Tarjetas muestran:
   - Estado con color distintivo
   - Tipo de servicio
   - Fecha y hora
   - Indicador de mecánico asignado
4. Usuario toca una cita
5. Ve pantalla de detalle con toda la información

### Pull to Refresh

1. Usuario arrastra hacia abajo en lista de citas
2. Aparece indicador de recarga
3. Se hace nueva petición al backend
4. Lista se actualiza con datos frescos

### Cerrar Sesión

1. Usuario toca icono de logout (en AppBar)
2. Sistema borra token y datos locales
3. Redirige a Sign In

## 🧪 Testing

### Tests Unitarios (Próxima versión)

```bash
flutter test
```

### Tests de Integración (Próxima versión)

```bash
flutter test integration_test/
```

### Testing Manual

1. **Autenticación**:
   - [ ] Registro exitoso
   - [ ] Login exitoso
   - [ ] Login con credenciales incorrectas
   - [ ] Persistencia de sesión (cerrar y abrir app)
   - [ ] Logout

2. **Citas**:
   - [ ] Cargar lista de citas
   - [ ] Ver detalle de cita
   - [ ] Pull to refresh
   - [ ] Estados mostrados correctamente
   - [ ] Colores según estado

3. **Navegación**:
   - [ ] Bottom navigation funciona
   - [ ] Back button funciona
   - [ ] Transiciones suaves

## 🐛 Troubleshooting

### Error: No se conecta al backend

**Problema**: App muestra "Failed to load appointments"

**Solución**:
1. Verificar que el backend esté corriendo:
   ```bash
   curl http://localhost:8080/api/v1/workshops/1/appointments
   ```
2. Verificar URL en `api_constants.dart`:
   - Emulador Android: `http://10.0.2.2:8080/api/v1`
   - iOS Simulator: `http://localhost:8080/api/v1`
   - Dispositivo físico: `http://[TU_IP]:8080/api/v1`
3. Verificar que no haya firewall bloqueando
4. Verificar CORS habilitado en backend

### Error: Token expirado

**Problema**: Después de un tiempo, las requests fallan con 401

**Solución**:
- Implementar refresh token (próxima versión)
- Por ahora: cerrar sesión y volver a iniciar

### Error: Exception: SocketException

**Problema**: No hay conexión a internet

**Solución**:
- Verificar conexión WiFi/datos
- En emulador, verificar que tenga acceso a internet

### App se cierra inesperadamente

**Problema**: Crash al abrir

**Solución**:
```bash
# Limpiar build
flutter clean
flutter pub get

# Reinstalar
flutter run
```

## 📈 Próximas Mejoras

### Versión 1.1
- [ ] Implementar lista de vehículos con API
- [ ] Implementar información de taller con API
- [ ] Agregar búsqueda y filtros en citas
- [ ] Agregar ordenamiento (por fecha, estado)

### Versión 1.2
- [ ] **Notificaciones Push**:
  - Cuando taller crea una cita
  - Cuando cambia estado de cita
  - Recordatorio 24h antes de la cita
- [ ] **Solicitud de Citas**:
  - Conductor puede solicitar citas
  - Taller las aprueba/rechaza

### Versión 1.3
- [ ] Chat en tiempo real con el taller
- [ ] Historial detallado de mantenimiento por vehículo
- [ ] Fotos del vehículo antes/después del servicio
- [ ] Sistema de calificación y reseñas

### Versión 2.0
- [ ] Modo oscuro
- [ ] Multi-idioma (inglés, español)
- [ ] Pagos integrados (Stripe/PayPal)
- [ ] Integración con Google Maps (ubicación del taller)
- [ ] AR para mostrar problemas del vehículo

## 🤝 Contribución

Para contribuir al proyecto:

1. Fork el repositorio
2. Crea una branch: `git checkout -b feature/nueva-funcionalidad`
3. Commit cambios: `git commit -m 'Add nueva funcionalidad'`
4. Push: `git push origin feature/nueva-funcionalidad`
5. Abre un Pull Request

## 📄 Licencia

Copyright © 2025 MetaSoft IoT Solutions - SafeCar

---

## 📞 Soporte

Para reportar bugs o solicitar funcionalidades:
- GitHub Issues: [metasoft-iot/safecar](https://github.com/metasoft-iot/safecar/issues)
- Email: support@safecar.com

---

**¡Gracias por usar SafeCar Mobile App!** 🚗✨
