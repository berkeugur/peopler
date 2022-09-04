import 'package:peopler/data/model/report.dart';
import 'package:peopler/data/services/db/firebase_db_report.dart';
import 'package:peopler/others/locator.dart';

class ReportScreenService {
  Future<void> reportUser({required MyReport report}) async {
    final FirestoreDBServiceReport _firestoreDBServiceReport = locator<FirestoreDBServiceReport>();
    await _firestoreDBServiceReport.reportFeedOrUser(report);
  }

  ///to be used in both feed and message and profile screens
  Future<void> blockUser({required String userID, String? feedID}) async {
    return await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> reportFeed({required MyReport report}) async {
    final FirestoreDBServiceReport _firestoreDBServiceReport = locator<FirestoreDBServiceReport>();
    await _firestoreDBServiceReport.reportFeedOrUser(report);
  }
}
