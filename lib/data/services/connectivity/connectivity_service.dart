import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';

class ConnectivityService {
  Future<bool> checkWifiOrMobileOpen() async {
    ConnectivityResult connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) return true;
    if (connectivityResult == ConnectivityResult.wifi) return true;
    return false;
  }

  Future<bool> checkConnectivity() async {
    try {
      final response = await InternetAddress.lookup('www.google.com');
      if (response.isNotEmpty) return true;
      return false;
    } on SocketException catch (err) {
        debugPrint(err.toString());
        return false;
    }
  }
}
