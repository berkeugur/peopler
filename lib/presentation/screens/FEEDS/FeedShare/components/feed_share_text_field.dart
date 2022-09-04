import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/AddAnFeedBloc/add_a_feed_bloc.dart';
import 'package:peopler/core/constants/length/max_length_constants.dart';

import '../../../../../others/classes/variables.dart';
import '../../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../../others/classes/responsive_size.dart';
import '../../../../../others/locator.dart';

Padding TextFieldArea(StateSetter setState, context) {
  AddFeedBloc _addFeedBloc = BlocProvider.of<AddFeedBloc>(context);
  final Mode _mode = locator<Mode>();
  int customMaxLength = MaxLengthConstants.FEED;
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: TextFormField(
      controller: feedController,
      keyboardType: TextInputType.multiline,
      maxLength: customMaxLength,
      minLines: 1,
      maxLines: 7,
      inputFormatters: [
        LengthLimitingTextInputFormatter(140),
      ],
      decoration: InputDecoration(
        //counterText: "",
        counterStyle: TextStyle(color: _mode.blackAndWhiteConversion()),
        contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        hintMaxLines: 7,
        border: InputBorder.none,
        hintText: 'Herhangi bir şeyden bahsetmeye ne dersin?',
        hintStyle: TextStyle(
          color: _mode.feedShareScreenHintTextColor()?.withOpacity(0.7),
          fontSize: ResponsiveSize().fs5(context),
        ),
      ),
      style: TextStyle(
        color: _mode.feedShareScreenHintTextColor(),
      ),
      onChanged: (feedController) {
        print(feedController.toString());
        if (feedController.split('\n').length >= 3) {
          setState(() {
            customMaxLength = feedController.runes.length;
          });
        } else if (feedController.split('\n').length < 3) {
          setState(() {
            customMaxLength = 140;
          });
        }
        debugPrint(feedController.split('\n').length.toString());
        _addFeedBloc.feedExplanation = feedController.toString();
      },
    ),
  );
}
