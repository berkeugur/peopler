import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/AddAnFeedBloc/add_a_feed_bloc.dart';
import 'package:peopler/business_logic/blocs/AddAnFeedBloc/add_a_feed_state.dart';
import '../../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../../others/classes/responsive_size.dart';
import '../../../../../others/locator.dart';
import '../feed_share_functions.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';

Padding header(BuildContext context) {
  final Mode _mode = locator<Mode>();
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                feed_share_back_icon_on_pressed(context);
              },
              icon: SizedBox(
                width: ResponsiveSize().fs3(context) + 10,
                height: ResponsiveSize().fs3(context) + 10,
                child: Icon(
                  Icons.close,
                  color: _mode.blackAndWhiteConversion(),
                  size: ResponsiveSize().fs3(context),
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            LimitedBox(
              maxWidth: MediaQuery.of(context).size.width - 165,
              child: Text(
                "Gönderi Paylaş",
                textScaleFactor: 1,
                style: PeoplerTextStyle.normal.copyWith(
                  color: _mode.blackAndWhiteConversion(),
                  fontSize: ResponsiveSize().fs1(context),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
            width: 80,
            child: TextButton(
                onPressed: () => feed_share_button_on_pressed(context),
                child: BlocBuilder<AddFeedBloc, AddFeedState>(
                  builder: (context, state) {
                    if (state is PrepareDataState) {
                      return Text(
                        "Paylaş",
                        textScaleFactor: 1,
                        style: PeoplerTextStyle.normal.copyWith(fontSize: ResponsiveSize().fs2(context), color: const Color(0xFF0353EF)),
                      );
                    } else if (state is LoadingState) {
                      return const CircularProgressIndicator(
                        color: Colors.white,
                      );
                    } else if (state is FeedCreateErrorState) {
                      return Text(
                        "Paylaş",
                        textScaleFactor: 1,
                        style: PeoplerTextStyle.normal.copyWith(fontSize: ResponsiveSize().fs2(context), color: const Color(0xFF0353EF)),
                      );
                    } else if (state is FeedCreateSuccessfulState) {
                      return Text(
                        "Paylaş",
                        textScaleFactor: 1,
                        style: PeoplerTextStyle.normal.copyWith(fontSize: ResponsiveSize().fs2(context), color: const Color(0xFF0353EF)),
                      );
                    } else {
                      return const Text("Impossible");
                    }
                  },
                )))
      ],
    ),
  );
}
