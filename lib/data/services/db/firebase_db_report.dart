import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/data/model/user.dart';
import '../../model/chat.dart';
import '../../model/report.dart';

class FirestoreDBServiceReport {
  final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;

  Future<bool> reportFeedOrUser(MyReport report) async {
    /// Free report document created with ID.
    String _reportID = _firebaseDB.collection('reports').doc().id;

    report.reportID = _reportID;

    Map<String, dynamic> _map = report.toMap();

    //added by berke
    _map.addAll({"reportFromUserID": UserBloc.user?.userID ?? "null"});

    try {
      await _firebaseDB.collection('reports').doc(report.reportID).set(_map);
      return true;
    } catch (e) {
      return false;
    }
  }
}
