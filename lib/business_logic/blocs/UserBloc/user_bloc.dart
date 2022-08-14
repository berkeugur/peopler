import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/CityBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/LocationBloc/bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../../data/in_app_purchases.dart';
import '../../../data/model/activity.dart';
import '../../../data/model/user.dart';
import '../../../data/repository/user_repository.dart';
import '../../../others/locator.dart';
import 'bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository = locator<UserRepository>();

  static late List<MyActivity> myActivities;
  static MyUser? user;

  final GlobalKey<NavigatorState> mainKey;

  StreamSubscription? _streamSubscription;
  bool _userListener = false;

  static LogInResult? revenueCatResult;
  static String entitlement = "free";

  static final Set<String> adminUsers = {
    /*
    "mertsalar137@gmail.com",
    "mail@berkeugur.com",
    "alimetehanpetek@gmail.com",
    "ahmetrtmkk@hotmail.com",
     */
  };

  Future<void> signedInUserPreparations() async {
    /// Get activities related to user
    myActivities = await _userRepository.getActivities(user!.userID);

    /// RevenueCat Log In With UserID
    revenueCatResult = await Purchases.logIn(user!.userID);

    /// Init Purchaser Info Stream
    await initPurchaserInfoStream();

    if (_userListener == false) {
      _userListener = true;
      _streamSubscription = _userRepository
          .getMyUserWithStream(UserBloc.user!.userID)
          .listen((updatedUser) async {
        UserBloc.user!.updateFromPublicMap(updatedUser.toPublicMap());

        List<MyUser> tempList = [...CityBloc.allUserList];
        for(MyUser tempUser in  tempList){
          if(UserBloc.user!.savedUserIDs.contains(tempUser.userID)){
            CityBloc.allUserList.removeWhere((item) => item.userID == tempUser.userID);
          }

          if(UserBloc.user!.transmittedRequestUserIDs.contains(tempUser.userID)){
            CityBloc.allUserList.removeWhere((item) => item.userID == tempUser.userID);
          }

          if(UserBloc.user!.receivedRequestUserIDs.contains(tempUser.userID)){
            CityBloc.allUserList.removeWhere((item) => item.userID == tempUser.userID);
          }

          if(UserBloc.user!.connectionUserIDs.contains(tempUser.userID)){
            CityBloc.allUserList.removeWhere((item) => item.userID == tempUser.userID);
          }
        }

        tempList = [...LocationBloc.allUserList];
        for(MyUser tempUser in  tempList){
          if(UserBloc.user!.savedUserIDs.contains(tempUser.userID)){
            LocationBloc.allUserList.removeWhere((item) => item.userID == tempUser.userID);
          }

          if(UserBloc.user!.transmittedRequestUserIDs.contains(tempUser.userID)){
            LocationBloc.allUserList.removeWhere((item) => item.userID == tempUser.userID);
          }

          if(UserBloc.user!.receivedRequestUserIDs.contains(tempUser.userID)){
            LocationBloc.allUserList.removeWhere((item) => item.userID == tempUser.userID);
          }

          if(UserBloc.user!.connectionUserIDs.contains(tempUser.userID)){
            LocationBloc.allUserList.removeWhere((item) => item.userID == tempUser.userID);
          }
        }
      });
    }
  }

  Future initPurchaserInfoStream() async {
    updatePurchaseStatus();
    Purchases.addPurchaserInfoUpdateListener((purchaserInfo) async {
      updatePurchaseStatus();
    });
  }

  Future updatePurchaseStatus() async {
    PurchaseApi.purchaserInfo = await Purchases.getPurchaserInfo();

    final entitlements = PurchaseApi.purchaserInfo.entitlements.active.values.toList();
    entitlement = entitlements.isEmpty ? "free" : entitlements[0].toString();

    if(user == null) {
      return;
    }

    if(adminUsers.contains(user!.email)) {
      entitlement = "admin";
    }
  }

  UserBloc(this.mainKey) : super(InitialUserState()) {
    on<signOutEvent>((event, emit) async {
      try {
        await _userRepository.deleteToken(user!.userID);
        await _userRepository.signOut();
        await Purchases.logOut();
        user = null;
        emit(SignedOutState());
      } catch (e) {
        debugPrint("Signed Out Basarisiz" + e.toString());
      }
    });

    on<initializeMyUserEvent>((event, emit) async {
      user = MyUser();
    });

    on<uploadProfilePhoto>((event, emit) async {
      if (event.imageFile != null) {
        String downloadLink =
            await _userRepository.uploadFile(user!.userID, 'profile_photo', 'profile_photo.png', event.imageFile!);
        await _userRepository.updateProfilePhoto(user!.userID, downloadLink);
        user?.profileURL = downloadLink;
      } else {
        user!.profileURL =
            "https://firebasestorage.googleapis.com/v0/b/peopler-2376c.appspot.com/o/default_images%2Fdefault_profile_photo.png?alt=media&token=4e206459-e4cb-4bad-944b-7f5aaf074d9b";
        await _userRepository.updateProfilePhoto(user!.userID, user!.profileURL);
      }
    });

    on<checkUserSignedInEvent>((event, emit) async {
      try {
        /// Three seconds timeout is set to getCurrentUser
        user = await _userRepository.getCurrentUser().timeout(const Duration(seconds: 5));
        if (user == null) {
          emit(SignedOutState());
        } else if (user?.missingInfo == true) {
          emit(SignedInMissingInfoState());
        } else if (user?.isTheAccountConfirmed == false) {
          emit(SignedInNotVerifiedState());
        } else {
          await signedInUserPreparations();
          emit(SignedInState());
        }
      } catch (e) {
        debugPrint("Bloctaki current user hata:" + e.toString());
      }
    });

    on<signInWithLinkedInEvent>((event, emit) async {
      try {
        emit(SigningInState());

        user = await _userRepository.signInWithLinkedIn(event.customToken);

        if (user?.missingInfo == true) {
          emit(SignedInMissingInfoState());
        } else {
          await signedInUserPreparations();
          emit(SignedInState());
        }
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "invalid-email":
            emit(InvalidEmailState());
            break;
          case "user-not-found":
            emit(UserNotFoundState());
            break;
          case "email-already-in-use":
            emit(EmailAlreadyInUseState());
            break;
        }
        debugPrint(e.code);
        debugPrint(e.message);
      } catch (e) {
        debugPrint('unhandled exceptions');
      }
    });

    on<signInWithEmailandPasswordEvent>((event, emit) async {
      try {
        emit(SigningInState());
        user = await _userRepository.signInWithEmailAndPassword(event.email, event.password);

        if (user == null) {
          emit(SignErrorState());
        } else {
          await signedInUserPreparations();
          emit(SignedInState());
        }
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "invalid-email":
            emit(InvalidEmailState());
            break;
          case "user-not-found":
            emit(UserNotFoundState());
            break;
          case "wrong-password":
            emit(WrongPasswordState());
            break;
        }
        debugPrint(e.code);
        debugPrint(e.message);
      } catch (e) {
        debugPrint('unhandled exceptions');
      }
    });

    on<createUserWithEmailAndPasswordEvent>((event, emit) async {
      try {
        emit(SigningInState());
        MyUser? tempUser = await _userRepository.createUserWithEmailAndPassword(event.email, event.password);
        user!.userID = tempUser!.userID;
        user!.email = tempUser.email;
        await _userRepository.sendEmailVerification();

        user!.missingInfo = false;

        await _userRepository.updateUser(user!);

        emit(SignedInNotVerifiedState());
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "invalid-email":
            emit(InvalidEmailState());
            break;
          case "user-not-found":
            emit(UserNotFoundState());
            break;
          case "email-already-in-use":
            emit(EmailAlreadyInUseState());
            break;
        }
        debugPrint(e.code);
        debugPrint(e.message);
      } catch (e) {
        debugPrint('unhandled exceptions');
      }
    });

    on<resetPasswordEvent>((event, emit) async {
      try {
        await _userRepository.resetPassword(event.email);
        emit(ResetPasswordSentState());
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "invalid-email":
            emit(InvalidEmailState());
            break;
          case "user-not-found":
            emit(UserNotFoundState());
            break;
        }
        debugPrint(e.code);
        debugPrint(e.message);
      } catch (e) {
        debugPrint('unhandled exceptions');
      }
    });

    on<waitForVerificationEvent>((event, emit) async {
      bool isEmailVerified = await _userRepository.listenForEmailVerification();
      if (isEmailVerified == true) {
        await _userRepository.updateAccountConfirmed(user!.userID, true);
        user = await _userRepository.getCurrentUser();

        await signedInUserPreparations();
        emit(SignedInState());
      }
    });

    on<resendVerificationLink>((event, emit) async {
      await _userRepository.sendEmailVerification();
    });

    on<updateUserInfoForLinkedInEvent>((event, emit) async {
      emit(SigningInState());
      await _userRepository.updateUser(user!);

      await signedInUserPreparations();
      emit(SignedInState());
    });

    on<deleteUser>((event, emit) async {
      await _userRepository.deleteUser(user!.userID, user!.region);
      user = null;
      emit(InitialUserState());
    });
  }

  @override
  Future<void> close() async {
    if (_streamSubscription != null) {
      _streamSubscription?.cancel();
    }
    super.close();
  }
}
