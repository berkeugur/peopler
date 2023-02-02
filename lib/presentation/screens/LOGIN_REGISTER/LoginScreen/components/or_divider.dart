import 'package:flutter/material.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: 1,
            color: Colors.grey[500],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "VEYA",
            style: PeoplerTextStyle.normal.copyWith(
              color: Colors.grey[500],
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            height: 1,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }
}
