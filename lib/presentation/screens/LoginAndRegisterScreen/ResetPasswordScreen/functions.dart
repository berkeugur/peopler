import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import 'package:peopler/components/snack_bars.dart';
import '../../../../others/classes/variables.dart';
import '../../../../data/repository/connectivity_repository.dart';
import '../../../../others/locator.dart';
import '../../../../others/widgets/snack_bars.dart';

resetPasswordButtonOnPressed(BuildContext context) async {
  UserBloc _userBloc = BlocProvider.of<UserBloc>(context);

  final ConnectivityRepository _connectivityRepository = locator<ConnectivityRepository>();
  bool _connection = await _connectivityRepository.checkConnection(context);
  if (_connection == false) return;

  if (resetPasswordController.text.isEmpty) {
    SnackBars(context: context).simple("Lütfen e posta adresinizi girin.\nŞifre sıfırlama bağlantısı bu adrese gönderilecektir.");
  } else {
    _userBloc.add(resetPasswordEvent(email: resetPasswordController.text));
  }
}

void userNotFoundFunction(BuildContext context) {
  SnackBars(context: context).simple("Böyle bir e posta adresi kayıtlı değil veya silinmiş olabilir!");
}

void invalidEmailFunction(BuildContext context) {
  SnackBars(context: context).simple("E posta adresiniz istenilen biçimde değil!");
}

void resetPasswordSentFunction(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Başarılı"),
      content: const Text("Şifrenizi sıfırlama bağlantısı e postanıza gönderildi. Lütfen E posta adresinizi kontrol ediniz."),
      backgroundColor: const Color(0xFF000B21),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      actions: <Widget>[
        TextButton(
          child: const Text("Tamam"),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
