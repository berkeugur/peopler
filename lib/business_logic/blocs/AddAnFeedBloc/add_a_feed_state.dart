import 'package:equatable/equatable.dart';

import '../../../data/model/feed.dart';

abstract class AddFeedState extends Equatable {
  const AddFeedState();
}

class PrepareDataState extends AddFeedState {
  @override
  List<Object> get props => [];
}

class LoadingState extends AddFeedState {
  @override
  List<Object> get props => [];
}

class FeedCreateErrorState extends AddFeedState {
  @override
  List<Object> get props => [];
}

class FeedCreateSuccessfulState extends AddFeedState {
  final MyFeed myFeed;
  const FeedCreateSuccessfulState({required this.myFeed});

  @override
  List<Object> get props => [myFeed];
}
