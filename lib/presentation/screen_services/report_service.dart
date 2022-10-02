import 'package:firebase_auth/firebase_auth.dart';
import 'package:peopler/core/constants/reloader/reload.dart';
import 'package:peopler/data/model/report.dart';
import 'package:peopler/data/services/db/firebase_db_report.dart';
import 'package:peopler/others/locator.dart';
import 'package:peopler/presentation/screens/CONNECTIONS/connections_service.dart';

import '../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../data/repository/user_repository.dart';

class BlockAndReportService {
  Future<void> reportUser({required MyReport report}) async {
    final FirestoreDBServiceReport _firestoreDBServiceReport = locator<FirestoreDBServiceReport>();
    await _firestoreDBServiceReport.reportFeedOrUser(report);
  }

  ///to be used in both feed and message and profile screens
  Future<void> blockUser({required String blockUserID, String? feedID}) async {
    ///local change
    UserBloc.user?.blockedUsers.add(blockUserID);

    final UserRepository _userRepository = locator<UserRepository>();
    await _userRepository.blockUser(UserBloc.user!.userID, blockUserID);
  }

  Future<void> unblockUser({required String blockUserID}) async {
    Future.delayed(
      const Duration(seconds: 1),
      (() async {
        ///local change
        UserBloc.user?.blockedUsers.remove(blockUserID);
        Reloader.isUnBlocked.value = !Reloader.isUnBlocked.value;

        final UserRepository _userRepository = locator<UserRepository>();
        await _userRepository.unblockUser(UserBloc.user!.userID, blockUserID);
      }),
    );
  }

  Future<void> reportFeed({required MyReport report}) async {
    final FirestoreDBServiceReport _firestoreDBServiceReport = locator<FirestoreDBServiceReport>();
    await _firestoreDBServiceReport.reportFeedOrUser(report);
  }
}
