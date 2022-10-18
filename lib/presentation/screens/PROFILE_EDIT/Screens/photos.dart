import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/components/FlutterWidgets/app_bars.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/presentation/screens/PROFILE_EDIT/Home/profile_edit_home.dart';
import 'package:peopler/presentation/screens/PROFILE/MyProfile/ProfileScreen/profile_screen.dart';
import 'package:peopler/components/FlutterWidgets/dialogs.dart';

import '../../../../components/FlutterWidgets/gallery.dart';

class ProfileEditPhotosScreen extends StatefulWidget {
  const ProfileEditPhotosScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditPhotosScreen> createState() => _ProfileEditPhotosScreenState();
}

class _ProfileEditPhotosScreenState extends State<ProfileEditPhotosScreen> with TickerProviderStateMixin {
  TextEditingController companyController = TextEditingController(text: UserBloc.user!.company);
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future _photosAddImgFromCamera() async {
    await ImagePicker()
        .pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      imageQuality: 20,
    )
        .then((value) {
      if (value != null) {
        photosAddCrop(photo: File(value.path));
      }
    }).onError(
      (error, stackTrace) => SnackBars(context: context).simple(
        error.toString(),
      ),
    );
    ;
  }

  Future _photosAddImgFromGallery() async {
    await ImagePicker()
        .pickImage(
      source: ImageSource.gallery,
      imageQuality: 20,
    )
        .then((value) {
      if (value != null) {
        photosAddCrop(photo: File(value.path));
      }
    }).onError(
      (error, stackTrace) => SnackBars(context: context).simple(
        error.toString(),
      ),
    );

    setState(() {
      //_image = File(image!.path);
    });
  }

  void photosAddCrop({required File photo}) async {
    File? croppedPhoto = await ImageCropper().cropImage(
      sourcePath: photo.path,
      aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
      cropStyle: CropStyle.rectangle,
      compressFormat: ImageCompressFormat.png,
    );
    if (croppedPhoto != null) {
      Reference _storageReference = FirebaseStorage.instance
          .ref()
          .child(UserBloc.user!.userID)
          .child("photos")
          .child(croppedPhoto.toString().split("/").last.replaceAll("'", "").replaceAll("""""" "", ""));
      await _storageReference.putFile(croppedPhoto);
      // ignore: avoid_single_cascade_in_expression_statements
      FirebaseFirestore.instance.collection("users").doc(UserBloc.user!.userID)
        ..update({
          "photosURL": FieldValue.arrayUnion([await FirebaseStorage.instance.ref(_storageReference.fullPath).getDownloadURL()])
        }).then((value) async {
          await FirebaseStorage.instance.ref(_storageReference.fullPath).getDownloadURL().then((value) {
            //UserBloc.user!.photosURL.add(value);
          });

          //images2[index] = await FirebaseStorage.instance.ref(_storageReference.fullPath).getDownloadURL();
          print("${FirebaseStorage.instance.ref(_storageReference.fullPath).getDownloadURL()} eklendi");

          //setStateValue

          Future.delayed(const Duration(milliseconds: 500), () {
            setStateProfileScreen.value = !setStateProfileScreen.value;
            setStateProfileScreen.value = !setStateProfileScreen.value;
          }).then((value) {
            setStateProfileScreen.value = !setStateProfileScreen.value;
            setStateProfileScreen.value = !setStateProfileScreen.value;
            setState(() {});
            PeoplerDialogs().showSuccessfulDialog(context, _controller).then((value) => Future.delayed(
                    Duration(
                      milliseconds: 1200,
                    ), (() {
                  Navigator.of(context).pop();
                })));
          });
        }).onError(
          (error, stackTrace) {
            SnackBars(context: context).simple("error: $error");
          },
        );
    } else {
      SnackBars(context: context).simple("Yükleme Başarısız...");
    }
    Future.delayed(const Duration(seconds: 1), () {
      setStateEditProfile.value = !setStateEditProfile.value;
      setStateProfileScreen.value = !setStateProfileScreen.value;
    }).then((value) {
      setStateEditProfile.value = !setStateEditProfile.value;
      setStateProfileScreen.value = !setStateProfileScreen.value;
    });
  }

  int _crossAxisCount = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (UserBloc.user!.photosURL.length < 6) {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SafeArea(
                    child: Wrap(
                      children: <Widget>[
                        ListTile(
                            leading: const Icon(Icons.photo_library),
                            title: const Text('Galeriden Seç'),
                            onTap: () async {
                              await _photosAddImgFromGallery();
                              Navigator.of(context).pop();
                            }),
                        ListTile(
                          leading: const Icon(Icons.photo_camera),
                          title: const Text('Kamera'),
                          onTap: () async {
                            await _photosAddImgFromCamera();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                });
          } else {
            SnackBars(context: context)
                .simple("Yalnızca 6 adet fotoğraf yükleyebilirsiniz. \n\nDaha fazla fotoğraf ekleyebilmeniz için çalışmalarımıza devam ediyoruz.");
          }
        },
        label: Text(
          "Yeni Ekle",
          style: PeoplerTextStyle.normal.copyWith(),
        ),
        icon: const Icon(Icons.camera_outlined),
      ),
      appBar: PeoplerAppBars(context: context).PROFILE_EDIT_ITEMS(
        title: "Fotoğraflar",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF0353EF),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _crossAxisCount = 3;
                        });
                      },
                      icon: const Icon(Icons.grid_on),
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF0353EF),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _crossAxisCount = 2;
                        });
                      },
                      icon: const Icon(Icons.grid_view),
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF0353EF),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _crossAxisCount = 1;
                        });
                      },
                      icon: const Icon(Icons.splitscreen_outlined),
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: GridView.count(
                  physics: const BouncingScrollPhysics(),
                  crossAxisCount: _crossAxisCount,
                  childAspectRatio: 4 / 3,
                  children: List.generate(UserBloc.user!.photosURL.length, (index) {
                    return _buildListItem(context, index, setState);
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index, StateSetter setState) {
    double customDeleteIconSize = _crossAxisCount == 3
        ? 25
        : _crossAxisCount == 2
            ? 30
            : 35;
    return InkWell(
      onTap: () => PeoplerGallery().openGallery(context: context, images: UserBloc.user!.photosURL, currentIndex: index, isNetworkImage: true),
      child: Stack(
        children: [
          Container(
            width: (MediaQuery.of(context).size.width / _crossAxisCount),
            height: (MediaQuery.of(context).size.width / _crossAxisCount) * (4 / 3),
            padding: EdgeInsets.symmetric(
              horizontal: customDeleteIconSize / 20 * 5,
              vertical: customDeleteIconSize / 20 * 5,
            ),
            child: CachedNetworkImage(
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.5),
                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              imageUrl: UserBloc.user!.photosURL[index],
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  ClipRRect(borderRadius: BorderRadius.circular(7.5), child: LinearProgressIndicator(value: downloadProgress.progress)),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text('Emin Misiniz?'), // App Permission Settings
                        content: const Text('Bu fotoğraf kalıcı olarak silinecektir.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('İptal'),
                          ),
                          TextButton(
                            onPressed: () async {
                              //UserBloc.user!.photosURL.removeAt(index);
                              await FirebaseStorage.instance.refFromURL(UserBloc.user!.photosURL[index]).delete();
                              await FirebaseFirestore.instance.collection("users").doc(UserBloc.user!.userID).update({
                                "photosURL": FieldValue.arrayRemove([UserBloc.user!.photosURL[index]])
                              });
                              setState(() {});
                              Future.delayed(const Duration(seconds: 1), () {
                                setStateEditProfile.value = !setStateEditProfile.value;
                              }).then((value) => setStateEditProfile.value = !setStateEditProfile.value);

                              Future.delayed(const Duration(milliseconds: 500), () {
                                setStateProfileScreen.value = !setStateProfileScreen.value;
                              }).then(
                                (value) => setStateProfileScreen.value = !setStateProfileScreen.value,
                              );

                              Navigator.pop(context);
                            },
                            child: const Text('Devam Et'),
                          )
                        ],
                      ));
            },
            borderRadius: BorderRadius.circular(99),
            child: Container(
                width: customDeleteIconSize,
                height: customDeleteIconSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  border: Border.all(color: const Color(0xFF0353EF), width: 1),
                ),
                child: Center(
                  child: Icon(
                    Icons.delete,
                    size: customDeleteIconSize / 60 * 36,
                    color: Color(0xFF0353EF),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

class Explanation extends StatelessWidget {
  const Explanation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Fotoğraf paylaşarak profilinizi tamamlayın.\n\n",
            style: PeoplerTextStyle.normal.copyWith(fontSize: 14, color: Colors.grey[850]),
          ),
          Text(
            "#beXXXX\n#beYYYY\n#beZZZZ",
            style: PeoplerTextStyle.normal.copyWith(fontSize: 15, color: Colors.grey[850], fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
