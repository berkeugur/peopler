import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repository/user_repository.dart';
import '../../../others/locator.dart';
import '../../../others/strings.dart';
import 'bloc.dart';

class LikedBloc extends Bloc<LikedEvent, LikedState> {
  final UserRepository _userRepository = locator<UserRepository>();

  LikedBloc() : super(const NothingState()) {
    on<GetInitialLikedEvent>((event, emit) async {
      bool? isLikedOrDislikedByUser = await _userRepository.isLikedOrDislikedByUser(event.userID, event.feedID);
      if (isLikedOrDislikedByUser == true) {
        emit(const LikeState());
      } else if (isLikedOrDislikedByUser == false) {
        emit(const DislikeState());
      } else {
        emit(const NothingState());
      }
    });

    on<SwapLikedEvent>((event, emit) async {
      if (event.type == Strings.activityLiked) {
        if (event.setClear == true) {
          LikedState previousState = state;
          emit(const LikeState());
          await _userRepository.addLikedDislikedFeed(event.userID, event.feedID, Strings.activityLiked);
          if (previousState is DislikeState) {
            await _userRepository.removeLikedDislikedFeed(event.userID, event.feedID, Strings.activityDisliked);
          }

        } else {
          emit(const NothingState());
          await _userRepository.removeLikedDislikedFeed(event.userID, event.feedID, Strings.activityLiked);
        }
      } else {
        if (event.setClear == true) {
          LikedState previousState = state;
          emit(const DislikeState());
          await _userRepository.addLikedDislikedFeed(event.userID, event.feedID, Strings.activityDisliked);
          if (previousState is LikeState) {
            await _userRepository.removeLikedDislikedFeed(event.userID, event.feedID, Strings.activityLiked);
          }
        } else {
          emit(const NothingState());
          await _userRepository.removeLikedDislikedFeed(event.userID, event.feedID, Strings.activityDisliked);
        }
      }
    });
  }
}
