// ignore: camel_case_types
class SVG_PATHS {
  //folder paths
  static const String _assets = 'assets';
  static const String _folder1 = 'images';
  static const String _folder2 = 'svg_icons';
  static const String _search = 'search';
  //folder extension path
  static const String _extension = 'svg';
  //svg file names
  static const String _locationPin = 'location_pin';
  //getters
  static String get searchPath => "$_assets/$_folder1/$_folder2/$_search.$_extension";
  static String get locationPinPath => "$_assets/$_folder1/$_folder2/$_locationPin.$_extension";
}
