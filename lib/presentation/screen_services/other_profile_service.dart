import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import '../../business_logic/blocs/OtherUserBloc/bloc.dart';
import '../screens/SUBSCRIPTIONS/subscriptions_functions.dart';

class OtherProfileService {
  Future removeConnection({required BuildContext context, required String otherUserID}) async {
    OtherUserBloc _otherUserBloc = BlocProvider.of<OtherUserBloc>(context);
    UserBloc.user?.connectionUserIDs.remove(otherUserID);
    _otherUserBloc.add(RemoveConnectionEvent(otherUserID: otherUserID));
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
