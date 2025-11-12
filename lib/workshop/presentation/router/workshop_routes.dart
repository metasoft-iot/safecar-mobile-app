library;

import 'package:go_router/go_router.dart';
import 'package:safecar_mobile_app/workshop/presentation/pages/appointments/appointment_details_page.dart';
import 'package:safecar_mobile_app/workshop/presentation/pages/appointments/appointment_page.dart';
import 'package:safecar_mobile_app/workshop/presentation/pages/appointments/create_appointment_page.dart';
import 'package:safecar_mobile_app/workshop/presentation/pages/appointments/reschedule_appointment_page.dart';
import 'package:safecar_mobile_app/workshop/presentation/router/workshop_route_constants.dart';

/// Workshop routes configuration
class WorkshopRoutes {
  /// Returns the workshop route with all its appointment sub-routes
  static GoRoute getWorkshopRoute(String workshopPath) {
    return GoRoute(
      path: workshopPath,
      builder: (context, state) => const AppointmentPage(),
      routes: [
        GoRoute(
          path: AppointmentRoutePaths.details,
          name: AppointmentRouteNames.details,
          builder: (context, state) {
            final appointmentId = state.pathParameters['id']!;
            return AppointmentDetailsPage(appointmentId: appointmentId);
          },
        ),
        GoRoute(
          path: AppointmentRoutePaths.create,
          name: AppointmentRouteNames.create,
          builder: (context, state) => const CreateAppointmentPage(),
        ),
        GoRoute(
          path: AppointmentRoutePaths.reschedule,
          name: AppointmentRouteNames.reschedule,
          builder: (context, state) {
            final appointmentId = state.pathParameters['id']!;
            return RescheduleAppointmentPage(appointmentId: appointmentId);
          },
        ),
      ],
    );
  }
}
