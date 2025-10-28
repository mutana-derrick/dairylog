import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'router.dart';

/// 🧭 App Router Provider
/// Exposes a single instance of GoRouter that can react to authentication
/// or onboarding states.
final appRouterProvider = Provider<GoRouter>((ref) {
  return createRouter(ref);
});

/// 🎨 Theme Mode Provider
/// Controls whether the app uses light or dark mode.
/// You can later extend this to persist the user’s choice via Hive or SharedPreferences.
final themeModeProvider =
    StateProvider<ThemeMode>((ref) => ThemeMode.light);

/// 🔒 Authentication State Provider (Placeholder)
/// This will later watch your auth state (JWT/session).
/// The router will use this to decide whether to show login or home screen.
/// Currently just a placeholder for integration later.
final authStateProvider = StateProvider<bool>((ref) => false);
