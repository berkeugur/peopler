import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

File? image;
_imgFromCamera({required StateSetter stateSetter}) async {
  XFile? image = await ImagePicker()
      .pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear, imageQuality: 20);

  stateSetter(() {
    //_image = File(image!.path);
    photoCrop(photo: File(image!.path), stateSetter: stateSetter);
  });
}

_imgFromGallery({required StateSetter stateSetter}) async {
  XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 20);

  stateSetter(() {
    //_image = File(image!.path);
    photoCrop(photo: File(image!.path), stateSetter: stateSetter);
  });
}

void showPicker(context, {required StateSetter stateSetter}) {
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
                    _imgFromGallery(stateSetter: stateSetter);
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Kamera'),
                onTap: () {
                  _imgFromCamera(stateSetter: stateSetter);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      });
}

void photoCrop({required File photo, required StateSetter stateSetter}) async {
  File? croppedPhoto = await ImageCropper().cropImage(
    sourcePath: photo.path,
    aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    cropStyle: CropStyle.circle,
    compressFormat: ImageCompressFormat.png,
  );
  if (croppedPhoto != null) {
    stateSetter(() {
      image = croppedPhoto;
    });
  }
}
