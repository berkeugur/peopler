import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import 'package:peopler/presentation/screens/profile/MyProfile/ProfileScreen/profile_screen.dart';
import 'package:peopler/presentation/screens/profile_edit/profile_edit.dart';

import '../../../../components/dialogs.dart';

class PhotoService {
  static saveChanges(context, _controller) {
    List.generate(images2.length, (index) async {
      //STORAGE
      print("*********************** 9 **********************");
      if (images2[index].runtimeType.toString() != "String") {
        print("****************  STORAGE ****************");
        //STORAGE
        Reference _storageReference = FirebaseStorage.instance
            .ref()
            .child(UserBloc.user!.userID)
            .child("photos")
            .child(images2[index].toString().split("/").last.replaceAll("'", "").replaceAll("""""" "", ""));
        await _storageReference.putFile(images2[index]);
        //gs://peopler-2376c.appspot.com/G4yKPJketQU8dm2GjDfeZZXHt8Z2/profile_photo/profile_photo.png
        print(_storageReference.fullPath);
        print(FirebaseStorage.instance.ref(_storageReference.fullPath));
        //STORAGE
        print("****************  STORAGE ****************");

        // ignore: avoid_single_cascade_in_expression_statements
        FirebaseFirestore.instance.collection("users").doc(UserBloc.user!.userID)
          ..update({
            "photosURL": FieldValue.arrayUnion([await FirebaseStorage.instance.ref(_storageReference.fullPath).getDownloadURL()])
          }).then((value) async {
            UserBloc.user!.photosURL.add(await FirebaseStorage.instance.ref(_storageReference.fullPath).getDownloadURL());

            images2[index] = await FirebaseStorage.instance.ref(_storageReference.fullPath).getDownloadURL();
            print("${FirebaseStorage.instance.ref(_storageReference.fullPath).getDownloadURL()} eklendi");

            //setStateValue

            Future.delayed(Duration(milliseconds: 500), () {
              setStateProfileScreen.value = !setStateProfileScreen.value;
              setStateProfileScreen.value = !setStateProfileScreen.value;
            }).then((value) {
              setStateProfileScreen.value = !setStateProfileScreen.value;

              setStateProfileScreen.value = !setStateProfileScreen.value;
              PeoplerDialogs.showSuccessfulDialog(context, _controller).then((value) => Navigator.of(context).pop());
            });
          }).onError(
            (error, stackTrace) {
              print("$error");
            },
          );
      }
    });
  }
}
