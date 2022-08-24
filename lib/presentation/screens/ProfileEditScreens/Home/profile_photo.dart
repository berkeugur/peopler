import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import 'package:peopler/presentation/screens/ProfileEditScreens/Home/profile_edit_home.dart';

class ProfilePhotoEdit extends StatefulWidget {
  const ProfilePhotoEdit({Key? key}) : super(key: key);

  @override
  State<ProfilePhotoEdit> createState() => _ProfilePhotoEditState();
}

class _ProfilePhotoEditState extends State<ProfilePhotoEdit> {
  File? newProfileimage;

  _profilePhotoChangeImgFromCamera({required StateSetter stateSetter}) async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear, imageQuality: 20);

    stateSetter(() {
      //_image = File(image!.path);
      profilePhotoEditChangeCrop(
        photo: File(image!.path),
      );
    });
  }

  _profilePhotoChangeImgFromGallery({required StateSetter stateSetter}) async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 20);

    stateSetter(() {
      //_image = File(image!.path);
      profilePhotoEditChangeCrop(photo: File(image!.path));
    });
  }

  void profilePhotoEditChangeCrop({required File photo}) async {
    File? croppedPhoto = await ImageCropper().cropImage(
      sourcePath: photo.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      cropStyle: CropStyle.circle,
      compressFormat: ImageCompressFormat.png,
    );
    if (croppedPhoto != null) {
      newProfileimage = croppedPhoto;
      //.uploadFile(user!.userID, 'profile_photo', 'profile_photo.png', event.imageFile);
    }

    Future.delayed(Duration(seconds: 1), () {
      setStateEditProfile.value = !setStateEditProfile.value;
    }).then((value) async {
      print("çalıştı ************** pp ");
      Reference _storageReference = FirebaseStorage.instance.ref().child(UserBloc.user!.userID).child("profile_photo").child("profile_photo.png");
      await _storageReference.putFile(newProfileimage!);
      //gs://peopler-2376c.appspot.com/G4yKPJketQU8dm2GjDfeZZXHt8Z2/profile_photo/profile_photo.png
      print(_storageReference.fullPath);
      print(FirebaseStorage.instance.ref(_storageReference.fullPath));
      UserBloc.user!.profileURL = await FirebaseStorage.instance.ref(_storageReference.fullPath).getDownloadURL();

      newProfileimage = null;
      setStateEditProfile.value = !setStateEditProfile.value;
    });
  }

  double _profilePhotoSize = 120;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ValueListenableBuilder(
          valueListenable: setStateEditProfile,
          builder: (context, snapshot, _) {
            return Stack(
              children: [
                Stack(
                  children: [
                    Container(
                      height: _profilePhotoSize,
                      width: _profilePhotoSize,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            width: 5,
                            color: Mode().search_peoples_scaffold_background() as Color,
                          )),
                      child: const CircleAvatar(
                        backgroundColor: Color(0xFF0353EF),
                        child: Text(
                          "ppl",
                          textScaleFactor: 1,
                        ),
                      ),
                    ),
                    Container(
                      height: _profilePhotoSize,
                      width: _profilePhotoSize,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            width: 5,
                            color: Mode().search_peoples_scaffold_background() as Color,
                          )),
                      child: //_userBloc != null ?
                          ValueListenableBuilder(
                        valueListenable: setStateEditProfile,
                        builder: (context, x, y) {
                          return CircleAvatar(
                            radius: 999,
                            backgroundImage: newProfileimage != null
                                ? FileImage(
                                    newProfileimage!,
                                  )
                                : NetworkImage(
                                    UserBloc.user!.profileURL.toString(),
                                  ) as ImageProvider,
                            backgroundColor: Colors.transparent,
                          );
                        },
                      ),
                    ),
                  ],
                ),

                //bu profil fotoğrafının üstünde olan ve tıklanmasını sağlayan bölüm.
                InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext bc) {
                          return SafeArea(
                            child: Wrap(
                              children: <Widget>[
                                ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text('Galeriden Seç'),
                                    onTap: () {
                                      _profilePhotoChangeImgFromGallery(stateSetter: setState);
                                      Navigator.of(context).pop();
                                    }),
                                ListTile(
                                  leading: const Icon(Icons.photo_camera),
                                  title: const Text('Kamera'),
                                  onTap: () {
                                    _profilePhotoChangeImgFromCamera(stateSetter: setState);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: Container(
                    height: _profilePhotoSize,
                    width: _profilePhotoSize,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          width: 5,
                          color: Mode().search_peoples_scaffold_background() as Color,
                        )),
                    child: CircleAvatar(backgroundColor: Color(0xFF0353EF).withOpacity(0.3), child: const Icon(Icons.photo_camera)),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
