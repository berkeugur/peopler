/*

Firebase veri çekme
_isTheAccountConfirmed = çekilen verinin atanacağı değer

FirebaseFirestore.instance
            .collection("Users")
            .doc(loginEmailController.text)
            .get()
            .then((value){
              _isTheAccountConfirmed = value.data()!["isTheAccountConfirmed"];
            });

Apk alma
flutter build apk --split-per-abi


/*NOTIFICATION LISTENER
                    if (scrollNotification is ScrollStartNotification) {
                      print("scroll start");
                    } else if (scrollNotification is ScrollUpdateNotification) {
                      print("scroll update");
                    } else if (scrollNotification is ScrollEndNotification) {
                      print("scroll end");
                    }else if(scrollNotification is ScrollHoldController){
                      print("scroll hold");
                    }else if(scrollNotification is ScrollMetricsNotification){
                      print("scroll metric $scrollNotification");
                    }
                    else{
                      print("başarısız $scrollNotification");
                    }


 */
 */