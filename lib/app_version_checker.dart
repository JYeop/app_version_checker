library app_version_checker;

import 'dart:convert';
import 'dart:io';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as Http;
import 'package:package_info/package_info.dart';

class AppVersionChecker {
  Future<CheckerResult> checkUpdateAndroid(String packageName) async {
    try {
      Http.Client client = Http.Client();
      var result = await client.get(
        'https://play.google.com/store/apps/details?id=$packageName',
      );
      var parsed = parse(result.body);
      if (parsed.querySelectorAll(".hAyfc .htlgb .IQ1z0d .htlgb").length > 3) {
        return CheckerResult(
          true,
          version: parsed.querySelectorAll(".hAyfc .htlgb .IQ1z0d .htlgb")[3].innerHtml,
        );
      }
      return CheckerResult(
        false,
        errorMessage: 'cannot get version from playstore',
      );
    } catch (error) {
      return CheckerResult(
        false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<CheckerResult> checkUpdateIos(String appId) async {
    try {
      Http.Client client = Http.Client();
      var result = await client.get(
        'https://itunes.apple.com/lookup/id$appId',
      );
      var decoded = jsonDecode(result.body);
      var parsed = decoded['results'][0];
      if (parsed != null) {
        var version = parsed['version'];
        if (version != null) {
          return CheckerResult(true, version: version);
        }
        return CheckerResult(
          false,
          errorMessage: 'cannot get version from playstore',
        );
      }
      return CheckerResult(
        false,
        errorMessage: 'cannot get version from playstore',
      );
    } catch (error) {
      return CheckerResult(
        false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<CheckerResult> checkVersion(String appId) {
    if (Platform.isIOS) {
      return checkUpdateIos(appId);
    }
    return checkUpdateAndroid(appId);
  }

  Future<bool> simpleCheck(String appId) async {
    try {
      CheckerResult result = await checkVersion(appId);
      if (result.success == false) {
        return false;
      }
      String storeVersion = result.version;
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;
      // logger.d(storeVersion);
      // logger.d(currentVersion);
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
  }
}

class CheckerResult {
  bool success;
  String version;
  String errorMessage;

  CheckerResult(this.success, {this.version, this.errorMessage});
}
