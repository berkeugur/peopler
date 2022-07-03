import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/SavedBloc/bloc.dart';
import 'package:peopler/presentation/screens/LoginAndRegisterScreen/BegForPermissionScreen/beg_for_permission_screen.dart';
import 'package:peopler/presentation/screens/LoginAndRegisterScreen/EmailAndPasswordScreen/email_pass_screen.dart';
import 'package:peopler/presentation/screens/LoginAndRegisterScreen/GenderSelectScreen/gender_select_screen.dart';
import 'package:peopler/presentation/screens/LoginAndRegisterScreen/LinkedInLoginScreen/linkedin_login.dart';
import 'package:peopler/presentation/screens/LoginAndRegisterScreen/ResetPasswordScreen/reset_password.dart';
import 'package:peopler/presentation/screens/LoginAndRegisterScreen/VerificationScreen/verification_screen.dart';

import '../../business_logic/blocs/FeedBloc/feed_bloc.dart';
import '../screens/HomeScreen/home_screen.dart';
import '../screens/LoginAndRegisterScreen/CreateProfileScreen/create_profile_screen.dart';
import '../screens/LoginAndRegisterScreen/LoginScreen/login_screen.dart';
import '../screens/LoginAndRegisterScreen/NameAndSurnameScreen/name_screen.dart';
import '../screens/LoginAndRegisterScreen/WelcomeScreen/welcome.dart';
import '../screens/OnBoardingScreen/onboardingscreen.dart';
import '../screens/SplashScreen/splash_screen.dart';

class LoginRouter {
  final FeedBloc _feedBloc = FeedBloc();
  final SavedBloc _savedBloc = SavedBloc();

  Route? onGenerateRoute(RouteSettings routeSettings)  {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/onBoardingScreen':
        return MaterialPageRoute(builder: (_) => OnBoardingScreen());
      case '/welcomeScreen':
        return MaterialPageRoute(builder: (_) => WelcomeScreen());
      case '/nameScreen':
        return MaterialPageRoute(builder: (_) => NameScreen());
      case '/loginScreen':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/genderSelectScreen':
        return MaterialPageRoute(builder: (_) => GenderSelectScreen());
      case '/resetPasswordScreen':
        return MaterialPageRoute(builder: (_) => ResetPasswordScreen());
      case '/begForPermissionScreen':
        return MaterialPageRoute(builder: (_) => BegForPermissionScreen());
      case '/homeScreen':
        return
            //MaterialPageRoute(builder: (_) =>  CreateFakeUsersAndFeeds());

            MaterialPageRoute(
                builder: (_) => MultiBlocProvider(providers: [
                  BlocProvider<FeedBloc>.value(value: _feedBloc),
                  BlocProvider<SavedBloc>.value(value: _savedBloc),
                    ], child: HomeScreen()));
      case '/verifyScreen':
        return MaterialPageRoute(builder: (_) => VerificationScreen());
      case '/createProfileScreen':
        return MaterialPageRoute(builder: (_) => CreateProfileScreen());
      case '/emailAndPasswordScreen':
        return MaterialPageRoute(builder: (_) => EmailAndPasswordScreen());
      case '/linkedInLoginScreen':
        return MaterialPageRoute(builder: (_) => LinkedInPage());


      default:
        debugPrint('ERROR: Login Router unknown route');
        return null;
    }
  }
}
