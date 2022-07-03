import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class FirebaseStorageService  {
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadFile(String userID, String fileType, String fileName, File uploadedFile) async {
    Reference _storageReference = storage
        .ref()
        .child(userID)
        .child(fileType)
        .child(fileName);

    await _storageReference.putFile(uploadedFile);

    String url = await _storageReference.getDownloadURL();
    return url;
  }

  Future<void> deleteFile(String userID, String fileType, String fileName) async {
    var url = userID + "/" + fileType + "/" + fileName;
    Reference _storageReference = storage.ref(url);
    try{
      _storageReference.delete();
    }
    catch (e) {
      debugPrint("file delete hata:" + e.toString());
    }
  }

  /*
  deleteFolder(path) {
    Reference ref = storage.ref(path);
    ref.listAll().then(dir => {
      dir.items.forEach(fileRef => this.deleteFile(ref.fullPath, fileRef.name));
      dir.prefixes.forEach(folderRef => this.deleteFolder(folderRef.fullPath))
    }).catch(error => console.log(error));
  }

  deleteFile(pathToFile, fileName) {
    Reference ref = storage.ref(pathToFile);
    Reference childRef = ref.child(fileName);
    childRef.delete();
  }
   */
}
