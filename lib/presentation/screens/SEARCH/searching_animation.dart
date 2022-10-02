// ignore_for_file: must_be_immutable

import 'dart:math';
import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchingCase extends StatefulWidget {
  double? height;
  double? width;
  String? svgIconPath;
  SearchingCase({Key? key, this.height, this.width, this.svgIconPath}) : super(key: key);

  @override
  _SearchingCaseState createState() => _SearchingCaseState();
}

class _SearchingCaseState extends State<SearchingCase> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        } else if (status == AnimationStatus.completed) {
          _animationController.repeat();
        }
      });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.height == null ? widget.height = MediaQuery.of(context).size.height : null;
    widget.width == null ? widget.width = MediaQuery.of(context).size.width : null;
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(painter: MyCustomPainter(_animation.value), child: Container()),
            CustomAnimatedSearchIcon(
              svgIconPath: widget.svgIconPath,
            ),
          ],
        ),
      ),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  final double animationValue;

  MyCustomPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (int value = 3; value >= 0; value--) {
      circle(canvas, Rect.fromLTRB(0, 0, size.width, size.height), value + animationValue);
    }
  }

  void circle(Canvas canvas, Rect rect, double value) {
    Paint paint = Paint()..color = const Color(0xFF0353EF).withOpacity((1 - (value / 4)).clamp(.0, 1));

    canvas.drawCircle(rect.center, sqrt((rect.width * .5 * rect.width * .5) * value / 4), paint);
  }

  @override
  bool shouldRepaint(MyCustomPainter oldDelegate) {
    return true;
  }
}

class CustomAnimatedSearchIcon extends StatefulWidget {
  String? svgIconPath;
  CustomAnimatedSearchIcon({Key? key, this.svgIconPath}) : super(key: key);

  @override
  _CustomAnimatedSearchIconState createState() => _CustomAnimatedSearchIconState();
}

class _CustomAnimatedSearchIconState extends State<CustomAnimatedSearchIcon> {
  @override
  Widget build(BuildContext context) {
    widget.svgIconPath == null ? widget.svgIconPath = "assets/images/svg_icons/search.svg" : null;
    return SizedBox(
      height: 75,
      width: 75,
      child: Animator<double>(
        duration: const Duration(milliseconds: 1200),
        cycles: 0,
        curve: Curves.easeInOut,
        tween: Tween<double>(begin: 0.0, end: 15.0),
        builder: (context, animatorState, child) => Container(
          margin: EdgeInsets.all(animatorState.value),
          child: SvgPicture.asset(
            widget.svgIconPath!,
            color: Colors.white,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
