import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import 'package:peopler/data/services/storage/firebase_storage_service.dart';
import 'package:peopler/presentation/screens/profile_edit/profile_edit.dart';

void showPickerForChangeProfilePhoto(context, {required StateSetter stateSetter}) {
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
                    _profilePhotoChangeImgFromGallery(stateSetter: stateSetter);
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Kamera'),
                onTap: () {
                  _profilePhotoChangeImgFromCamera(stateSetter: stateSetter);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      });
}

File? newProfileimage;
_profilePhotoChangeImgFromCamera({required StateSetter stateSetter}) async {
  XFile? image = await ImagePicker()
      .pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear, imageQuality: 20);

  stateSetter(() {
    //_image = File(image!.path);
    profilePhotoChangeCrop(photo: File(image!.path), stateSetter: stateSetter);
  });
}

_profilePhotoChangeImgFromGallery({required StateSetter stateSetter}) async {
  XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 20);

  stateSetter(() {
    //_image = File(image!.path);
    profilePhotoChangeCrop(photo: File(image!.path), stateSetter: stateSetter);
  });
}

void profilePhotoChangeCrop({required File photo, required StateSetter stateSetter}) async {
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
  }).then((value) {
    setStateEditProfile.value = !setStateEditProfile.value;
    print("çalıştı ************** pp ");
  });
}

///
///4:3 fotoğraf boyutunda fotoğraflarım bölümü için:
///
///

void showPickerForAddPhotos(context, {required StateSetter stateSetter}) {
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
                    _photosAddImgFromGallery(stateSetter: stateSetter);
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Kamera'),
                onTap: () {
                  _photosAddImgFromCamera(stateSetter: stateSetter);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      });
}

File? newPhotos;
_photosAddImgFromCamera({required StateSetter stateSetter}) async {
  XFile? image = await ImagePicker()
      .pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear, imageQuality: 20);

  stateSetter(() {
    //_image = File(image!.path);
    photosAddCrop(photo: File(image!.path), stateSetter: stateSetter);
  });
}

_photosAddImgFromGallery({required StateSetter stateSetter}) async {
  XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 20);

  stateSetter(() {
    //_image = File(image!.path);
    photosAddCrop(photo: File(image!.path), stateSetter: stateSetter);
  });
}

void photosAddCrop({required File photo, required StateSetter stateSetter}) async {
  File? croppedPhoto = await ImageCropper().cropImage(
    sourcePath: photo.path,
    aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
    cropStyle: CropStyle.rectangle,
    compressFormat: ImageCompressFormat.png,
  );
  if (croppedPhoto != null) {
    images2.add(croppedPhoto);
    //croppedPhoto;
    //.uploadFile(user!.userID, 'profile_photo', 'profile_photo.png', event.imageFile);
  }
  Future.delayed(Duration(seconds: 1), () {
    setStateEditProfile.value = !setStateEditProfile.value;
  }).then((value) => setStateEditProfile.value = !setStateEditProfile.value);

  numberOfNewPhotos++;
}
