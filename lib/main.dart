import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:path_provider/path_provider.dart';
import 'package:peopler/business_logic/blocs/LocationBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/NotificationTransmittedBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/PurchaseMakePurchaseBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/SavedBloc/bloc.dart';
import 'package:peopler/business_logic/cubits/FloatingActionButtonCubit.dart';
import 'package:peopler/business_logic/cubits/NewMessageCubit.dart';
import 'package:peopler/business_logic/cubits/NewNotificationCubit.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/core/constants/enums/gender_types_enum.dart';
import 'package:peopler/data/model/feed.dart';
import 'package:peopler/data/model/user.dart';
import 'package:peopler/data/services/db/firebase_db_service_location.dart';
import 'package:peopler/data/services/db/firestore_db_service_feeds.dart';
import 'package:peopler/data/services/storage/firebase_storage_service.dart';
import 'package:peopler/presentation/router/router.dart';
import 'business_logic/blocs/ChatBloc/chat_bloc.dart';
import 'business_logic/blocs/CityBloc/city_bloc.dart';
import 'business_logic/blocs/FeedBloc/feed_bloc.dart';
import 'business_logic/blocs/LocationPermissionBloc/location_permission_bloc.dart';
import 'business_logic/blocs/LocationUpdateBloc/location_update_bloc.dart';
import 'business_logic/blocs/NotificationBloc/notification_bloc.dart';
import 'business_logic/blocs/NotificationReceivedBloc/notification_received_bloc.dart';
import 'business_logic/blocs/PuchaseGetOfferBloc/purchase_get_offer_bloc.dart';
import 'business_logic/blocs/UserBloc/user_bloc.dart';
import 'data/repository/user_repository.dart';
import 'data/services/auth/firebase_auth_service.dart';
import 'data/services/db/firebase_db_common.dart';
import 'data/services/db/firestore_db_service_users.dart';
import 'others/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }

  /// Request IOS Notification
  await FirebaseMessaging.instance.requestPermission();

  await setupLocator();

  // await updatePhotoUrl();
  // await fakeUserCreator();
  // await fakeUserDelete();
  // await updateAllFakeUserPhotos();
  // await fakeFeedCreator();

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
              BlocProvider<FeedBloc>(create: (context) => FeedBloc()),
              BlocProvider<SavedBloc>(create: (context) => SavedBloc()),
              BlocProvider<CityBloc>(create: (context) => CityBloc()),
              BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
              BlocProvider<UserBloc>(create: (context) => UserBloc(mainKey)),
              BlocProvider<LocationBloc>(create: (context) => LocationBloc()),
              BlocProvider<LocationUpdateBloc>(create: (context) => LocationUpdateBloc()),
              BlocProvider<LocationPermissionBloc>(create: (context) => LocationPermissionBloc()),
              BlocProvider<FloatingActionButtonCubit>(create: (context) => FloatingActionButtonCubit()),
              BlocProvider<NewNotificationCubit>(create: (context) => NewNotificationCubit()),
              BlocProvider<NewMessageCubit>(create: (context) => NewMessageCubit()),
              BlocProvider<NotificationTransmittedBloc>(create: (context) => NotificationTransmittedBloc()),
              BlocProvider<NotificationReceivedBloc>(create: (context) => NotificationReceivedBloc()),
              BlocProvider<NotificationBloc>(create: (context) => NotificationBloc()),
              BlocProvider<ChatBloc>(create: (context) => ChatBloc()),
              BlocProvider<PurchaseGetOfferBloc>(create: (context) => PurchaseGetOfferBloc()),
              BlocProvider<PurchaseMakePurchaseBloc>(create: (context) => PurchaseMakePurchaseBloc()),
            ],
            child: MaterialApp(
                navigatorKey: mainKey,
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primarySwatch: const MaterialColor(
                    0xFF0353EF,
                    <int, Color>{
                      50: Color(0xFF0353EF),
                      100: Color(0xFF0353EF),
                      200: Color(0xFF0353EF),
                      300: Color(0xFF0353EF),
                      400: Color(0xFF0353EF),
                      500: Color(0xFF0353EF),
                      600: Color(0xFF0353EF),
                      700: Color(0xFF0353EF),
                      800: Color(0xFF0353EF),
                      900: Color(0xFF0353EF),
                    },
                  ),
                ),
                onGenerateRoute: _loginRouter.onGenerateRoute));
      },
    );
  }
}




List<String> displayName = [
  'Sevgi',
  'Ceyda',
  'Tuba',
  'Ada',
  'Aleida',
  'Aleyna',
  'Joanna',
  'Emine',
  'Ayça',
  'Sıla',
  'Şeyma',
  'Güneş',
  'Selin',
  'Melis',
  'Zeynep',
  'Pınar',
  'Esra',
  'Ülkü',
  'Çağla',
  'Nil',
  'Beyza',
  'Melek',
  'Betül',
  'Didem',
  'Elif',
  'Başak',
  'Ilgın',
  'Dennis',
  'Damla',
  'Nisa',
  'Gece',
  'Yasemin',
  'Birgün',
  'Buse',
  'Semiha',
  'Buket',
];

List<String> biography = [
  'nothing special',
  '3 kedim var sürekli konsere gidiyorum',
  'Passiforalı çaya bayılırım',
  'bakmaya geldim',
  'i don\'t have premium',
  'Mentalim çöktü kendimle başbaşa kalamıyorum',
  'Erasmus student from Poland. I don\'t know anyone on bogazici',
  'Positive person 🥺',
  'psychology, nature, energy, spirituality, world, music',
  'luv',
  'broker and trader girl',
  'İstanbulda yaşamaktan nefret ediyorum',
  'Half time engineer, full time concert lover',
  'İngilizce havalı cümleler',
  'Outgoing introvert',
  'ay buraya ne yazıyos',
  'i don\'t have Instagram',
  'İlkkan\'ın haklı bulmadığı kadın',
  'İtü computer',
  'baya sıkıcı',
  'i do love music play piano and write songs idk',
  'living for art',
  'her şeyi unuturum 🥰😊',
  'elbet bir şey olmuştur tabii',
  'yiyip içip yatıyorum',
  'sanat sepet',
  'temas bağımlısı enerjik',
  'the weeknd- shameless',
  'hey, you!',
  'bakıyorum güneşe evet diyorum doğmuş güneşim',
  'avarage taylor swift listener',
  'buraya ne yazılıyor',
  'buraya destan gibi yazanlara ne deniyor',
  'sociology',
  'o kız',
  'boğaziçi zort',
];

List<String> profilePhoto = [
  '1gL3Pb8shAcFCn3QyDW58jV5U3_vucgFA',
  '1GcPGUjS_9gyilgcLiZup8LOlLWZsvNt9',
  '1nO4EqAcAEx8OSjh1vkZL2LTyu7FKgVEq',
  '1KiofiYhrwJ7Sd-EZD2NI-8K27f80YfEO',
  '1KVo_G6vTGR5n5Qpw396SR_Hv6AVo16oK',
  '1__mdE3DAVfU2XBfIM4kJXP3Gz_vdPRw9',
  '1naoHFb8-Q7nfGASc_1D60K8p6F00nMtp',
  '14YxQwoBFM7Ss-whl4qDVFWCQk5gnMLyL',
  '1THCWPKkIjmiETIuLVJvCOONoHTe37tHt',
  '1kYcIVg6x3-OezLYhQrzZejjuqutkUsmM',
  '1rCnilAboUX0HZDCdh_HZijftGWctNYKy',
  '1l3-FQ8UgFSyBJxt2F1vWNLChUfczi3wI',
  '18gViMkEHicD2T0HxKsbjhCb7s3qNUqy4',
  '1CRuL49Qr3Y99yR4-tlqxI5XOwoL5IQQu',
  '1YWmjb9O5dluPWQyOndml83EsBBZdX-T1',
  '1Js-JIHUzWFEQPnKG7UGRxD4vrRYY6S8R',
  '1FpMCyjN1qXzlzRbdCf79aRCebHz3WQdd',
  '1chwrGKBoSMWuIAJqWfKBLZh1QqB0eMue',
  '1CFnziKbJnnzDMuksGadTG4ePsPStM-27',
  '1VeapAXM-OdIq-DfWKj4_22spAFIVTBW9',
  '1jzXEp30G5Fmutqj1kItb6nVsxpBd8-md',
  '1R23niZ9Ly4n2A5NJkz1gkQAeExLC4uv2',
  '1O_OE4yrEVXItROd1ExJVVNSM3c9JpAtC',
  '1SQw3LUXmILtRsgXUS1b9K6Ln2yn-G6qO',
  '19WZlqE02xEbmio6_gtXaeb4dHcENa1gy',
  '1Ean3M_Ifly_TgcL3rEQbQXvFxAh8HPe1',
  '1MfgbKBjFrGGktAbOl9ik3Fo7T8EwELRc',
  '1FKm0OqCe1jDzlwXtAFwq6MqH-9Aj4gXo',
  '1ZKwaXyrQyBiDHtvrlXk-En_gtZgerFzL',
  '1sKmtjPbr_8AtnXlUOnjoVKfouaK29O0q',
  '1uzp0rErtyNgL650rw2gSGNr2hMvZAJ0w',
  '1UbiqMKUcd63BGO4BWzlpDq9zzGRexdK3',
  '1Hh1p6W9OnrY4Q3tjVl-71TBbFr7_6Nqk',
  '1t-2DOkluVkwDU0ZjQ3_dPfKTCaxU9NWM',
  '15JLNezREptTwbYRPG8EsJDLOSiNo3Ui6',
  '18sDb8tg16LTvFBtjb4hyHuueqvjP4mEw',
];



Future<void> updateAllFakeUserPhotos() async {
  for(int i=0; i<36; i++) {
    String userID = 'fake' + i.toString();
    String profileURL = 'https://drive.google.com/uc?export=view&id=' + profilePhoto[i];

    await updateFakeUserPhoto(userID, profileURL);
  }
}

Future<void> updateFakeUserPhoto(String userID, String profileURL) async {
  final UserRepository _userRepository = locator<UserRepository>();

  File imageFile = await _downloadFile(profileURL);

  String downloadLink = await _userRepository.uploadFile(userID, 'profile_photo', 'profile_photo.png', imageFile);
  await _userRepository.updateProfilePhoto(userID, downloadLink);
}

Future<void> updatePhotoUrl() async {
  final UserRepository _userRepository = locator<UserRepository>();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  for(int i=0; i<36; i++) {
    String userID = 'fake' + i.toString();
    String _filePath = userID  + '/profile_photo';
    Reference _storageReference = _firebaseStorage.ref().child(_filePath).child('profile_photo.png');
    String url = await _storageReference.getDownloadURL();

    await _userRepository.updateProfilePhoto(userID, url);
  }
}

Future<void> fakeUserCreator() async {
  FirestoreDBServiceUsers _fu = locator<FirestoreDBServiceUsers>();
  FirestoreDBServiceLocation _fl = locator<FirestoreDBServiceLocation>();
  UserRepository _ur = locator<UserRepository>();

  for(int i=0; i<36; i++) {
    MyUser theUser = MyUser();
    theUser.userID = 'fake' + i.toString();
    theUser.city = 'İstanbul';
    theUser.gender = 'Kadın';
    theUser.displayName = displayName[i];
    theUser.biography = biography[i];

    String profileURL = 'https://drive.google.com/uc?export=view&id=' + profilePhoto[i];
    await updateFakeUserPhoto(theUser.userID, profileURL);

    await _fu.saveUser(theUser);
    await _fl.setUserInRegion(theUser.userID, '3984700,3281500');
    await _ur.saveUserToCityCollection(theUser.userID, theUser.city);
  }
}

Future<void> fakeUserDelete() async {
  FirestoreDBServiceUsers _fu = locator<FirestoreDBServiceUsers>();
  FirestoreDBServiceCommon _fc = locator<FirestoreDBServiceCommon>();
  FirestoreDBServiceLocation _fl = locator<FirestoreDBServiceLocation>();
  FirebaseStorageService _fs = locator<FirebaseStorageService>();

  for(int i=0; i<36; i++) {
    String userID = 'fake' + i.toString();

    await _fc.deleteNestedSubCollections("users/" + userID + "/activities");
    await _fc.deleteNestedSubCollections("users/" + userID + "/notifications");
    await _fc.deleteNestedSubCollections("users/" + userID + "/liked");
    await _fc.deleteNestedSubCollections("users/" + userID + "/disliked");
    await _fc.deleteNestedSubCollections("users/" + userID + "/savedUsers");
    await _fc.deleteNestedSubCollections("users/" + userID + "/private");

    /// Delete all messages
    List<String> chatIDList = await _fc.getAllDocumentIDs("users/" + userID + "/chats");
    for (String chatID in chatIDList) {
      await _fc.deleteNestedSubCollections("users/" + userID + "/chats/" + chatID + "/messages");
    }

    /// Delete all chats after messages (subcollections of chats) deleted
    await _fc.deleteNestedSubCollections("users/" + userID + "/chats");

    /// Delete user from his/her last region
    _fl.deleteUserFromRegion(userID, '3984700,3281500');

    /// Delete user from firestore
    await _fu.deleteUser(userID);

    /// Delete userID's folder from Storage
    await _fs.deleteFolder(userID);
  }
}


Future<void> fakeCityCreator() async {
  UserRepository _ur = locator<UserRepository>();

  String city = "CitadelOfMert";

  for(int i=0; i<500; i++) {
    String userID = 'fake' + i.toString();

    await _ur.saveUserToCityCollection(userID, city);
  }
}

Future<void> fakeFeedCreator() async {
  FirestoreDBServiceFeeds _fe = locator<FirestoreDBServiceFeeds>();

  for(int i=0; i<200; i++) {
    MyFeed theFeed = MyFeed(userID: "yMSTAPEcJPO7vVdrbLGeOSjvmUF3");
    theFeed.feedExplanation = i.toString();
    theFeed.userGender = 'Erkek';

    await _fe.createFeed(theFeed);
  }
}

Future<File> _downloadFile(String url) async {
  String filename = "temp";

  var httpClient = HttpClient();
  var request = await httpClient.getUrl(Uri.parse(url));
  var response = await request.close();
  var bytes = await consolidateHttpClientResponseBytes(response);
  String dir = (await getApplicationDocumentsDirectory()).path;
  File file = File('$dir/$filename');
  await file.writeAsBytes(bytes);
  return file;
}