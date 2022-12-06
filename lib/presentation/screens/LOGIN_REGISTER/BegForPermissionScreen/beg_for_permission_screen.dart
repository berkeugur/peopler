import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:peopler/components/FlutterWidgets/dialogs.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/core/constants/navigation/navigation_constants.dart';
import 'package:peopler/data/repository/location_repository.dart';
import '../../../../core/system_ui_service.dart';
import '../../../../others/locator.dart';

class BegForPermissionScreen extends StatefulWidget {
  const BegForPermissionScreen({Key? key}) : super(key: key);

  @override
  _BegForPermissionScreenState createState() => _BegForPermissionScreenState();
}

class _BegForPermissionScreenState extends State<BegForPermissionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0353EF),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AnimatedIcon1(),
                const SizedBox.square(
                  dimension: 20,
                ),
                Text(
                  "Arka planda konum servisini kullan",
                  textScaleFactor: 1,
                  style: PeoplerTextStyle.normal.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox.square(
                  dimension: 10,
                ),
                Text(
                  "Bu uygulama kapalı olsa bile aynı ortamındaki insanları görüntüleyebilmen için ve onların da seni görüntüleyebilmesi için konum bilgini kullanır. \nTam konumun kimse ile paylaşılmaz.\n\nİzin veriyor musunuz? ",
                  textScaleFactor: 1,
                  style: PeoplerTextStyle.normal.copyWith(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white),
                ),
              ],
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox.square(
                    dimension: 10,
                  ),
                  InkWell(
                    //borderRadius: BorderRadius.circular(99),
                    onTap: () async {
                      final LocationRepository _locationRepository = locator<LocationRepository>();
                      LocationPermission _permission = await _locationRepository.checkPermissions();
                      if (_permission != LocationPermission.whileInUse && _permission != LocationPermission.always) {
                        await _locationRepository.requestPermission();
                      }

                      /// Set theme mode before Home Screen
                      SystemUIService().setSystemUIforThemeMode();

                      Navigator.of(context).pushNamedAndRemoveUntil(NavigationConstants.HOME_SCREEN, (Route<dynamic> route) => false);
                    },
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(99)),
                      //color: Colors.purple,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      child: Text(
                        "Devam",
                        // "Bu adımı atla",
                        textScaleFactor: 1,
                        style: PeoplerTextStyle.normal.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF0353EF)),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AnimatedIcon1 extends StatefulWidget {
  const AnimatedIcon1({Key? key}) : super(key: key);

  @override
  _AnimatedIcon1State createState() => _AnimatedIcon1State();
}

class _AnimatedIcon1State extends State<AnimatedIcon1> with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )
      ..forward()
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.all(8 - (8 * animationController.value)),
          decoration: ShapeDecoration(
            color: Colors.white.withOpacity(0.5),
            shape: const CircleBorder(),
          ),
          child: Padding(
            padding: EdgeInsets.all(
              8 * animationController.value,
            ),
            child: child,
          ),
        );
      },
      child: Container(
        height: 64,
        width: 64,
        decoration: const ShapeDecoration(
          color: Colors.white,
          shape: CircleBorder(),
        ),
        child: IconButton(
          onPressed: () {
            print('button tapped');
          },
          color: const Color(0xFF0353EF),
          icon: const Icon(
            Icons.location_on_outlined,
            size: 36,
          ),
        ),
      ),
    );
  }
}
