import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../iam/application/blocs/auth_bloc.dart';
import '../../iam/application/blocs/auth_state.dart';
import '../../iam/presentation/pages/login_screen.dart';
import '../../iam/presentation/pages/register_screen.dart';


class AppRouter {
  final AuthBloc authBloc;
  late final GoRouter router;

  AppRouter(this.authBloc) {
    router = GoRouter(
      refreshListenable: _AuthRefreshStream(authBloc.stream),

      initialLocation: '/login',

      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),

        // GoRoute(
        //   path: '/vehicles',
        //   builder: (context, state) => const VehiclesScreen(),
        // ),
      ],

      redirect: (BuildContext context, GoRouterState state) {
        final location = state.matchedLocation;

        final authState = authBloc.state;

        final publicRoutes = ['/login', '/register'];

        if (authState is AuthInitial || authState is AuthLoading) {
          return null;
        }

        if (authState is Unauthenticated) {
          if (!publicRoutes.contains(location)) {
            return '/login';
          }
        }

        if (authState is Authenticated) {
          if (publicRoutes.contains(location)) {
            return '/dashboard';
          }
        }

        return null;
      },
    );
  }
}

class _AuthRefreshStream extends ChangeNotifier {
  late final StreamSubscription<AuthState> _subscription;
  _AuthRefreshStream(Stream<AuthState> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}