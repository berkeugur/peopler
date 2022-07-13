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

class TrigNewFeedsLoadingStateEvent extends FeedEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class TrigFeedsLoadedStateEvent extends FeedEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}