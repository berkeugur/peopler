import 'package:flutter/material.dart';
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

  Route? onGenerateRoute(RouteSettings routeSettings)  {
    final FirebaseRemoteConfigService _remoteConfigService = locator<FirebaseRemoteConfigService>();
    if(_remoteConfigService.isMaintenance()) {
      return MaterialPageRoute(builder: (_) => const MaintenanceScreen());
    }

    if(_remoteConfigService.isUpdate()) {
      return MaterialPageRoute(builder: (_) => const UpdateScreen());
    }

    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/onBoardingScreen':
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      case '/welcomeScreen':
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case '/nameScreen':
        return MaterialPageRoute(builder: (_) => const NameScreen());
      case '/loginScreen':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/genderSelectScreen':
        return MaterialPageRoute(builder: (_) => const GenderSelectScreen());
      case '/resetPasswordScreen':
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());
      case '/begForPermissionScreen':
        return MaterialPageRoute(builder: (_) => const BegForPermissionScreen());
      case '/homeScreen':
        return MaterialPageRoute(builder: (_) =>  const HomeScreen());

            /*
            MaterialPageRoute(
                builder: (_) => MultiBlocProvider(providers: [
                  BlocProvider<FeedBloc>.value(value: _feedBloc),
                  BlocProvider<SavedBloc>.value(value: _savedBloc),
                    ], child: const HomeScreen()));
             */
      case '/verifyScreen':
        return MaterialPageRoute(builder: (_) => const VerificationScreen());
      case '/createProfileScreen':
        return MaterialPageRoute(builder: (_) => const CreateProfileScreen());
      case '/emailAndPasswordScreen':
        return MaterialPageRoute(builder: (_) => const EmailAndPasswordScreen());
      case '/linkedInLoginScreen':
        return MaterialPageRoute(builder: (_) => const LinkedInPage());

      default:
        debugPrint('ERROR: Login Router unknown route');
        return null;
    }
  }
}
