import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';

class TutorialBottomButtons extends StatelessWidget {
  final int currentIndex;
  final int dataLength;
  final PageController controller;

  const TutorialBottomButtons({Key? key, required this.currentIndex, required this.dataLength, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: currentIndex == dataLength - 1
          ? [
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width - 32,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(40, 5, 40, 0),
                    decoration: BoxDecoration(color: const Color(0xFF0353EF), borderRadius: BorderRadius.circular(20)),
                    child: TextButton(
                      child: Text(
                        "BAŞLAYALIM",
                        textScaleFactor: 1,
                        style: PeoplerTextStyle.normal.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        primary: const Color(0xFFFFFFFF),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap, // add this
                        textStyle: const TextStyle(color: Colors.white, fontSize: 18, fontStyle: FontStyle.normal),
                      ),
                    ),
                  ),
                ),
              )
            ]
          : [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "ATLA",
                    textScaleFactor: 1,
                    style: PeoplerTextStyle.normal.copyWith(fontWeight: FontWeight.w600, color: Color(0xFF000B21)),
                  ),
                ),
              ),
            ],
    );
  }
}
