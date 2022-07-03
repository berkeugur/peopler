import '../../others/locator.dart';
import '../services/db/firestore_db_service_users.dart';

class ConnectionRepository {

  static const int _numberOfElements = 10;

  final FirestoreDBServiceUsers _firestoreDBServiceUsers =
  locator<FirestoreDBServiceUsers>();

  bool _hasMore = true;

  /*
  Future<List<MyUser>> getConnectionsWithPagination(String myUserID, MyUser? lastUserListElement) async {
    if (_hasMore == false) return [];

    List<MyUser> connectionList =
    await _firestoreDBServiceUsers.getConnectionsWithPagination(myUserID, lastUserListElement, _numberOfElements);

    if (connectionList.length < _numberOfElements) {
      _hasMore = false;
    }

    if (connectionList.isEmpty) return [];
    return connectionList;
  }

  Future<bool> deleteUserFromConnections(String myUserID, String connectionUserID) async {
    return await _firestoreDBServiceUsers.deleteUserFromConnections(myUserID, connectionUserID);
  }

   */

  void restartConnectionCache() async {
    _hasMore = true;
  }

}
