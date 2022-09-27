import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';

import '../screens/SUBSCRIPTIONS/subscriptions_functions.dart';

class OtherProfileService {
  Future removeConnection({required String otherUserID}) async {
    //local remove
    UserBloc.user?.connectionUserIDs.remove(otherUserID);
    //
    //
    Future.delayed(Duration.zero);
  }

  bool isMyConnection({required String? otherProfileID}) {
    if (otherProfileID != null) {
      if (UserBloc.user != null) {
        if (UserBloc.user!.connectionUserIDs.contains(otherProfileID)) {
          return true;
        } else {
          return false;
        }
      } else {
        printf("UserBloc.user null ismyconnection function");
        return false;
      }
    } else {
      printf("otherProfileID null ismyconnection function");
      return false;
    }
  }
}
