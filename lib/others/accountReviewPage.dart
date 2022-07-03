import "package:flutter/material.dart";
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';

/// eğer kayıt olurken firestore a kaydettiğimiz isTheAccountConfirmed verisi
/// false ise bu ekrana atsın ve bizden onay beklesin
/// onaylamak için admin paneli oluşturalacak
class AccountReviewScreen extends StatelessWidget {
  const AccountReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return Scaffold(
            body: Center(
              child: Column(
                children: const [
                  Text("Hesabınız inceleniyor, incelemenin ardından"
                      "mail ile bildireceğiz.")
                ],
              ),
            ),
          );
        });
  }
}
