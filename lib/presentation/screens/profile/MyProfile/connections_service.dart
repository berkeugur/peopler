// ignore: avoid_print
printf(String text) => print(text);

class ConnectionService {
  pushOthersProfile({required String otherProfileID}) {
    printf("tapped others profile");
  }

  pushMessageScreen({required String otherProfileID}) {
    printf("tapped message screen");
  }
}
