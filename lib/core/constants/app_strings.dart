/// Centralized collection of app-wide string constants.
///
/// Keeping all strings in one place makes it easier to localize and maintain
/// consistent wording throughout the app.
class AppStrings {
  // App Info
  static const String appName = "DairyConnect";
  static const String slogan = "Smart Milk Record Management";

  // Common Buttons
  static const String login = "Login";
  static const String logout = "Logout";
  static const String save = "Save";
  static const String cancel = "Cancel";
  static const String retry = "Retry";
  static const String add = "Add";
  static const String submit = "Submit";
  static const String delete = "Delete";

  // Auth
  static const String email = "Email";
  static const String password = "Password";
  static const String phoneNumber = "Phone Number";
  static const String loginDescription =
      "Please log in to access your dairy management dashboard.";
  static const String invalidCredentials =
      "Invalid phone number or password. Please try again.";

  // Dashboard
  static const String homeTitle = "Dashboard";
  static const String todayMilk = "Today's Milk (Liters)";
  static const String totalFarmers = "Total Farmers";
  static const String todayFarmers = "Today's Deliveries";
  static const String totalRecords = "Total Records";

  // Farmers
  static const String farmers = "Farmers";
  static const String addFarmer = "Add Farmer";
  static const String farmerDetails = "Farmer Details";
  static const String farmerNotFound =
      "No farmer found with this phone number.";

  // Milk Records
  static const String milkRecords = "Milk Records";
  static const String addMilkRecord = "Add Milk Record";
  static const String liters = "Liters";
  static const String price = "Price";
  static const String milkEntrySuccess =
      "Milk record added successfully!";
  static const String milkEntryError =
      "Failed to add milk record. Please try again.";

  // Reports
  static const String reports = "Reports";
  static const String dailyReport = "Daily Report";
  static const String monthlyReport = "Monthly Report";

  // Profile
  static const String profile = "Profile";
  static const String updateProfile = "Update Profile";
  static const String settings = "Settings";

  // Misc
  static const String loading = "Loading...";
  static const String noData = "No data available";
  static const String offlineMode = "Offline mode active";
  static const String syncSuccess = "Data synced successfully";
  static const String syncFailed = "Sync failed. Try again later.";

  // Errors
  static const String unknownError = "Something went wrong.";
  static const String networkError = "No internet connection.";
  static const String serverError = "Server error occurred.";
}