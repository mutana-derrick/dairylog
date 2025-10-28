import 'package:permission_handler/permission_handler.dart';

/// Helper class to manage app permissions
class PermissionHelper {
  /// Request a single permission and return if granted
  static Future<bool> requestPermission(Permission permission) async {  
    final status = await permission.request();
    return status.isGranted;
  }

  /// Check if a permission is already granted
  static Future<bool> isPermissionGranted(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  /// Request multiple permissions at once
  static Future<Map<Permission, PermissionStatus>> requestMultiplePermissions(
      List<Permission> permissions) async {
    return await permissions.request();
  }
}
