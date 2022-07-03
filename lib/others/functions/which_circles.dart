///like whichCircles(-260,-300);
List<dynamic>whichCircles(int x, int y){
  final int r = 300;
  int minX =  x - (x % r);
  int minY =  y - (y % r);

  int maxX = minX + r;
  int maxY = minY + r;

  List<dynamic> circlesCenterCoordinates = [];

    circlesCenterCoordinates.clear();
    circlesCenterCoordinates.add("$minX, $minY");
    circlesCenterCoordinates.add("$minX, $maxY");
    circlesCenterCoordinates.add("$maxX, $minY");
    circlesCenterCoordinates.add("$maxX, $maxY");

  print(circlesCenterCoordinates);

  return circlesCenterCoordinates;
}

