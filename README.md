# app_version_checker

A simple app version checker only using http request.

## Getting Started

```dart
import 'package:app_version_checker/app_version_checker.dart';

try {
  String appId = 'your_app_id';
  CheckerResult remoteVersion = await AppVersionChecker.checkVersion(appId);
  // ex) 1.0.0
} catch(error) {
  print(error);
}
```

If you are using the [Semantic Versioning](https://semver.org/), can use another method.
```dart
try {
  String appId = 'your_app_id';
  bool updateAvailable = await AppVersionChecker.simpleCheck(appId);
  // If the version of Playstore of AppStore, returns true. Otherwise, returns false. 
} catch(error) {
  print(error);
}
```

Below is the full example code using the [Semantic Versioning](https://semver.org/).
```dart
try {
  CheckerResult result = await checkVersion(appId);
  if (result.success == false) {
    return false;
  }
  String storeVersion = result.version;
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String currentVersion = packageInfo.version;
  var splicedFromVersion = currentVersion.split('.');
  var v1FromVersion = splicedFromVersion[0];
  var v2FromVersion = splicedFromVersion[1];
  var splicedFromAppStore = storeVersion.split('.');
  var v1FromAppStore = splicedFromAppStore[0];
  var v2FromAppStore = splicedFromAppStore[1];
  if (int.tryParse(v1FromVersion) < int.tryParse(v1FromAppStore)) {
    return true;
  } else if (int.tryParse(v2FromVersion) < int.tryParse(v2FromAppStore)) {
    return true;
  }
  var v3FromVersion = splicedFromVersion[2];
  var v3FromAppStore = splicedFromAppStore[2];
  if (int.tryParse(v2FromVersion) == int.tryParse(v2FromAppStore)) {
    if (int.tryParse(v3FromVersion) < int.tryParse(v3FromAppStore)) {
      return true;
    }
  }
  return false;
} catch (error) {
  print(error);
  return false;
}
```
# app_version_checker
