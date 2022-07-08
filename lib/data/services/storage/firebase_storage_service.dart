import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class FirebaseStorageService  {
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadFile(String filePath, String fileName, File uploadedFile) async {
    Reference _storageReference = _firebaseStorage
        .ref()
        .child(filePath)
        .child(fileName);

    await _storageReference.putFile(uploadedFile);

    String url = await _storageReference.getDownloadURL();
    return url;
  }

  Future<void> deleteFile(String filePath, String fileName) async {
    var url = filePath + "/" + fileName;
    Reference _storageReference = _firebaseStorage.ref(url);
    try{
      _storageReference.delete();
    } catch (e) {
      debugPrint("file delete error:" + e.toString());
    }
  }

  deleteFolder(path) async {
    await _firebaseStorage.ref(path).listAll().then((value) {
      _firebaseStorage.ref(value.items.first.fullPath).delete();
    }).catchError((error) {
      debugPrint("Firebase Storage delete error: $error");
    });
  }
}
