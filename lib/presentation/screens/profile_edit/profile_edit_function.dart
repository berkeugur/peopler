// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/others/functions/search_functions.dart';
import 'package:peopler/presentation/screens/profile_edit/image_functions.dart';
import 'package:peopler/presentation/screens/profile_edit/profile_edit.dart';

import '../../../others/strings.dart';
import '../profile/MyProfile/ProfileScreen/profile_screen.dart';

saveButtonFunction(String changedCity) async {
  print("*********************** 1 **********************");
  CollectionReference _referance = FirebaseFirestore.instance.collection('users');

  if (nameController.text != UserBloc.user!.displayName && nameController.text.isNotEmpty) {
    _referance.doc(UserBloc.user!.userID).update({
      "displayName": nameController.text,
    }).then((value) {
      UserBloc.user!.displayName = nameController.text;

      print("customDialog99(context, 'İşlem başarılı', 'Adınız ${nameController.text} ile değiştirildi.')");
    }).catchError((error) => print("_customDialog(context, 'Server Upload Error', 'error #99821'));"));
  } else if (nameController.text.isEmpty) {
    print("    customDialog99(context, 'Tam adınız boş olamaz', 'Lütfen tam adınız bölümünü doldurun');");
  }
  print("*********************** 2 **********************");
  if (bioController.text != UserBloc.user!.biography) {
    _referance.doc(UserBloc.user!.userID).update({
      "biography": bioController.text,
    }).then((value) {
      UserBloc.user!.biography = bioController.text;
      print("_customDialog(context, 'İşlem başarılı', 'biyografi değiştirildi');");
    }).catchError((error) => print("customDialog(context, 'Server Upload Error', 'error #99821'))"));
  }
  print("*********************** 3 **********************");
  if (schoolNameController.text != UserBloc.user!.schoolName) {
    _referance.doc(UserBloc.user!.userID).update({
      "schoolName": schoolNameController.text,
    }).then((value) {
      UserBloc.user!.schoolName = schoolNameController.text;
      print("_customDialog(context, 'İşlem başarılı', 'okul adı değiştirildi');");
    }).catchError((error) => print("_customDialog(context, 'Server Upload Error', 'error #99821'));"));
  }
  print("*********************** 4 **********************");
  if (currentJobNameController.text != UserBloc.user!.currentJobName) {
    _referance.doc(UserBloc.user!.userID).update({
      "currentJobName": currentJobNameController.text,
    }).then((value) {
      UserBloc.user!.currentJobName = currentJobNameController.text;
      print("_customDialog(context, 'İşlem başarılı', 'meslek değiştirildi');");
    }).catchError((error) => print("_customDialog(context, 'Server Upload Error', 'error #99821'));"));
  }
  print("*********************** 5 **********************");
  if (companyNameController.text != UserBloc.user!.company) {
    _referance.doc(UserBloc.user!.userID).update({
      "company": companyNameController.text,
    }).then((value) {
      UserBloc.user!.company = companyNameController.text;
      print("_customDialog(context, 'İşlem başarılı', 'şirket değiştirildi');");
    }).catchError((error) => print("_customDialog(context, 'Server Upload Error', 'error #99821'));"));
  }
  print("*********************** 6 **********************");
  if (changedCity != "" && changedCity != UserBloc.user!.city) {
    _referance.doc(UserBloc.user!.userID).update({
      "city": changedCity,
    }).then((value) {
      UserBloc.user?.city = changedCity;

      print("_customDialog(context, 'İşlem başarılı', 'şehir değiştirildi');");
    }).catchError((error) => print("_customDialog(context, 'Server Upload Error', 'error #99821'));"));
  } else {
    print("şehir değiştirme çalışmadı changedCity, ${UserBloc.user!.city}");
  }
  print("*********************** 7 **********************");
  if (newProfileimage != null) {
    Reference _storageReference = FirebaseStorage.instance.ref().child(UserBloc.user!.userID).child("profile_photo").child("profile_photo.png");
    await _storageReference.putFile(newProfileimage!);
    //gs://peopler-2376c.appspot.com/G4yKPJketQU8dm2GjDfeZZXHt8Z2/profile_photo/profile_photo.png
    print(_storageReference.fullPath);
    print(FirebaseStorage.instance.ref(_storageReference.fullPath));
    UserBloc.user!.profileURL = await FirebaseStorage.instance.ref(_storageReference.fullPath).getDownloadURL();

    newProfileimage = null;
  }
//
//
//
//
//
//
  print("*********************** 8 **********************");

  //fotoğrafları kaydetme
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
          }).then(
            (value) => setStateProfileScreen.value = !setStateProfileScreen.value,
          );
        }).onError(
          (error, stackTrace) {
            print("$error");
          },
        );
    }
  });
}

cityItemButton(String item, setStateBottomSheet) {
  editingController.clear();
  filterSearchResults("", setStateBottomSheet);

  // DİKKAT - Yorum satırına alındı. 08/07/2022 MERT
  /*
  Strings.cityData.forEach((x) {
    if (x[0][0] == UserBloc.user!.city) {
      items2 = x[1];
      print(items2);
    }
  });
   */

  print("$item değiştirildi:::::");
}
