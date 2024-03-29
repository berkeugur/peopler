import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/core/constants/navigation/navigation_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../business_logic/blocs/UserBloc/bloc.dart';
import '../../../../core/system_ui_service.dart';
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
            /// Set theme mode before Home Screen
            SystemUIService().setSystemUIforThemeMode();

            Navigator.of(context).pushNamedAndRemoveUntil(NavigationConstants.HOME_SCREEN, (Route<dynamic> route) => false);
          } else if (state is SignedInMissingInfoState) {
            Navigator.of(context).pushNamedAndRemoveUntil(NavigationConstants.CONTINUE_WITH_LINKEDIN, (Route<dynamic> route) => false);
          }
        },
        child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: 'https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=' +
              Strings.clientIDLinkedIn +
              '&redirect_uri=' +
              Strings.redirectUrlLinkedIn +
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
            if (url.contains(Strings.redirectUrlLinkedIn)) {
              _controller.runJavascript("(function(){LinkedInSignIn.postMessage(window.document.body.outerHTML)})();");
            }
          },
        ),
      ),
    );
  }
}
