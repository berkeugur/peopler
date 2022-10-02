import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/core/constants/navigation/navigation_constants.dart';
import 'package:peopler/data/repository/location_repository.dart';
import '../../../../others/locator.dart';

class BegForPermissionScreen extends StatefulWidget {
  const BegForPermissionScreen({Key? key}) : super(key: key);

  @override
  _BegForPermissionScreenState createState() => _BegForPermissionScreenState();
}

class _BegForPermissionScreenState extends State<BegForPermissionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0353EF),
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
                Container(
                  //color: Colors.orange,
                  child: Text(
                    "Konum servisi arka planda çalışsın mı?",
                    textScaleFactor: 1,
                    style: GoogleFonts.rubik(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox.square(
                  dimension: 10,
                ),
                Container(
                  //color: Colors.yellow,
                  child: Text(
                    "Uygulama kapalıyken bile peopler topluluğuyla etkileşime geçebilirsiniz. \n\nVerilerinizin gizliliği ve batarya performansı için endişelenmeyin. ",
                    textScaleFactor: 1,
                    style: GoogleFonts.rubik(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                /*
                InkWell(
                  onTap: () async {
                    final LocationRepository _locationRepository = locator<LocationRepository>();
                    _locationRepository.openPermissionSettings();
                    // We use delay here because when user clicked this button, he/she will be redirected to permission settings first.
                    await Future.delayed(const Duration(seconds: 10));
                    Navigator.of(context).pushNamedAndRemoveUntil(NavigationConstants.HOME_SCREEN, (Route<dynamic> route) => false);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(99)),
                    child: Center(
                        child: Text(
                          "Her zaman izin ver",
                          textScaleFactor: 1,
                          style: GoogleFonts.rubik(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0353EF)),
                        )),
                  ),
                ),
                 */
                const SizedBox.square(
                  dimension: 10,
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(99),
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(NavigationConstants.HOME_SCREEN, (Route<dynamic> route) => false);
                  },
                  child: Container(
                    //color: Colors.purple,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Text(
                      "Devam Et",
                      // "Bu adımı atla",
                      textScaleFactor: 1,
                      style: GoogleFonts.rubik(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
              ],
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
            shape: CircleBorder(),
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
