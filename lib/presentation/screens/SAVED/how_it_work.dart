import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';

howItWork(context) {
  return showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF0353EF),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 5,
                  margin: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      999,
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "Nasıl Çalışır?",
                    textScaleFactor: 1,
                    style: PeoplerTextStyle.normal.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            Divider(
              color: Colors.white,
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  "Aynı ortamı paylaştığınız insanları gördüğünüzde ve onları kaydettiğinizde, kaydettiğiniz insanları burada göreceksiniz. \n\nKaydettikten 1 gün sonra artık istek gönderebileceksiniz. \n\nUnutmayın kaydettiğiniz kullanıcılar kaydettikten 3 gün sonra silinir ve onlara istek göndermek için yalnızca 2 gününüz var! ",
                  textScaleFactor: 1,
                  style: PeoplerTextStyle.normal.copyWith(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ]),
            )
          ],
        );
      });
}
