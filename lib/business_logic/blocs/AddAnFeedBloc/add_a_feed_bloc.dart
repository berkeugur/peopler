import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import '../../../data/model/feed.dart';
import '../../../data/repository/feed_repository.dart';
import '../../../others/locator.dart';
import 'bloc.dart';

class AddFeedBloc extends Bloc<AddFeedEvent, AddFeedState> {
  final FeedRepository _eventRepository = locator<FeedRepository>();

  late String feedExplanation;

  AddFeedBloc() : super(PrepareDataState()) {
    on<AddAFeedEvent>((event, emit) async {
      try {
        emit(LoadingState());

        event.myFeed.feedExplanation = feedExplanation;
        event.myFeed.userDisplayName = UserBloc.user!.displayName;
        event.myFeed.userPhotoUrl = UserBloc.user!.profileURL;
        event.myFeed.userGender = UserBloc.user!.gender;

        MyFeed? _newFeed = await _eventRepository.addFeed(event.myFeed);

        // await Future.delayed(const Duration(seconds: 2));

        if (_newFeed != null) {
          emit(FeedCreateSuccessfulState(myFeed: _newFeed));
        } else {
          emit(FeedCreateErrorState());
        }
      } catch (e) {
        debugPrint("Bloctaki add an event hata:" + e.toString());
      }
    });
  }
}
