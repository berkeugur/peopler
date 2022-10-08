import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirestoreDBServiceLocation {
  final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;

  Future<bool> setUserInRegion(String userID, String region) async {
    try {
      DocumentSnapshot _readRegion = await _firebaseDB.collection('regions').doc(region).get();
      // if a region exists with this region on regions collections, then add userID to array field of users
      if (_readRegion.data() != null) {
        await _firebaseDB.collection('regions').doc(region).update({
          "users": FieldValue.arrayUnion([userID])
        });
        return true;
      } else {
        await _firebaseDB.collection('regions').doc(region).set({
          "users": FieldValue.arrayUnion([userID])
        });
        debugPrint("setUserInRegion ERROR: Document does not exist, a region with this regionID does not exist");
        return true;
      }
    } catch (e) {
      debugPrint("ERROR in setUserInRegion function: $e");
      return false;
    }
  }

  Future<bool> deleteUserFromRegion(String userID, String region) async {
    try {
      DocumentSnapshot _readRegion = await _firebaseDB.collection('regions').doc(region).get();
      // if a region exists with this region on regions collections, then add userID to array field of users
      if (_readRegion.data() != null) {
        await _firebaseDB.collection('regions').doc(region).update({
          "users": FieldValue.arrayRemove([userID])
        });
        return true;
      } else {
        debugPrint("deleteUserFromRegion ERROR: Document does not exist, a region with this regionID does not exist");
        return false;
      }
    } catch (e) {
      debugPrint("ERROR in deleteUserFromRegion function: $e");
      return false;
    }
  }

  Future<List<String>> getAllUserIDsFromRegion(String region) async {
    try {
      DocumentSnapshot _readRegion = await _firebaseDB.collection('regions').doc(region).get();
      // if a region exists with this region on regions collections, then get users array field
      if (_readRegion.exists) {
        Map<String, dynamic> _readUserMap = _readRegion.data() as Map<String, dynamic>;
        List<String> _userList = _readUserMap['users'].map<String>((s) => s as String).toList();
        return _userList;
      } else {
        debugPrint('getAllUserIDsFromRegion Document does not exist on the database ${region}');
        return [];
      }
    } catch (e) {
      debugPrint("ERROR in getAllUserIDsFromRegion function: $e");
      return [];
    }
  }
}
