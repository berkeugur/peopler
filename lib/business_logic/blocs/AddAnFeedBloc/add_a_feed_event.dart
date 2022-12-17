import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../../data/model/feed.dart';

@immutable
abstract class AddFeedEvent extends Equatable {}

class AddAFeedEvent extends AddFeedEvent {
  final MyFeed myFeed;

  AddAFeedEvent({
    required this.myFeed,
  });

  @override
  List<Object> get props => [myFeed];
}

class RemoveAFeedEvent extends AddFeedEvent {
  final String myFeedID;

  RemoveAFeedEvent({
    required this.myFeedID,
  });

  @override
  List<Object> get props => [myFeedID];
}
