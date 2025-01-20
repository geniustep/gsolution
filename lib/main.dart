import 'package:gsolution/common/app.dart';
import 'package:gsolution/common/config/dependencies.dart';
import 'package:gsolution/common/config/hive/hive_service.dart';
import 'package:gsolution/common/config/import.dart';
import 'package:gsolution/common/config/prefs/pref_utils.dart';
import 'package:gsolution/src/utils/location.dart';
import 'package:gsolution/src/utils/permission.dart';
// import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.initHive();
  await MyLocation.getLatAndLong();
  await PermissionPage.requestPermissions();
  // final prefs = await SharedPreferences.getInstance();
  // await prefs.clear();
  Dependencies.injectDependencies();

  DioFactory.initialiseHeaders(await PrefUtils.getToken());

  bool isLoggedIn = await PrefUtils.getIsLoggedIn();
  runApp(App(isLoggedIn));
}
