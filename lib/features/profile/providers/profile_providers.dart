import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Profile state model (for now we can use a simple Map)
typedef ProfileState = Map<String, dynamic>;

/// StateNotifier to manage profile data
class ProfileNotifier extends StateNotifier<ProfileState?> {
  ProfileNotifier() : super(null) {
    loadProfile();
  }

  /// Loads profile data (currently static, later replace with API call)
  void loadProfile() {
    // Temporary static data
    state = {
      'name': 'Dairy Manager',
      'email': 'manager@dairy.com',
      'phone': '+250 788 123 456',
      'totalFarmers': 125,
      'monthlyMilkTotal': 3450, // liters
    };
  }

  /// Example method to update profile data
  void updateProfile(ProfileState newProfile) {
    state = {...state!, ...newProfile};
  }
}

/// Riverpod provider for ProfileNotifier
final profileProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState?>(
  (ref) => ProfileNotifier(),
);
