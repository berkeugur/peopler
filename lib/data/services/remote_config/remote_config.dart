import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../../../others/strings.dart';

class FirebaseRemoteConfigService  {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initConfig() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 1), // a fetch will wait up to 10 seconds before timing out
      minimumFetchInterval: const Duration(seconds: 10), // fetch parameters will be cached for a maximum of 1 hour
    ));

    _fetchConfig();
  }

  // Fetching, caching, and activating remote config
  void _fetchConfig() async {
    await _remoteConfig.fetchAndActivate();
  }

  bool isMaintenance()  {
    return _remoteConfig.getBool("maintenance");
  }

  bool isUpdate() {
    return _remoteConfig.getBool(Strings.peopler_version);
  }
}
