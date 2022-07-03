import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import '../../../../others/classes/variables.dart';
import '../../../../data/repository/connectivity_repository.dart';
import '../../../../others/locator.dart';
import '../../../../others/widgets/snack_bars.dart';

resetPasswordButtonOnPressed(BuildContext context) async {
  UserBloc _userBloc = BlocProvider.of<UserBloc>(context);

  final ConnectivityRepository _connectivityRepository =
  locator<ConnectivityRepository>();
  bool _connection =
  await _connectivityRepository.checkConnection(context);
  if (_connection == false) return;

  if (resetPasswordController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      customSnackBar(
          context: context,
          title:
              "Lütfen e posta adresinizi girin.\nŞifre sıfırlama bağlantısı bu adrese gönderilecektir.",
          icon: Icons.warning_outlined,
          textColor: const Color(0xFFFFFFFF),
          bgColor: const Color(0xFF000B21)),
    );
  } else {
    _userBloc.add(resetPasswordEvent(email: resetPasswordController.text));
  }
}

void userNotFoundFunction(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    customSnackBar(
        context: context,
        title: "Böyle bir e posta adresi kayıtlı değil veya silinmiş olabilir!",
        icon: Icons.warning_outlined,
        textColor: const Color(0xFFFFFFFF),
        bgColor: const Color(0xFF000B21)),
  );
}

void invalidEmailFunction(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    customSnackBar(
        context: context,
        title: "E posta adresiniz istenilen biçimde değil!",
        icon: Icons.warning_outlined,
        textColor: const Color(0xFFFFFFFF),
        bgColor: const Color(0xFF000B21)),
  );
}

void resetPasswordSentFunction(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Başarılı"),
      content: const Text(
          "Şifrenizi sıfırlama bağlantısı e postanıza gönderildi. Lütfen E posta adresinizi kontrol ediniz."),
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
