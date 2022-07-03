import 'package:flutter/material.dart';
import '../../others/locator.dart';
import '../services/connectivity/connectivity_service.dart';

class ConnectivityRepository {
  final ConnectivityService _connectivityServices =
      locator<ConnectivityService>();

  Future<bool> checkConnection(context) async {
    bool _wifiOrMobileOpen = await _connectivityServices.checkWifiOrMobileOpen();
    if (_wifiOrMobileOpen == true) {
      bool _connectivity = await _connectivityServices.checkConnectivity();
      if (_connectivity == true) return true;
      _buildDialog(context, 'NoConnection');
      return false;
    } else {
      _buildDialog(context, 'NoWifiOrMobile');
      return false;
    }
  }

  void _buildDialog(context, String errorType) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: errorType == 'NoWifiOrMobile'
                  ? const Text('Interface Problem')
                  : const Text('Connection Problem'),
              content: errorType == 'NoWifiOrMobile'
                  ? const Text('Please open your Wifi or Mobile Network')
                  : const Text('Your interface has lack of connection problem'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Okay'),
                )
              ],
            ));
  }
}
