import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import 'package:peopler/presentation/screens/PROFILE_EDIT/Home/profile_edit_home.dart';
import '../../../../business_logic/blocs/UserBloc/bloc.dart';

class ProfilePhotoEdit extends StatefulWidget {
  const ProfilePhotoEdit({Key? key}) : super(key: key);

  @override
  State<ProfilePhotoEdit> createState() => _ProfilePhotoEditState();
}

class _ProfilePhotoEditState extends State<ProfilePhotoEdit> {
  File? newProfileimage;

  _profilePhotoChangeImgFromCamera({required StateSetter stateSetter}) async {
    await ImagePicker().pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear, imageQuality: 20).then((value) {
      if (value != null) {
        profilePhotoEditChangeCrop(photo: File(value.path));
      }
    }).onError((error, stackTrace) => SnackBars(context: context).simple(error.toString()));
  }

  _profilePhotoChangeImgFromGallery({required StateSetter stateSetter}) async {
    await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 20).then((value) {
      if (value != null) {
        profilePhotoEditChangeCrop(photo: File(value.path));
      }
    }).onError((error, stackTrace) => SnackBars(context: context).simple(error.toString()));
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

    Future.delayed(const Duration(seconds: 1), () {
      setStateEditProfile.value = !setStateEditProfile.value;
    }).then((value) async {
      UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
      _userBloc.add(uploadProfilePhoto(imageFile: newProfileimage));
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
