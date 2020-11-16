import 'package:app_version_checker/app_version_checker.dart';

main() async {
  try {
    String appId = 'your_app_id';
    CheckerResult remoteVersion = await AppVersionChecker.checkVersion(appId);
    print(remoteVersion);
    // ex) 1.0.0
  } catch (error) {
    print(error);
  }
  try {
    String appId = 'your_app_id';
    bool updateAvailable = await AppVersionChecker.simpleCheck(appId);
    print(updateAvailable);
    // If the version of Playstore of AppStore, returns true. Otherwise, returns false.
  } catch (error) {
    print(error);
  }
}
