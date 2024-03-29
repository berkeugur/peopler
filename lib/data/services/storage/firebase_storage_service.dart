import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class FirebaseStorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadFile(String filePath, String fileName, File uploadedFile) async {
    Reference _storageReference = _firebaseStorage.ref().child(filePath).child(fileName);

    await _storageReference.putFile(uploadedFile);

    String url = await _storageReference.getDownloadURL();
    return url;
  }

  Future<void> deleteFile(String filePath, String fileName) async {
    String url = filePath + "/" + fileName;
    Reference _storageReference = _firebaseStorage.ref(url);
    try {
      _storageReference.delete();
    } catch (e) {
      debugPrint("file delete error:" + e.toString());
    }
  }

  deleteFolder(path) async {
    try {
      var value = await _firebaseStorage.ref(path).listAll();
      _firebaseStorage.ref(value.items.first.fullPath).delete();
    } catch (e) {
      debugPrint("Firebase Storage delete error: $e");
    }
  }
}
