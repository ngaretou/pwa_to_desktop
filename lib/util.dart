import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'main.dart';

class Connectivity extends ChangeNotifier {
  // this is useful as we can set a sync flag for UI building with no async
  bool connectedSync = true;

  initconnectedsync() async {
    connectedSync = await connected();
  }

  // this is accessible for buttons etc
  final connectionChecker = InternetConnectionChecker.createInstance(
    addresses: List<AddressCheckOption>.unmodifiable(<AddressCheckOption>[
      AddressCheckOption(
        uri: Uri.parse(InternetConnectionCheckerConstants.URL_3),
      ),
      AddressCheckOption(
        uri: Uri.parse(InternetConnectionCheckerConstants.URL_2),
      ),
    ]),
  );

  // this is the really checking way to do it with async
  Future<bool> connected() {
    return connectionChecker.hasConnection;
  }

  // this is a listener, called on app start, and when the connection status changes rebuilds certain widgets
  connectivityInit() {
    connectionChecker.onStatusChange.listen((InternetConnectionStatus status) {
      // here you set that sync flag for connected
      connectedSync = status == InternetConnectionStatus.connected;
      notifyListeners();
    });
    initconnectedsync();
    // print(connectedSync);
  }
}

final instance = InternetConnectionChecker.createInstance(
  addresses: List<AddressCheckOption>.unmodifiable(<AddressCheckOption>[
    AddressCheckOption(
      uri: Uri.parse(InternetConnectionCheckerConstants.URL_3),
    ),
    AddressCheckOption(
      uri: Uri.parse(InternetConnectionCheckerConstants.URL_2),
    ),
  ]),
);

Future<bool> isPWAInstalled() async {
  return userPrefsBox.get('isInstalled') ?? false;
}

void setPWAInstalled({bool installed = true}) async {
  userPrefsBox.put('isInstalled', installed);
}

Future<AppInfo> initData() async {
  String info = await rootBundle.loadString("assets/info.json");
  Map<dynamic, dynamic> data = json.decode(info);
  AppInfo appInfo = AppInfo(title: data['title'] ?? '', url: data['url'] ?? '');
  return appInfo;
}

class AppInfo {
  final String title;
  final String url;

  AppInfo({required this.title, required this.url});
}
