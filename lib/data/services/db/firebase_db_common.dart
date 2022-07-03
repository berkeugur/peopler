import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreDBServiceCommon {
  final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;

  Future<void> deleteNestedSubCollections(String subCollectionPath) async {
    QuerySnapshot _querySnapshot = await _firebaseDB.collection(subCollectionPath).get();

    for (DocumentSnapshot snap in _querySnapshot.docs) {
      await _firebaseDB.collection(subCollectionPath).doc(snap.id).delete();
    }
  }

  Future<List<String>> getAllDocuments(String subCollectionPath) async {
    QuerySnapshot _querySnapshot = await _firebaseDB.collection(subCollectionPath).get();

    List<String> _allDocs = [];
    for (DocumentSnapshot snap in _querySnapshot.docs) {
      _allDocs.add(snap.id);
    }
    return _allDocs;
  }
}

