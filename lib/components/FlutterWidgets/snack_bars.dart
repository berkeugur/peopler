import 'package:flutter/material.dart';

class SnackBars {
  final BuildContext context;

  SnackBars({required this.context});

  simple(String content) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        content: Text(content),
        action: SnackBarAction(
          label: 'kapat',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
            // Some code to undo the change.
          },
        ),
      ),
    );
  }
}
