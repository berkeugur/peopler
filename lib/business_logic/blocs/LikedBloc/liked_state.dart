import 'package:equatable/equatable.dart';

abstract class LikedState extends Equatable {
  const LikedState();
}

class LikeState extends LikedState {
  const LikeState();

  @override
  List<Object> get props => [];
}

class DislikeState extends LikedState {
  const DislikeState();

  @override
  List<Object> get props => [];
}

class NothingState extends LikedState {
  const NothingState();

  @override
  List<Object> get props => [];
}
