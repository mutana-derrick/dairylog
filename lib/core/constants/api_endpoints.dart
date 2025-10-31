/// Defines all API endpoints used throughout the app.
///
/// Keeping endpoints centralized helps maintain consistency and makes it
/// easier to switch environments (e.g., dev, staging, prod).
class ApiEndpoints {
  // Base URL (used in DioClient)
  static const String baseUrl = "https://sea-lion-app-p7ri7.ondigitalocean.app/api";

  // ===== Authentication =====
  static const String login = "/auth/login";           
  static const String logout = "/auth/logout";         
  static const String refreshToken = "/auth/refresh";  // For future token refresh

  // ===== Farmers =====
  static const String farmers = "/farmers";            
  static String farmerById(String id) => "/farmers/$id";
  static String farmerByPhone(String phone) => "/farmers/phone/$phone";
  
  // ===== Milk Records =====
  static const String milkRecords = "/milk-records";   
  static String milkRecordById(String id) => "/milk-records/$id";
  static const String addMilkRecord = "/milk-records"; // POST to same endpoint
  static String milkRecordsByFarmer(String farmerId) => "/milk-records/farmer/$farmerId";

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