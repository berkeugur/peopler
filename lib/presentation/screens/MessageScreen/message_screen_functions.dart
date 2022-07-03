import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../business_logic/blocs/ChatBloc/bloc.dart';

Future<bool> popMessageScreen(BuildContext context, String hostUserID) async {
  ChatBloc _chatBloc = BlocProvider.of<ChatBloc>(context);
  _chatBloc.add(UpdateLastMessageSeenEvent(hostUserID: hostUserID));
  Navigator.pop(context);

  return Future.value(true);
}