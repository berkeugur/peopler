import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../settings_page_functions.dart';

// ignore: non_constant_identifier_names
ppl_photo(BuildContext context) {
  return Center(
    child: InkWell(
      onTap: () => op_settings_ppl_photo(),
      child: UserBloc.user!.profileURL != ""
          ? Stack(
              children: [
                const SizedBox(
                  height: 100,
                  width: 100,
                  child: CircleAvatar(
                    backgroundColor: Color(0xFF0353EF),
                    child: Text("ppl"),
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: UserBloc.user != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(UserBloc.user!.profileURL),
                          backgroundColor: Colors.transparent,
                        )
                      : const CircleAvatar(
                          backgroundColor: Colors.transparent,
                        ),
                ),
              ],
            )
          : const SizedBox(
              height: 100,
              width: 100,
              child: CircleAvatar(
                backgroundColor: Color(0xFF0353EF),
                child: Text("ppl"),
              ),
            ),
    ),
  );
}
