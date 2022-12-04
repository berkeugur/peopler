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
  Future<void> getRefreshDataFuture() async {
    try {
      _feedRepository.restartFeedCache();

      _lastSelectedFeed = null;
      List<MyFeed> shuffledList = await getKadinAndErkekList();

      _allFeedList = [];
      _allFeedList.addAll(shuffledList);
    } catch (e) {
      debugPrint("Blocta refresh event hata:" + e.toString());
    }
  }

  /// getRefreshDataFuture function is used in this Refresh Indicator function.
  Future<void> getRefreshIndicatorData() async {
    try {
      await getRefreshDataFuture();
      add(TrigFeedNotExistStateEvent());
    } catch (e) {
      debugPrint("Blocta refresh event hata:" + e.toString());
    }
  }

  /// getRefreshDataFuture function is used in this Refresh Indicator function.
  Future<List<MyFeed>> getKadinAndErkekList() async {
    List<MyFeed> shuffledList = [];
    List<MyFeed> kadinList;
    List<MyFeed> erkekList;
    List<MyFeed> otherList;

    kadinList = await _feedRepository.getFeedWithPagination(_lastSelectedFeed, 'Kadın');
    erkekList = await _feedRepository.getFeedWithPagination(_lastSelectedFeed, 'Erkek');
    otherList = await _feedRepository.getFeedWithPagination(_lastSelectedFeed, 'Diğer');

    List<String> kadinListGender = kadinList.map((person) => 'K').toList();
    List<String> erkekListGender = erkekList.map((person) => 'E').toList();
    List<String> otherListGender = otherList.map((person) => 'O').toList();
    List<String> shuffledListGender = [...kadinListGender, ...erkekListGender, ...otherListGender];
    shuffledListGender.shuffle();

    int kadinIndex = 0;
    int erkekIndex = 0;
    int otherIndex = 0;

    for (String i in shuffledListGender) {
      if (i == 'K') {
        shuffledList.add(kadinList[kadinIndex++]);
      } else if (i == 'E') {
        shuffledList.add(erkekList[erkekIndex++]);
      } else if (i == 'O') {
        shuffledList.add(otherList[otherIndex++]);
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

        _allFeedList.addAll(shuffledList);
        if (_allFeedList.isEmpty) {
          emit(FeedNotExistState());
          return;
        }

        if (state is FeedsLoaded1State) {
          emit(FeedsLoaded2State());
        } else {
          emit(FeedsLoaded1State());
        }
      } catch (e) {
        debugPrint("Blocta initial feed hata:" + e.toString());
      }
    });

    on<GetMoreDataEvent>((event, emit) async {
      try {
        emit(NewFeedsLoadingState());

        _lastSelectedFeed = _allFeedList.isNotEmpty ? _allFeedList.last : null;
        List<MyFeed> shuffledList = await getKadinAndErkekList();

        if (shuffledList.isNotEmpty) {
          _allFeedList.addAll(shuffledList);
          if (state is FeedsLoaded1State) {
            emit(FeedsLoaded2State());
          } else {
            emit(FeedsLoaded1State());
          }
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
        if (state is FeedsLoaded1State) {
          emit(FeedsLoaded2State());
        } else {
          emit(FeedsLoaded1State());
        }
      } catch (e) {
        debugPrint("Blocta get more data feed hata:" + e.toString());
      }
    });

    /// This event mechanism is used for HomeButton click to scrollToTop and refresh
    on<GetRefreshDataEvent>((event, emit) async {
      /// Since refresh indicator just wait for finishing future function, state mechanism does not work for it
      /// Therefore, EventRefreshingState not emitted inside Future function to prevent BlocBuilder-EventRefreshingState collide with RefreshIndicator indicator.
      emit(NewFeedsLoadingState());
      await getRefreshDataFuture();
      if (allFeedList.isEmpty) {
        emit(FeedNotExistState());
      } else {
        if (state is FeedsLoaded1State) {
          emit(FeedsLoaded2State());
        } else {
          emit(FeedsLoaded1State());
        }
      }
    });

    on<TrigNewFeedsLoadingStateEvent>((event, emit) async {
      emit(NewFeedsLoadingState());
    });

    on<TrigFeedNotExistStateEvent>((event, emit) async {
      if (allFeedList.isEmpty) {
        emit(FeedNotExistState());
      } else {
        if (state is FeedsLoaded1State) {
          emit(FeedsLoaded2State());
        } else {
          emit(FeedsLoaded1State());
        }
      }
    });
  }
}
