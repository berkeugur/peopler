import 'package:flutter/material.dart';

Widget cachedNetworkErrorImageWidget(String gender) {
  AssetImage _image;
  if (gender == "Erkek") {
    _image = const AssetImage('assets/images/default_profile_images/male.jpg');
  } else if (gender == "Kadın") {
    _image = const AssetImage('assets/images/default_profile_images/female.jpg');
  } else {
    _image = const AssetImage('assets/images/default_profile_images/other.jpg');
  }

  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      image: DecorationImage(image: _image, fit: BoxFit.cover),
    ),
  );
}
