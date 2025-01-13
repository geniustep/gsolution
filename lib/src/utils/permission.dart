import 'package:permission_handler/permission_handler.dart';

class PermissionPage {
  static Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.mediaLibrary,
      Permission.manageExternalStorage,
      Permission.location,
      Permission.camera,
    ].request();
    print("Storage Permission: ${statuses[Permission.mediaLibrary]}");
    print(
        "Manage External Storage Permission: ${statuses[Permission.manageExternalStorage]}");
    print("Location Permission: ${statuses[Permission.location]}");
    print("Camera Permission: ${statuses[Permission.camera]}");
  }
}
