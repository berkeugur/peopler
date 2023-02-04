import 'package:flutter/material.dart';
import 'package:peopler/core/constants/navigation/navigation_constants.dart';
import 'package:peopler/data/services/remote_config/remote_config.dart';
import 'package:peopler/components/FlutterWidgets/drawer.dart';
import 'package:peopler/presentation/screens/LOGIN_REGISTER/BegForPermissionScreen/beg_for_permission_screen.dart';
import 'package:peopler/presentation/screens/LOGIN_REGISTER/EmailAndPasswordScreen/email_pass_screen.dart';
import 'package:peopler/presentation/screens/LOGIN_REGISTER/GenderSelectScreen/gender_select_screen.dart';
import 'package:peopler/presentation/screens/LOGIN_REGISTER/LinkedInLoginScreen/linkedin_login.dart';
import 'package:peopler/presentation/screens/LOGIN_REGISTER/ResetPasswordScreen/reset_password.dart';
import 'package:peopler/presentation/screens/LOGIN_REGISTER/VerificationScreen/verification_screen.dart';
import 'package:peopler/presentation/screens/MAINTENANCE/maintenance_screen.dart';
import 'package:peopler/presentation/screens/REGISTER/register_linkedin_screens.dart';
import '../../others/locator.dart';
import '../screens/LOGIN_REGISTER/CreateProfileScreen/create_profile_screen.dart';
import '../screens/LOGIN_REGISTER/LoginScreen/login_screen.dart';
import '../screens/LOGIN_REGISTER/NameAndSurnameScreen/name_screen.dart';
import '../screens/LOGIN_REGISTER/WelcomeScreen/welcome.dart';
import '../screens/ONBOARDING/onboardingscreen.dart';
import '../screens/SPLASH/splash_screen.dart';
import '../screens/UPDATE/update_screen.dart';

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
        return MaterialPageRoute(builder: (_) => const DrawerHomePage());
      case NavigationConstants.VERIFY_SCREEN:
        return MaterialPageRoute(builder: (_) => const VerificationScreen());
      case NavigationConstants.CREATE_PROFILE_SCREEN:
        return MaterialPageRoute(builder: (_) => const CreateProfileScreen());
      case NavigationConstants.EMAIL_AND_PASSWORD_SCREEN:
        return MaterialPageRoute(builder: (_) => const EmailAndPasswordScreen());
      case NavigationConstants.LINKEDIN_LOGIN_SCREEN:
        return MaterialPageRoute(builder: (_) => const LinkedInPage());
      case NavigationConstants.CONTINUE_WITH_LINKEDIN:
        return MaterialPageRoute(builder: (_) => const LinkedinRegisterScreens());

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