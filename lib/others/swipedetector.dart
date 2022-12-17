import 'package:flutter/material.dart';

class SwipeConfiguration {
  //Vertical swipe configuration options
  static double verticalSwipeMaxWidthThreshold = 50.0;
  static double verticalSwipeMinDisplacement = 100.0;
  static double verticalSwipeMinVelocity = 300.0;

  //Horizontal swipe configuration options
  static double horizontalSwipeMaxHeightThreshold = 50.0;
  static double horizontalSwipeMinDisplacement = 100.0;
  static double horizontalSwipeMinVelocity = 300.0;
}

class SwipeDetector extends StatelessWidget {
  final Widget child;
  final Function()? onSwipeUp;
  final Function()? onSwipeDown;
  final Function()? onSwipeLeft;
  final Function()? onSwipeRight;

  SwipeDetector({required this.child, this.onSwipeUp, this.onSwipeDown, this.onSwipeLeft, this.onSwipeRight});

  @override
  Widget build(BuildContext context) {
    //Vertical drag details
    DragStartDetails startVerticalDragDetails = DragStartDetails();
    DragUpdateDetails updateVerticalDragDetails = DragUpdateDetails(delta: Offset.zero, globalPosition: const Offset(0, 0));

    //Horizontal drag details
    DragStartDetails startHorizontalDragDetails = DragStartDetails();
    DragUpdateDetails updateHorizontalDragDetails = DragUpdateDetails(delta: Offset.zero, globalPosition: const Offset(0, 0));

    return GestureDetector(
      child: child,
      onVerticalDragStart: (dragDetails) {
        startVerticalDragDetails = dragDetails;
      },
      onVerticalDragUpdate: (dragDetails) {
        updateVerticalDragDetails = dragDetails;
      },
      onVerticalDragEnd: (endDetails) {
        double dx = updateVerticalDragDetails.globalPosition.dx - startVerticalDragDetails.globalPosition.dx;
        double dy = updateVerticalDragDetails.globalPosition.dy - startVerticalDragDetails.globalPosition.dy;
        double velocity = endDetails.primaryVelocity!;

        // Convert values to be positive
        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;
        double positiveVelocity = velocity < 0 ? -velocity : velocity;

        if (dx > SwipeConfiguration.verticalSwipeMaxWidthThreshold) return;
        if (dy < SwipeConfiguration.verticalSwipeMinDisplacement) return;
        if (positiveVelocity < SwipeConfiguration.verticalSwipeMinVelocity) return;

        if (velocity < 0) {
          // Swipe Up
          if (onSwipeUp != null) {
            onSwipeUp!();
          }
        } else {
          // Swipe Down
          if (onSwipeDown != null) {
            onSwipeDown!();
          }
        }
      },
      onHorizontalDragStart: (dragDetails) {
        startHorizontalDragDetails = dragDetails;
      },
      onHorizontalDragUpdate: (dragDetails) {
        updateHorizontalDragDetails = dragDetails;
      },
      onHorizontalDragEnd: (endDetails) {
        double dx = updateHorizontalDragDetails.globalPosition.dx - startHorizontalDragDetails.globalPosition.dx;
        double dy = updateHorizontalDragDetails.globalPosition.dy - startHorizontalDragDetails.globalPosition.dy;
        double velocity = endDetails.primaryVelocity!;

        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;
        double positiveVelocity = velocity < 0 ? -velocity : velocity;

        if (dx < SwipeConfiguration.horizontalSwipeMinDisplacement) return;
        if (dy > SwipeConfiguration.horizontalSwipeMaxHeightThreshold) return;
        if (positiveVelocity < SwipeConfiguration.horizontalSwipeMinVelocity) return;

        if (velocity < 0) {
          // Swipe Up
          if (onSwipeLeft != null) {
            onSwipeLeft!();
          }
        } else {
          // Swipe Down
          if (onSwipeRight != null) {
            onSwipeRight!();
          }
        }
      },
    );
  }
}
