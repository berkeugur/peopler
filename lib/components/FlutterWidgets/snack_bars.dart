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
}
