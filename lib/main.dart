import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/LocationBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/NotificationTransmittedBloc/bloc.dart';
import 'package:peopler/business_logic/cubits/FloatingActionButtonCubit.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/presentation/router/router.dart';
import 'business_logic/blocs/ChatBloc/chat_bloc.dart';
import 'business_logic/blocs/CityBloc/city_bloc.dart';
import 'business_logic/blocs/LocationPermissionBloc/location_permission_bloc.dart';
import 'business_logic/blocs/LocationUpdateBloc/location_update_bloc.dart';
import 'business_logic/blocs/NotificationBloc/notification_bloc.dart';
import 'business_logic/blocs/NotificationReceivedBloc/notification_received_bloc.dart';
import 'business_logic/blocs/PuchaseGetOfferBloc/purchase_get_offer_bloc.dart';
import 'business_logic/blocs/UserBloc/user_bloc.dart';
import 'others/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }

  /// Request IOS Notification
  await FirebaseMessaging.instance.requestPermission();

  await setupLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final LoginRouter _loginRouter = LoginRouter();
  final GlobalKey<NavigatorState> mainKey = GlobalKey();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return MultiBlocProvider(
              providers: [
                BlocProvider<CityBloc>(create: (context) => CityBloc()),
                BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
                BlocProvider<UserBloc>(create: (context) => UserBloc(mainKey)),
                BlocProvider<LocationBloc>(create: (context) => LocationBloc()),
                BlocProvider<LocationUpdateBloc>(
                    create: (context) => LocationUpdateBloc()),
                BlocProvider<LocationPermissionBloc>(
                    create: (context) => LocationPermissionBloc()),
                BlocProvider<FloatingActionButtonCubit>(
                    create: (context) => FloatingActionButtonCubit()),
                BlocProvider<NotificationTransmittedBloc>(
                    create: (context) => NotificationTransmittedBloc()),
                BlocProvider<NotificationReceivedBloc>(
                    create: (context) => NotificationReceivedBloc()),
                BlocProvider<NotificationBloc>(
                    create: (context) => NotificationBloc()),
                BlocProvider<ChatBloc>(create: (context) => ChatBloc()),
                BlocProvider<PurchaseGetOfferBloc>(create: (context) => PurchaseGetOfferBloc()),
              ],
              child: MaterialApp(
                  navigatorKey: mainKey,
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                  ),
                  onGenerateRoute: _loginRouter.onGenerateRoute));
        });
  }
}
