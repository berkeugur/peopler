import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../others/strings.dart';

class SendNotificationService {
  Future<void> sendNotification(String notificationType, String token, String message, String displayName, String profileURL, String userID) async {
    String endURL = "https://fcm.googleapis.com/fcm/send";

    String firebaseKey = Strings.firebaseServerKey;

    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "key=$firebaseKey"
    };

    String json =
        '{ '
          '"to" : "$token", '
          '"priority": "high", '        // This line and this line are too important
	        '"content_available": true, ' // for IOS. Without them, not working. 3 sleepless night.
          '"data" : { '
            '"notificationType" : "$notificationType", '
            '"message" : "$message", '
            '"displayName": "$displayName", '
            '"profileURL": "$profileURL", '
            '"userID" : "$userID" '
          '} '
        '}';

    http.Response response = await http.post(Uri.parse(endURL), headers: headers, body: json);

    if (response.statusCode == 200) {
      debugPrint("Successful http post");
    } else {
      /*
      print("Unsuccessful http post:" + response.statusCode.toString());
      print("the json:" + json);
      */
    }
  }
}