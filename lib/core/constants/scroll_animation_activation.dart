import 'package:flutter/widgets.dart';

class ScrollAnimationsConstants {
  bool isActive(BuildContext context, ScrollController scrollController) {
    return scrollController.position.pixels > MediaQuery.of(context).size.height * 0.7;
  }
}
