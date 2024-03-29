import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../data/model/feed.dart';

@immutable
abstract class FeedEvent extends Equatable {}

class GetMoreDataEvent extends FeedEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class GetInitialDataEvent extends FeedEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class GetRefreshDataEvent extends FeedEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class AddMyFeedEvent extends FeedEvent {
  final MyFeed myFeed;
  AddMyFeedEvent({
    required this.myFeed,
  });

  @override
  List<Object> get props => [myFeed];
}

class RemoveMyFeedEvent extends FeedEvent {
  final String myfeedID;
  RemoveMyFeedEvent({
    required this.myfeedID,
  });

  @override
  List<Object> get props => [myfeedID];
}


class TrigNewFeedsLoadingStateEvent extends FeedEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class TrigFeedNotExistStateEvent extends FeedEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class ResetFeedEvent extends FeedEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}
