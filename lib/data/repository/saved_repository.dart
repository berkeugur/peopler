import 'package:peopler/data/model/saved_user.dart';
import '../../others/locator.dart';
import '../model/notifications.dart';
import '../model/user.dart';
import '../services/db/firestore_db_service_users.dart';

class SavedRepository {
  static const int _numberOfElements = 10;

  final FirestoreDBServiceUsers _firestoreDBServiceUsers = locator<FirestoreDBServiceUsers>();

  bool _hasMore= true;

  Future<List<SavedUser>> getSavedUsersWithPagination(String myUserID, SavedUser? lastUserListElement) async {
    if (_hasMore == false) return [];

    List<SavedUser> savedUserList = await _firestoreDBServiceUsers.getSavedUsersWithPagination(myUserID, lastUserListElement, _numberOfElements);

    if (savedUserList.length < _numberOfElements) {
      _hasMore = false;
    }

    if (savedUserList.isEmpty) return [];

    List<SavedUser> tempList = [...savedUserList];
    for (final req in tempList) {

      DateTime countDownFinishTime = req.createdAt!.add(Duration(minutes: req.countDownDurationMinutes));
      DateTime deleteTime = countDownFinishTime.add(const Duration(minutes: 2880)); // 2880 minutes = 48 hours

      // If duration between 6 and 48 hours, then isCountdownFinished must be true
      if(req.isCountdownFinished == false && countDownFinishTime.isBefore(DateTime.now()) && deleteTime.isAfter(DateTime.now())){
        await _firestoreDBServiceUsers.updateCountdownFinished(myUserID, req.userID, true);
        // Since ConnectionRequest object extends Equatable, if element and req fields are same, then it will return true.
        int index = savedUserList.indexWhere((element) => element == req);
        savedUserList[index].isCountdownFinished = true;
      }

      // After 48 hours, if request has not sent, then delete request
      if(deleteTime.isBefore(DateTime.now())){
        savedUserList.remove(req);
        await _firestoreDBServiceUsers.deleteUserFromSavedUsers(myUserID, req.userID);
      }
    }

    for (int index=0; index < savedUserList.length; index++) {
      MyUser? _user = await _firestoreDBServiceUsers.readUserRestricted(savedUserList[index].userID);
      savedUserList[index].displayName = _user!.displayName;
      savedUserList[index].profileURL = _user.profileURL;
      savedUserList[index].biography = _user.biography;
      savedUserList[index].pplName = _user.pplName!;
      savedUserList[index].gender = _user.gender;
      savedUserList[index].hobbies = [..._user.hobbies];
    }

    return savedUserList;
  }

  // When the "Save" button is clicked, this function run
  Future<void> saveUser(String myUserID, SavedUser requestUser) async {
    await _firestoreDBServiceUsers.saveUserToSavedUsers(myUserID, requestUser);
    await _firestoreDBServiceUsers.updateSaveUserIDsField(myUserID, requestUser.userID);
  }


  /// When the "Send Connection Request" button is clicked, this function run
  Future<void> saveConnectionRequest(SavedUser myUser, SavedUser requestUser) async {
    Notifications myNotification = Notifications();
    myNotification.notificationID = requestUser.userID;
    myNotification.notificationType = 'TransmittedRequest';
    myNotification.requestUserID = requestUser.userID;

    Notifications requestNotification = Notifications();
    requestNotification.notificationID = myUser.userID;
    requestNotification.notificationType = 'ReceivedRequest';
    requestNotification.requestUserID = myUser.userID;

    await _firestoreDBServiceUsers.updateTransmittedUserIDsField(myUser.userID, requestUser.userID);
    await _firestoreDBServiceUsers.updateReceivedUserIDsField(requestUser.userID, myUser.userID);

    await _firestoreDBServiceUsers.saveNotification(myUser.userID, myNotification);
    await _firestoreDBServiceUsers.saveNotification(requestUser.userID, requestNotification);

    await deleteSavedUser(myUser.userID, requestUser.userID);
  }

  Future<void> decrementNumOfSendRequest(String userID) async {
    await _firestoreDBServiceUsers.decrementNumOfSendRequest(userID);
  }



  // When the "close" button is clicked, this function run
  Future<void> deleteSavedUser(String myUserID, String savedUserID) async {
    await _firestoreDBServiceUsers.deleteUserFromSavedUsers(myUserID, savedUserID);
    await _firestoreDBServiceUsers.deleteSaveUserIDsField(myUserID, savedUserID);
  }

  void restartSavedCache() async {
    _hasMore = true;
  }
}
