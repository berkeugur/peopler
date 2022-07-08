import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../business_logic/blocs/UserBloc/bloc.dart';
import '../../../../others/strings.dart';

class LinkedInPage extends StatefulWidget {
  const LinkedInPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LinkedInPage> createState() => _LinkedInPageState();
}

class _LinkedInPageState extends State<LinkedInPage> {
  late WebViewController _controller;

  late final UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _userBloc = BlocProvider.of<UserBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<UserBloc, UserState>(
        bloc: _userBloc,
        listener: (context, UserState state) {
          if (state is SignedInState) {
            Navigator.of(context).pushNamedAndRemoveUntil('/homeScreen', (Route<dynamic> route) => false);
          } else if (state is SignedInMissingInfoState) {
            Navigator.of(context).pushNamedAndRemoveUntil('/genderSelectScreen', (Route<dynamic> route) => false);
          }
        },
        child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl:
              'https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=' +
                  Strings.clientId +
                  '&redirect_uri=' +
                  Strings.redirectUrl +
                  '&state=foobar&scope=r_liteprofile%20r_emailaddress',
          onWebViewCreated: (controller) {
            _controller = controller;
          },
          javascriptChannels: <JavascriptChannel>{
            JavascriptChannel(
              name: 'LinkedInSignIn',
              onMessageReceived: (JavascriptMessage message) {
                String pageBody = message.message;
                String customToken = pageBody.substring(19); // Delete <body>
                List<String> arr = customToken.split('</p>');
                customToken = arr[0];

                _userBloc.add(signInWithLinkedInEvent(customToken: customToken));

              },
            ),
          },
          onPageFinished: (url) {
            if (url.contains(Strings.redirectUrl)) {
              _controller.runJavascript(
                  "(function(){LinkedInSignIn.postMessage(window.document.body.outerHTML)})();");
            }
          },
        ),
      ),
    );
  }
}
