import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';

import '../../../core/constants/navigation/navigation_constants.dart';

class BottomButtons extends StatelessWidget {
  final int currentIndex;
  final int dataLength;
  final PageController controller;

  const BottomButtons({Key? key, required this.currentIndex, required this.dataLength, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: currentIndex == dataLength - 1
                ? [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 32,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(40, 3, 40, 3),
                          decoration: BoxDecoration(color: const Color(0xFF0353EF), borderRadius: BorderRadius.circular(20)),
                          child: TextButton(
                            child: Text(
                              "BAŞLAYALIM",
                              textAlign: TextAlign.center,
                              textScaleFactor: 1,
                              style: GoogleFonts.rubik(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed(NavigationConstants.WELCOME);
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
                        Navigator.of(context).pushNamed(NavigationConstants.WELCOME);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        "ATLA",
                        textScaleFactor: 1,
                        style: GoogleFonts.rubik(fontWeight: FontWeight.w600, color: Color(0xFF000B21)),
                      ),
                    ),
                  ],
          );
        });
  }
}
