import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDBServiceCommon {
  final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;

  Future<void> deleteNestedSubCollections(String subCollectionPath) async {
    var collection = _firebaseDB.collection(subCollectionPath);
    var snapshots = await collection.get();
    for (DocumentSnapshot doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  Future<List<String>> getAllDocumentIDs(String subCollectionPath) async {
    QuerySnapshot _querySnapshot = await _firebaseDB.collection(subCollectionPath).get();

    List<String> _allDocIDs = [];
    for (DocumentSnapshot snap in _querySnapshot.docs) {
      _allDocIDs.add(snap.id);
    }
    return _allDocIDs;
  }
}

