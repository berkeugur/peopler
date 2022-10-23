import 'package:flutter/material.dart';

class SnackBars {
  final BuildContext context;

  SnackBars({required this.context});

  final String _closeLabelText = 'kapat';

  simple(String text) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        content: Text(text),
        action: SnackBarAction(
          label: _closeLabelText,
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
          },
        ),
      ),
    );
  }

  textAnimated(Widget textWidget) {
    ScaffoldMessenger.of(context).clearSnackBars();

    //exaple
    /*
     SnackBars(context: context).textAnimated(
                                          DefaultTextStyle(
                                            style: PeoplerTextStyle.normal.copyWith(
                                              fontSize: 16.0,
                                            ),
                                            child: AnimatedTextKit(
                                              animatedTexts: [
                                                TyperAnimatedText('Yükleniyor...'),
                                                TyperAnimatedText('Çok az kaldı...'),
                                              ],
                                              isRepeatingAnimation: true,
                                            ),
                                          ),
                                          */
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        content: textWidget,
        action: SnackBarAction(
          label: _closeLabelText,
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
          },
        ),
      ),
    );
  }

  void get clear {
    ScaffoldMessenger.of(context).clearSnackBars();
  }
}
