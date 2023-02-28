import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }

  /// Request IOS Notification
  await FirebaseMessaging.instance.requestPermission();

  await setupLocator();
  List<String> mailList = [];

  var data = await FirebaseFirestore.instance.collection("waitinglist").get();
  for (var element in data.docs) {
    if (!mailList.contains(element.data()["email"])) {
      mailList.add(element.data()["email"]);
    }
  }
  print(mailList);
  // await fakeUserCreator();
  // await updateAllFakeUserPhotos();

  runApp(Text("deneme"));
}
