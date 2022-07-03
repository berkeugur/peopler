import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LikedEvent extends Equatable {}

class GetInitialLikedEvent extends LikedEvent {
  final String userID;
  final String feedID;
  GetInitialLikedEvent({
    required this.userID,
    required this.feedID,
  });

  @override
  List<Object> get props => [userID, feedID];
}

class SwapLikedEvent extends LikedEvent {
  final String type;
  final bool setClear;
  final String feedID;
  final String userID;

  SwapLikedEvent({
    required this.userID,
    required this.feedID,
    required this.type,
    required this.setClear
  });

  @override
  List<Object> get props => [userID, feedID, type, setClear];
}
