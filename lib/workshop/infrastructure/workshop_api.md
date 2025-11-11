# Workshop API

Servicio principal de comunicación con el backend.

## Responsabilidades
- Coordinar llamadas a diferentes endpoints
- Transformar entities a DTOs (usando assemblers)
- Manejar errores HTTP

## Dependencies
- WorkshopsApiEndpoint
- WorkshopReviewsApiEndpoint
- Assemblers

## Methods
- getWorkshops(): Future<List<Workshop>>
- getWorkshopById(String id): Future<Workshop>
- searchWorkshops(String query): Future<List<Workshop>>
- getNearbyWorkshops(Coordinates, Distance): Future<List<Workshop>>
- addReview(WorkshopId, WorkshopReview): Future<Workshop>
