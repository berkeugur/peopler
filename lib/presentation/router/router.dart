import 'package:flutter/material.dart';
import 'package:peopler/core/constants/navigation/navigation_constants.dart';
import 'package:peopler/data/services/remote_config/remote_config.dart';
import 'package:peopler/presentation/screens/LoginAndRegisterScreen/BegForPermissionScreen/beg_for_permission_screen.dart';
import 'package:peopler/presentation/screens/LoginAndRegisterScreen/EmailAndPasswordScreen/email_pass_screen.dart';
import 'package:peopler/presentation/screens/LoginAndRegisterScreen/GenderSelectScreen/gender_select_screen.dart';
import 'package:peopler/presentation/screens/LoginAndRegisterScreen/LinkedInLoginScreen/linkedin_login.dart';
import 'package:peopler/presentation/screens/LoginAndRegisterScreen/ResetPasswordScreen/reset_password.dart';
import 'package:peopler/presentation/screens/LoginAndRegisterScreen/VerificationScreen/verification_screen.dart';
import 'package:peopler/presentation/screens/MaintenanceScreen/maintenance_screen.dart';
import '../../others/locator.dart';
import '../screens/HomeScreen/home_screen.dart';
import '../screens/LoginAndRegisterScreen/CreateProfileScreen/create_profile_screen.dart';
import '../screens/LoginAndRegisterScreen/LoginScreen/login_screen.dart';
import '../screens/LoginAndRegisterScreen/NameAndSurnameScreen/name_screen.dart';
import '../screens/LoginAndRegisterScreen/WelcomeScreen/welcome.dart';
import '../screens/OnBoardingScreen/onboardingscreen.dart';
import '../screens/SplashScreen/splash_screen.dart';
import '../screens/UpdateScreen/update_screen.dart';

class LoginRouter {
  // final FeedBloc _feedBloc = FeedBloc();
  // final SavedBloc _savedBloc = SavedBloc();

  Route? onGenerateRoute(RouteSettings routeSettings) {
    final FirebaseRemoteConfigService _remoteConfigService = locator<FirebaseRemoteConfigService>();
    if (_remoteConfigService.isMaintenance()) {
      return MaterialPageRoute(builder: (_) => const MaintenanceScreen());
    }

    if (_remoteConfigService.isUpdate()) {
      return MaterialPageRoute(builder: (_) => const UpdateScreen());
    }

    switch (routeSettings.name) {
      case NavigationConstants.INITIAL_ROUTE:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case NavigationConstants.ON_BOARDING:
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      case NavigationConstants.WELCOME:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case NavigationConstants.NAME_SCREEN:
        return MaterialPageRoute(builder: (_) => const NameScreen());
      case NavigationConstants.LOGIN_SCREEN:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case NavigationConstants.GENDER_SELECT_SCREEN:
        return MaterialPageRoute(builder: (_) => const GenderSelectScreen());
      case NavigationConstants.RESET_PASSWORD_SCREEN:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());
      case NavigationConstants.BEG_FOR_PERMISSION_SCREEN:
        return MaterialPageRoute(builder: (_) => const BegForPermissionScreen());
      case NavigationConstants.HOME_SCREEN:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case NavigationConstants.VERIFY_SCREEN:
        return MaterialPageRoute(builder: (_) => const VerificationScreen());
      case NavigationConstants.CREATE_PROFILE_SCREEN:
        return MaterialPageRoute(builder: (_) => const CreateProfileScreen());
      case NavigationConstants.EMAIL_AND_PASSWORD_SCREEN:
        return MaterialPageRoute(builder: (_) => const EmailAndPasswordScreen());
      case NavigationConstants.LINKEDIN_LOGIN_SCREEN:
        return MaterialPageRoute(builder: (_) => const LinkedInPage());

      default:
        debugPrint('ERROR: Login Router unknown route');
        return null;
    }
  }
}

      /*
            MaterialPageRoute(
                builder: (_) => MultiBlocProvider(providers: [
                  BlocProvider<FeedBloc>.value(value: _feedBloc),
                  BlocProvider<SavedBloc>.value(value: _savedBloc),
                    ], child: const HomeScreen()));
             */