import 'package:peopler/data/model/report.dart';
import 'package:peopler/data/services/db/firebase_db_report.dart';
import 'package:peopler/others/locator.dart';

import '../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../data/repository/user_repository.dart';

class ReportScreenService {
  Future<void> reportUser({required MyReport report}) async {
    final FirestoreDBServiceReport _firestoreDBServiceReport = locator<FirestoreDBServiceReport>();
    await _firestoreDBServiceReport.reportFeedOrUser(report);
  }

  ///to be used in both feed and message and profile screens
  Future<void> blockUser({required String blockUserID, String? feedID}) async {
    final UserRepository _userRepository = locator<UserRepository>();
    _userRepository.blockUser(UserBloc.user!.userID, blockUserID);
  }

  Future<void> reportFeed({required MyReport report}) async {
    final FirestoreDBServiceReport _firestoreDBServiceReport = locator<FirestoreDBServiceReport>();
    await _firestoreDBServiceReport.reportFeedOrUser(report);
  }
}
