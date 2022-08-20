import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/chat.dart';
import '../../model/report.dart';

class FirestoreDBServiceReport {
  final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;

  Future<bool> reportFeedOrUser(MyReport report) async {
    /// Free report document created with ID.
    String _reportID = _firebaseDB
        .collection('reports')
        .doc()
        .id;

    report.reportID = _reportID;

    try {
      await _firebaseDB.collection('reports').doc(report.reportID).set(report.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }
}
