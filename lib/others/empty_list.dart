import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/presentation/screens/SAVED/how_it_work.dart';

import 'classes/dark_light_mode_controller.dart';
import 'locator.dart';

class EmptyListScreen extends StatelessWidget {
  const EmptyListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const EmptyList(
      emptyListType: EmptyListType.outgoingRequest,
      isSVG: true,
    );
  }
}

enum EmptyListType {
  nearby,
  citySearch,
  emptyChannelList,
  emptyFeed,
  emptyNotifications,
  incomingRequest,
  outgoingRequest,
  saved,
}

String _imagePath({required EmptyListType emptyListType}) {
  switch (emptyListType) {
    case EmptyListType.nearby:
      return "citySearch";
    case EmptyListType.citySearch:
      return "citySearch";
    case EmptyListType.emptyChannelList:
      return "emptyChannelList";
    case EmptyListType.emptyFeed:
      return "emptyFeed";
    case EmptyListType.emptyNotifications:
      return "emptyNotifications";
    case EmptyListType.incomingRequest:
      return "incomingRequest";
    case EmptyListType.outgoingRequest:
      return "outgoingRequest";
    case EmptyListType.saved:
      return "outgoingRequest";
    default:
      {
        return "error";
      }
  }
}

List<String> _actionButtonText({required EmptyListType emptyListType}) {
  switch (emptyListType) {
    case EmptyListType.nearby:
      return []; //["Çevrenizi Keşfedin", "Arkadaşlarımla Paylaş"];
    case EmptyListType.citySearch:
      return []; //["Çevrenizi Keşfedin", "Arkadaşlarımla Paylaş"];
    case EmptyListType.emptyChannelList:
      return []; //["Çevrenizi Keşfedin", "Şehrinizi Keşfedin"];
    case EmptyListType.emptyFeed:
      return []; //[];
    case EmptyListType.emptyNotifications:
      return []; //[];
    case EmptyListType.incomingRequest:
      return []; //["Çevrenizi Keşfedin", "Şehrinizi Keşfedin"];
    case EmptyListType.outgoingRequest:
      return []; //["Çevrenizi Keşfedin", "Şehrinizi Keşfedin"];
    case EmptyListType.saved:
      return []; //["Çevrenizi Keşfedin", "Şehrinizi Keşfedin", "Nasıl Çalışır?"];
    default:
      {
        return ["error"];
      }
  }
}

List<Function()?> _actionButtonFunction({required EmptyListType emptyListType, required BuildContext context}) {
  switch (emptyListType) {
    case EmptyListType.nearby:
      return [
        () {
          print("go: Çevrenizi Keşfedin");
        },
        () {
          print("go: Sevdiklerinle Paylaş");
        }
      ];
    case EmptyListType.citySearch:
      return [
        () {
          print("go: Çevrenizi Keşfedin");
        },
        () {
          print("go: Sevdiklerinle Paylaş");
        }
      ];
    case EmptyListType.emptyChannelList:
      return [
        () {
          print("go: Çevrenizi Keşfedin");
        },
        () {
          print("go: Şehrinizi Keşfedin");
        }
      ];
    case EmptyListType.emptyFeed:
      return [];
    case EmptyListType.emptyNotifications:
      return [];
    case EmptyListType.incomingRequest:
      return [
        () {
          print("go: Çevrenizi Keşfedin");
        },
        () {
          print("go: Şehrinizi Keşfedin");
        }
      ];
    case EmptyListType.outgoingRequest:
      return [
        () {
          print("go: Çevrenizi Keşfedin");
        },
        () {
          print("go: Şehrinizi Keşfedin");
        }
      ];

    case EmptyListType.saved:
      return [
        () {
          print("go: Çevrenizi Keşfedin");
        },
        () {
          print("go: Şehrinizi Keşfedin");
        },
        () {
          howItWork(context);
          print("go: Nasıl Çalışır?");
        }
      ];
    default:
      {
        return [];
      }
  }
}

String _title({required EmptyListType emptyListType}) {
  switch (emptyListType) {
    case EmptyListType.nearby:
      return "Etrafında kimse yok";
    case EmptyListType.citySearch:
      return "Şehrinizde gösterebileceğimiz birisi bulunmuyor.";
    case EmptyListType.emptyChannelList:
      return "Mesaj listen boş.";
    case EmptyListType.emptyFeed:
      return "Feed listeniz boş.";
    case EmptyListType.emptyNotifications:
      return "Bildirim sayfan boş.";
    case EmptyListType.incomingRequest:
      return "Gelen bağlantı isteğin bulunmuyor.";
    case EmptyListType.outgoingRequest:
      return "Gönderilmiş bağlantı isteğin bulunmuyor.";
    case EmptyListType.saved:
      return "Kaydettiğin kimse bulunmuyor.";
    default:
      {
        return "error";
      }
  }
}

String _explanation({required EmptyListType emptyListType}) {
  switch (emptyListType) {
    case EmptyListType.nearby:
      return """Aynı ortamı paylaştığın Peopler kullanıcısı bulamadık. Ancak hiç endişelenme topluluğumuzu büyütmeye devam ediyoruz!""";
    case EmptyListType.citySearch:
      return "En kısa sürede şehrinizde yeni peopler kullanıcıları olacağına eminiz. Lütfen daha sonra tekrar kontrol edin.";
    case EmptyListType.emptyChannelList:
      return "İnsanlarla mesajlaşmak için yeni bağlantılar edin!";
    case EmptyListType.emptyFeed:
      return "En kısa sürede yeni feedler paylaşılacağına eminiz. Lütfen daha sonra tekrar deneyin.";
    case EmptyListType.emptyNotifications:
      return "Hiç bildirimin bulunmuyor.";
    case EmptyListType.incomingRequest:
      return "Başkaları bu boş sayfayı görmesin istersen ilk adımı sen atabilirsin!";
    case EmptyListType.outgoingRequest:
      return "İnsanlarla yeni bağlantılar kurmak için arama kısmına gidebilir veya ana sayfadan düşüncelerini paylaşabilirsin.";
    case EmptyListType.saved:
      return "Aynı ortamı paylaştığın insanları kaydettiğinde burada görüntülenir.";
    default:
      {
        return "error";
      }
  }
}

class EmptyList extends StatelessWidget {
  final EmptyListType emptyListType;
  final bool isSVG;
  const EmptyList({Key? key, required this.emptyListType, required this.isSVG}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Mode _mode = locator<Mode>();
    final screenHeight = MediaQuery.of(context).size.height;

    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return SizedBox(
            height: emptyListType == EmptyListType.emptyChannelList ||
                    emptyListType == EmptyListType.incomingRequest ||
                    emptyListType == EmptyListType.outgoingRequest
                ? screenHeight - 180
                : screenHeight - 75,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: isSVG
                        ? SvgPicture.asset(
                            "assets/empty_list_images/" + _imagePath(emptyListType: emptyListType) + ".svg",
                            fit: BoxFit.contain,
                            width: 220,
                            height: 220,
                          )
                        : Image.asset(
                            "assets/empty_list_images/" + _imagePath(emptyListType: emptyListType) + ".png",
                            fit: BoxFit.contain,
                            width: 220,
                            height: 220,
                          ),
                  ),
                  Text(
                    _title(emptyListType: emptyListType),
                    textAlign: TextAlign.center,
                    textScaleFactor: 1,
                    style: PeoplerTextStyle.normal.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _mode.blackAndWhiteConversion(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    _explanation(emptyListType: emptyListType),
                    textAlign: TextAlign.center,
                    textScaleFactor: 1,
                    style: PeoplerTextStyle.normal.copyWith(
                      fontSize: 16,
                      color: _mode.blackAndWhiteConversion(),
                    ),
                  ),
                  ListView.builder(
                    itemCount: _actionButtonText(emptyListType: emptyListType).length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext, index) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 0, top: 10),
                            child: InkWell(
                              onTap: _actionButtonFunction(emptyListType: emptyListType, context: context)[index],
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(width: 1, color: const Color(0xFF0353EF)),
                                  color: Colors.transparent,
                                ),
                                child: Center(
                                  child: Text(
                                    _actionButtonText(emptyListType: emptyListType)[index],
                                    textScaleFactor: 1,
                                    style: PeoplerTextStyle.normal.copyWith(color: const Color(0xFF0353EF), fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
          );
        });
  }
}
