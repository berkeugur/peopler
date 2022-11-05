import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/core/constants/enums/subscriptions_enum.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:restart_app/restart_app.dart';
import '../../../data/in_app_purchases.dart';
import '../../../data/model/activity.dart';
import '../../../data/model/user.dart';
import '../../../data/repository/user_repository.dart';
import '../../../others/locator.dart';
import '../../../others/strings.dart';
import '../ChatBloc/chat_bloc.dart';
import '../CityBloc/city_bloc.dart';
import '../LocationBloc/location_bloc.dart';
import '../NotificationBloc/notification_bloc.dart';
import 'bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository = locator<UserRepository>();

  static List<MyActivity> myActivities = [];
  static MyUser? user;
  static MyUser? guestUser;

  final GlobalKey<NavigatorState> mainKey;

  StreamSubscription? _streamSubscription;
  bool _userListener = false;

  static LogInResult? revenueCatResult;
  static SubscriptionTypes entitlement = SubscriptionTypes.free;

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

  Future<void> closeStreams() async {
    await close();
    await CityBloc.closeStreams();
    await LocationBloc.closeStreams();
    await NotificationBloc.closeStreams();
    await ChatBloc.closeStreams();
  }

  Future initPurchaserInfoStream() async {
    updatePurchaseStatus();
    Purchases.addCustomerInfoUpdateListener((purchaserInfo) async {
      updatePurchaseStatus();
    });
  }

  Future updatePurchaseStatus() async {
    PurchaseApi.purchaserInfo = await Purchases.getCustomerInfo();

    final entitlements = PurchaseApi.purchaserInfo.entitlements.active.values.toList();
    if(entitlements.isEmpty ) {
      entitlement = SubscriptionTypes.free;
    } else {
      String entitlementIdentifier = entitlements[0].identifier.toString();
      if(entitlementIdentifier == "plus") {
        entitlement =  SubscriptionTypes.plus;
      } else if(entitlementIdentifier == "premium") {
        entitlement =  SubscriptionTypes.premium;
      } else {
        entitlement =  SubscriptionTypes.free;
      }
    }

    if(user == null) {
      return;
    }

    if(adminUsers.contains(user!.email)) {
      entitlement = SubscriptionTypes.admin;
    }
  }

  UserBloc(this.mainKey) : super(InitialUserState()) {
    on<signOutEvent>((event, emit) async {
      try {
        await closeStreams();
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
        if(user?.gender == 'Kadın') {
          user?.profileURL = Strings.defaultFemaleProfilePhotoUrl;
        } else if(user?.gender == 'Erkek'){
          user?.profileURL = Strings.defaultMaleProfilePhotoUrl;
        } else {
          user?.profileURL = Strings.defaultNonBinaryProfilePhotoUrl;
        }
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

        await _userRepository.saveUserToCityCollection(user!.userID, user!.city);
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
          case "weak-password":
            emit(WeakPasswordState());
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
        /// Check for isEmailVerified
        add(waitForVerificationEvent());

        /// Check for 15 minutes timed out
        DateTime _countDownFinishTime = user!.createdAt!.add(const Duration(minutes: 15));
        if (user?.isTheAccountConfirmed == false && _countDownFinishTime.isBefore(DateTime.now())) {
          Restart.restartApp();
        }

        /// If account is confirmed, then cancel timer
        if(user?.isTheAccountConfirmed == true) {
          _timer?.cancel();
        }
      });
    });

    on<resendVerificationLink>((event, emit) async {
      await _userRepository.sendEmailVerification();
    });

    on<updateUserInfoForLinkedInEvent>((event, emit) async {
      emit(SigningInState());

      await _userRepository.saveUserToCityCollection(user!.userID, user!.city);
      await _userRepository.updateUser(user!);

      await signedInUserPreparations();
      emit(SignedInState());
    });

    on<deleteUser>((event, emit) async {
      await closeStreams();
      await _userRepository.deleteUser(user!, password: event.password);
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