/// Defines all API endpoints used throughout the app.
///
/// Keeping endpoints centralized helps maintain consistency and makes it
/// easier to switch environments (e.g., dev, staging, prod).
class ApiEndpoints {
  // Base URL
  static const String baseUrl = "https://api.dairyconnect.rw/api/v1";

  // Authentication
  static const String login = "$baseUrl/auth/login";
  static const String logout = "$baseUrl/auth/logout";

  // Farmers
  static const String farmers = "$baseUrl/farmers";
  static String farmerByPhone(String phone) => "$baseUrl/farmers/phone/$phone";

  // Milk Records
  static const String milkRecords = "$baseUrl/milk-records";
  static String milkRecordById(String id) => "$baseUrl/milk-records/$id";
  static const String addMilkRecord = "$baseUrl/milk-records/add";
  static const String fetchMilkRecords = "$baseUrl/milk-records/fetch";

  // Reports
  static const String reports = "$baseUrl/reports";
  static const String monthlyReport = "$baseUrl/reports/monthly";
  static const String dailyReport = "$baseUrl/reports/daily";

  // Profile
  static const String profile = "$baseUrl/profile";

  // Sync (for offline data upload)
  static const String sync = "$baseUrl/sync";

  // SMS
  static const String sendSms = "$baseUrl/sms/send";
}