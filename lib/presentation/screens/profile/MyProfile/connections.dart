import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/presentation/screens/profile/MyProfile/connections_service.dart';
import '../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../others/locator.dart';
import '../../../../others/strings.dart';
import '../../MessageScreen/message_screen.dart';
import '../../clickMessage.dart';

class Connection {
  final String profilePhotoUrl;
  final String fullName;
  final String city;
  final String bio;
  final String id;
  final List<String> mutualConnectionsProfilePhotos;
  Connection(
      {required this.id,
      required this.bio,
      required this.profilePhotoUrl,
      required this.fullName,
      required this.city,
      required this.mutualConnectionsProfilePhotos});
}

int? numberOfTotalConnections = UserBloc.user?.connectionUserIDs.length;

class ConnectionsScreen extends StatefulWidget {
  const ConnectionsScreen({Key? key}) : super(key: key);

  @override
  _ConnectionsScreenState createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> {
  final Mode _mode = locator<Mode>();
  List<Connection> connections = [];
  getUserData() async {
    if (UserBloc.user != null && connections.length != UserBloc.user?.connectionUserIDs.length) {
      for (var userID in UserBloc.user!.connectionUserIDs) {
        var userData = await FirebaseFirestore.instance.collection("users").doc(userID).get();
        Map<String, dynamic>? jsonUserData = userData.data();
        if (jsonUserData != null) {
          connections.add(
            Connection(
              id: jsonUserData["userID"],
              bio: jsonUserData["biography"],
              profilePhotoUrl: jsonUserData["profileURL"],
              fullName: jsonUserData["displayName"],
              city: jsonUserData["city"],
              mutualConnectionsProfilePhotos: [],
            ),
          );
        }
      }
      setState(() {});
    } else if (UserBloc.user == null) {
      print("user bloc null connection screen #213mm3l1");
    } else {
      print("connection screen error #3141xa");
    }
  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    print("connectionuserids");
    print(UserBloc.user?.connectionUserIDs ?? "null döndü");
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    double _maxWidth = _size.width > 480 ? 480 : _size.width;
    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return Scaffold(
            backgroundColor: _mode.search_peoples_scaffold_background(),
            body: Column(
              children: [
                _connections_header(),
                _number_of_total_connections(),
                Expanded(
                  child: Container(
                    color: _mode.search_peoples_scaffold_background(),
                    child: SizedBox(
                      width: _maxWidth,
                      child: ListView.builder(
                        itemCount: connections.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        itemBuilder: (context, index) {
                          return connectionUserItem(context, index, setState);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Container connectionUserItem(BuildContext context, int index, StateSetter setState) {
    final Mode _mode = locator<Mode>();

    double _buttonSize = 28;
    Size _size = MediaQuery.of(context).size;
    double _customTextSize() {
      if (_size.width <= 320) {
        return 12;
      } else if (_size.width > 320 && _size.width < 480) {
        return 13;
      } else {
        return 14;
      }
    }

    double _customSmallTextSize() {
      if (_size.width <= 320) {
        return 10;
      } else if (_size.width > 320 && _size.width < 480) {
        return 11;
      } else {
        return 12;
      }
    }

    Connection _data = connections[index];
    double _maxWidth = _size.width > 480 ? 480 : _size.width;
    double _leftColumnSize() {
      double _screenWidth = _size.width;
      if (_screenWidth <= 320) {
        return 44;
      } else if (_screenWidth > 320 && _screenWidth < 480) {
        return 50;
      } else {
        return 54;
      }
    }

    double _rightColumnSize = _buttonSize;
    double _centerColumnSize = _maxWidth - _leftColumnSize() - _rightColumnSize - 40;

    return Container(
      width: _maxWidth,
      decoration: BoxDecoration(
        color: _mode.bottomMenuBackground(),
        boxShadow: <BoxShadow>[BoxShadow(color: Color(0xFF939393).withOpacity(0.6), blurRadius: 0.5, spreadRadius: 0, offset: const Offset(0, 0))],
        //border: Border.symmetric(horizontal: BorderSide(color: _mode.blackAndWhiteConversion() as Color,width: 0.2, style: BorderStyle.solid,))
      ),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            //color: Colors.green,
            width: _leftColumnSize(),
            height: _leftColumnSize(),
            child: InkWell(
                onTap: () {
                  ConnectionService().pushOthersProfile(context: context, otherProfileID: _data.id);
                },
                child: profilePhoto(context, _data.profilePhotoUrl)),
          ),
          SizedBox(
            //color: Colors.orange,
            width: _centerColumnSize,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      ConnectionService().pushOthersProfile(context: context, otherProfileID: _data.id);
                    },
                    child: SizedBox(
                      child: Text(
                        _data.fullName,
                        textScaleFactor: 1,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: GoogleFonts.rubik(color: _mode.blackAndWhiteConversion(), fontSize: _customTextSize()),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      _data.city + "/" + _data.city,
                      style: GoogleFonts.rubik(fontSize: _customTextSize() - 1, color: Colors.grey),
                      textScaleFactor: 1,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      _data.bio,
                      style: GoogleFonts.rubik(fontSize: _customTextSize() - 1, color: Colors.grey),
                      textScaleFactor: 1,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  _data.mutualConnectionsProfilePhotos.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${_data.mutualConnectionsProfilePhotos.length} ortak bağlantı",
                                textScaleFactor: 1,
                                style: GoogleFonts.rubik(fontSize: _customSmallTextSize(), color: Color(0xFF0353EF)),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
          SizedBox(
            //color: Colors.red,
            width: _rightColumnSize,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
                    _userBloc.mainKey.currentState?.push(
                      MaterialPageRoute(
                          builder: (context) => MessageScreen(
                            requestUserID: _data.id,
                            requestProfileURL: _data.profilePhotoUrl,
                            requestDisplayName: _data.fullName,
                          )),
                    );
                  },
                  child: SizedBox(
                    height: _buttonSize,
                    width: _buttonSize,
                    child: const Icon(
                      Icons.send,
                      color: Color(0xFF0353EF),
                    ),
                  ),
                ),
              ],
            ),
            //_rightColumn(_data.dateTime, _customTextSize()-2),
          )
        ],
      ),
    );
  }

  Widget _number_of_total_connections() {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            0,
            20,
            10,
          ),
          child: Text(
            "$numberOfTotalConnections bağlantı",
            textScaleFactor: 1,
            style: GoogleFonts.rubik(fontSize: 14, color: _mode.blackAndWhiteConversion()),
          ),
        ));
  }

  // ignore: non_constant_identifier_names
  Container _connections_header() {
    return Container(
      decoration: BoxDecoration(
        color: _mode.bottomMenuBackground(),
      ),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SvgPicture.asset(
              txt.backArrowSvgTXT,
              width: 25,
              height: 25,
              color: _mode.homeScreenIconsColor(),
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox.square(
            dimension: 25,
          ),
          Text(
            "Bağlantılar",
            textScaleFactor: 1,
            style: GoogleFonts.rubik(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF0353EF)),
          ),
          /* Search Bar
          Expanded(
            child: TextField(
              onTap: () async {},
              //placeholder: "Arama yapabilirsiniz...",
              style: GoogleFonts.rubik(),
              autocorrect: true,

              decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  hintText: "Arama Yap",
                  hintStyle: GoogleFonts.rubik(fontSize: 16, color: _mode.blackAndWhiteConversion())),
              //backgroundColor: CupertinoColors.extraLightBackgroundGray,
              onChanged: (String value) {},
              onSubmitted: (String value) {
                debugPrint('Submitted text: $value');
              },
            ),
          ),
          */
          const SizedBox.square(
            dimension: 25,
          )
        ],
      ),
    );
  }
}

Stack profilePhoto(BuildContext context, String _data) {
  double _screenWidth = MediaQuery.of(context).size.width;
  double _photoSize() {
    if (_screenWidth <= 320) {
      return 40;
    } else if (_screenWidth > 320 && _screenWidth < 480) {
      return 48;
    } else {
      return 54;
    }
  }

  return Stack(
    children: [
      SizedBox(
        height: _photoSize(),
        width: _photoSize(),
        child: const CircleAvatar(
          backgroundColor: Color(0xFF0353EF),
          child: Text(
            "ppl",
            textScaleFactor: 1,
          ),
        ),
      ),
      SizedBox(
        height: _photoSize(),
        width: _photoSize(),
        child: //_userBloc != null ?
            CircleAvatar(
          backgroundImage: NetworkImage(
            _data,
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
    ],
  );
}

Container mutualFriendProfilePhotoItem(BuildContext context, int index, String photoUrl) {
  double _screenWidth = MediaQuery.of(context).size.width;
  double _itemSize() {
    if (_screenWidth <= 320) {
      return 24;
    } else if (_screenWidth > 320 && _screenWidth < 480) {
      return 26;
    } else {
      return 30;
    }
  }

  double _customMarginLeftValue() {
    switch (index) {
      case 0:
        {
          return _itemSize() * 0.75 * 2;
        }
      case 1:
        {
          return _itemSize() * 0.75 * 1;
        }
      case 2:
        {
          return _itemSize() * 0.75 * 0;
        }
    }
    return 0;
  }

  return Container(
    height: _itemSize(),
    width: _itemSize(),
    margin: EdgeInsets.only(left: _customMarginLeftValue()),
    decoration: BoxDecoration(
      boxShadow: <BoxShadow>[BoxShadow(color: const Color(0xFF939393).withOpacity(0.6), blurRadius: 2.0, spreadRadius: 0, offset: const Offset(1.0, 0.75))],
      borderRadius: const BorderRadius.all(Radius.circular(999)),
      color: Colors.white, //Colors.orange,
    ),
    child: Stack(
      children: [
        Container(
          height: _itemSize(),
          width: _itemSize(),
          child: const CircleAvatar(
            backgroundColor: Color(0xFF0353EF),
            child: Text(
              "ppl",
              style: TextStyle(fontSize: 10),
              textScaleFactor: 1,
            ),
          ),
        ),
        Container(
          height: _itemSize(),
          width: _itemSize(),
          child: //_userBloc != null ?
              CircleAvatar(
            backgroundImage: NetworkImage(
              photoUrl,
            ),
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    ),
  );
}
