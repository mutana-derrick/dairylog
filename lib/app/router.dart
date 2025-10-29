import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/dashboard/presentation/screens/home_screen.dart';
import '../features/farmers/presentation/screens/add_farmer_screen.dart';
import '../features/farmers/presentation/screens/farmers_screen.dart';
import '../features/milk_records/presentation/screens/add_milk_record_screen.dart';
import '../features/milk_records/presentation/screens/milk_records_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/reports/presentation/screens/reports_screen.dart';
import 'providers.dart';

/// Creates and configures the app's GoRouter instance.
/// This function is called from app/providers.dart (appRouterProvider).
GoRouter createRouter(Ref ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    refreshListenable:
        GoRouterRefreshStream(ref.watch(authStateProvider.notifier).stream),

    /// Redirects help ensure correct navigation depending on authentication.
    redirect: (context, state) {
      final isLoggedIn = authState;
      final isOnLogin = state.matchedLocation == '/login';
      final isOnSplash = state.matchedLocation == '/splash';

      // Wait at splash first
      if (isOnSplash) return null;

      // If not logged in → always redirect to login
      if (!isLoggedIn && !isOnLogin) return '/login';

      // If logged in → redirect away from login
      if (isLoggedIn && isOnLogin) return '/home';

      // Else stay where you are
      return null;
    },

    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/farmers',
        name: 'farmers',
        builder: (context, state) => const FarmersScreen(),
      ),
      GoRoute(
        path: '/addFarmers',
        name: 'add-farmers',
        builder: (context, state) => const AddFarmerScreen(),
      ),
      GoRoute(
        path: '/milk-records',
        name: 'milk-records',
        builder: (context, state) => const MilkRecordsScreen(),
      ),
      GoRoute(
        path: '/addMilkRecord',
        name: 'add-milk-record',
        builder: (context, state) => const AddMilkRecordScreen(),
      ),
      GoRoute(
        path: '/reports',
        name: 'reports',
        builder: (context, state) => const ReportsScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}

/// Utility class that helps GoRouter rebuild when Riverpod providers update.
/// It listens to a Riverpod stream and notifies the router.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
