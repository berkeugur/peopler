import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:restart_app/restart_app.dart';
import '../../../data/in_app_purchases.dart';
import '../../../data/model/activity.dart';
import '../../../data/model/user.dart';
import '../../../data/repository/user_repository.dart';
import '../../../others/locator.dart';
import '../../../others/strings.dart';
import 'bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository = locator<UserRepository>();

  static late List<MyActivity> myActivities;
  static MyUser? user;
  static MyUser? guestUser;

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

  Timer? _timer;

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
        UserBloc.user!.fromPublicMap(updatedUser.toPublicMap());
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
        Restart.restartApp();
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
        user!.profileURL = Strings.defaultProfilePhotoUrl;
        await _userRepository.updateProfilePhoto(user!.userID, user!.profileURL);
      }
    });

    on<checkUserSignedInEvent>((event, emit) async {
      try {
        /// Three seconds timeout is set to getCurrentUser
        user = await _userRepository.getCurrentUser().timeout(const Duration(seconds: 5));

        DateTime? _countDownFinishTime;
        if(user != null) {
          _countDownFinishTime = user!.createdAt!.add(const Duration(minutes: 15));
        }

        if (user == null) {
          emit(SignedOutState());
        } else if (user?.missingInfo == true) {
          emit(SignedInMissingInfoState());
        } else if (user?.isTheAccountConfirmed == false && _countDownFinishTime!.isBefore(DateTime.now())) {
          emit(SignedInNotVerifiedState());
        } else if (user?.isTheAccountConfirmed == false && _countDownFinishTime!.isAfter(DateTime.now())) {
          add(waitFor15minutes());
          emit(SignedInState());
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

    on<waitFor15minutes>((event, emit) async {
      user = await _userRepository.getCurrentUser();
      await signedInUserPreparations();
      emit(SignedInState());

      _timer = Timer.periodic(const Duration(seconds: 10), (Timer t) {
        /// Check for isEmailVerifid
        add(waitForVerificationEvent());

        /// Check for 15 minutes timed out
        DateTime _countDownFinishTime = user!.createdAt!.add(const Duration(minutes: 15));
        if (user?.isTheAccountConfirmed == false && _countDownFinishTime.isBefore(DateTime.now())) {
          Restart.restartApp();
        }
      });
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
      Restart.restartApp();
    });
  }

  @override
  Future<void> close() async {
    if (_streamSubscription != null) {
      _streamSubscription?.cancel();
    }

    if(_timer != null) {
      _timer?.cancel();
    }
    super.close();
  }
}