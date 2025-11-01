/// Defines all API endpoints used throughout the app.
///
/// Keeping endpoints centralized helps maintain consistency and makes it
/// easier to switch environments (e.g., dev, staging, prod).
class ApiEndpoints {
  // Base URL (used in DioClient)
  static const String baseUrl =
      "https://sea-lion-app-p7ri7.ondigitalocean.app/api";

  // ===== Authentication =====
  static const String login = "/auth/login";
  static const String logout = "/auth/logout";
  static const String refreshToken = "/auth/refresh-token"; 
      

  // User Profile
  static const String userProfile = "/user/profile";

  // ===== Farmers =====
  static const String farmers =  "/farmer"; // ✅ Note: singular "farmer" in your API 
  static String farmerById(int id) => "/farmer/$id";
  static const String farmerLookup = "/farmer/lookup"; // ✅ Added

  // ===== Milk Records =====
  static const String milkRecords = "/milk-record";
  static String milkRecordById(int id) => "/milk-record/$id";
  static const String farmerMilkHistory = "/milk-record/farmer-history";

  // ===== Reports =====
  static const String reports = "/reports";
  static const String dailyReport = "/reports/daily";
  static const String weeklyReport = "/reports/weekly";
  static const String monthlyReport = "/reports/monthly";

  // ===== Profile =====
  static const String profile = "/profile";
  static const String updateProfile = "/profile";

  // ===== Sync (Offline) =====
  static const String sync = "/sync";
  static const String syncFarmers = "/sync/farmers";
  static const String syncMilkRecords = "/sync/milk-records";

  // ===== SMS =====
  static const String sendSms = "/sms/send";
}