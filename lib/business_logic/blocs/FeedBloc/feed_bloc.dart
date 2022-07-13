import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/data/repository/feed_repository.dart';
import '../../../data/model/feed.dart';
import '../../../data/model/user.dart';
import '../../../data/services/db/firestore_db_service_users.dart';
import '../../../others/locator.dart';
import 'bloc.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedRepository _feedRepository = locator<FeedRepository>();
  final FirestoreDBServiceUsers _firestoreDBServiceUsers = locator<FirestoreDBServiceUsers>();

  List<MyFeed> _allFeedList = [];
  List<MyFeed> get allFeedList => _allFeedList;
  MyFeed? _lastSelectedFeed;

  /// This future mechanism used for both RefreshIndicator onPressed method and home button click refresh.
  /// Since refreshIndicator widget works with Future functions, a Future function in bloc
  /// is created. However, when home button is clicked, event mechanism
  /// should work.
  Future<String> getRefreshDataFuture() async {
    try {
      _feedRepository.restartFeedCache();

      _lastSelectedFeed = null;
      List<MyFeed> shuffledList = await getKadinAndErkekList();

      // await Future.delayed(const Duration(seconds: 2));

      if (shuffledList.isNotEmpty) {
        _allFeedList = [];
        _allFeedList.addAll(shuffledList);
        return 'FeedsLoadedState';
      } else {
        _allFeedList = [];
        return 'FeedNotExistState';
      }
    } catch (e) {
      debugPrint("Blocta refresh event hata:" + e.toString());
      return 'Impossible';
    }
  }

  /// getRefreshDataFuture function is used in this Refresh Indicator function.
  Future<void> getRefreshIndicatorData() async {
    try {
      add(TrigNewFeedsLoadingStateEvent());
      await getRefreshDataFuture();
      add(TrigFeedsLoadedStateEvent());
    } catch (e) {
      debugPrint("Blocta refresh event hata:" + e.toString());
    }
  }

  /// getRefreshDataFuture function is used in this Refresh Indicator function.
  Future<List<MyFeed>> getKadinAndErkekList() async {
    List<MyFeed> shuffledList = [];
    List<MyFeed> kadinList;
    List<MyFeed> erkekList;

    kadinList = await _feedRepository.getFeedWithPagination(_lastSelectedFeed, 'Kadın');
    erkekList = await _feedRepository.getFeedWithPagination(_lastSelectedFeed, 'Erkek');

    List<String> kadinListGender = kadinList.map((person) => 'K').toList();
    List<String> erkekListGender = erkekList.map((person) => 'E').toList();
    List<String> shuffledListGender = [...kadinListGender, ...erkekListGender];
    shuffledListGender.shuffle();

    int kadinIndex = 0;
    int erkekIndex = 0;

    for (String i in shuffledListGender) {
      if (i == 'K') {
        shuffledList.add(kadinList[kadinIndex++]);
      } else {
        shuffledList.add(erkekList[erkekIndex++]);
      }
    }

    return shuffledList;
  }

  FeedBloc() : super(InitialFeedState()) {
    on<GetInitialDataEvent>((event, emit) async {
      try {
        emit(InitialFeedState());

        _allFeedList = [];
        _feedRepository.restartFeedCache();

        _lastSelectedFeed = null;
        List<MyFeed> shuffledList = await getKadinAndErkekList();

        // await Future.delayed(const Duration(seconds: 2));

        if (shuffledList.isNotEmpty) {
          _allFeedList.addAll(shuffledList);
          emit(FeedsLoadedState());
        } else {
          emit(FeedNotExistState());
        }
      } catch (e) {
        debugPrint("Blocta initial feed hata:" + e.toString());
      }
    });

    on<GetMoreDataEvent>((event, emit) async {
      try {
        emit(NewFeedsLoadingState());

        _lastSelectedFeed = _allFeedList.last;
        List<MyFeed> shuffledList = await getKadinAndErkekList();

        // await Future.delayed(const Duration(seconds: 2));

        if (shuffledList.isNotEmpty) {
          _allFeedList.addAll(shuffledList);
          emit(FeedsLoadedState());
        } else {
          if (_allFeedList.isNotEmpty) {
            emit(NoMoreFeedsState());
          } else {
            emit(FeedNotExistState());
          }
        }
      } catch (e) {
        debugPrint("Blocta get more data feed hata:" + e.toString());
      }
    });

    on<AddMyFeedEvent>((event, emit) async {
      try {
        emit(NewFeedsLoadingState());

        MyUser? _user = await _firestoreDBServiceUsers.readUserRestricted(event.myFeed.userID);
        event.myFeed.userDisplayName = _user!.displayName;
        event.myFeed.userPhotoUrl = _user.profileURL;
        event.myFeed.numberOfConnections = _user.connectionUserIDs.length;

        _allFeedList.insert(0, event.myFeed);
        emit(FeedsLoadedState());
      } catch (e) {
        debugPrint("Blocta get more data feed hata:" + e.toString());
      }
    });

    /// This event mechanism is used for HomeButton click to scrollToTop and refresh
    on<GetRefreshDataEvent>((event, emit) async {
      /// Since refresh indicator just wait for finishing future function, state mechanism does not work for it
      /// Therefore, EventRefreshingState not emitted inside Future function to prevent BlocBuilder-EventRefreshingState collide with RefreshIndicator indicator.
      emit(NewFeedsLoadingState());
      String emitState = await getRefreshDataFuture();
      if(emitState == 'FeedsLoadedState') {
        emit(FeedsLoadedState());
      } else if(emitState == 'FeedNotExistState') {
        emit(FeedNotExistState());
      }
    });

    on<TrigNewFeedsLoadingStateEvent>((event, emit) async {
      emit(NewFeedsLoadingState());
    });

    on<TrigFeedsLoadedStateEvent>((event, emit) async {
      emit(FeedsLoadedState());
    });

  }
}
