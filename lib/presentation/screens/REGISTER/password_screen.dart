import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/core/constants/length/max_length_constants.dart';

class RegisterPassword extends StatefulWidget {
  final PageController pageController;
  const RegisterPassword({Key? key, required this.pageController}) : super(key: key);

  @override
  State<RegisterPassword> createState() => _RegisterPasswordState();
}

class _RegisterPasswordState extends State<RegisterPassword> {
  bool isVisiblePassword = true;
  TextEditingController _displayNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController();
  }

  @override
  void dispose() {
    _displayNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Şifre Belirleyin",
              textScaleFactor: 1,
              style: GoogleFonts.rubik(
                color: const Color(0xFF000000),
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF0353EF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextFormField(
              onFieldSubmitted: (_) {
                widget.pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.linear,
                );
                FocusScope.of(context).unfocus();
              },
              autofocus: true,
              obscureText: isVisiblePassword,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.visiblePassword,
              cursorColor: const Color(0xFFFFFFFF),
              maxLength: MaxLengthConstants.PASSWORD,
              controller: _displayNameController,
              autocorrect: true,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isVisiblePassword = !isVisiblePassword;
                    });
                  },
                  icon: Icon(
                    isVisiblePassword == true ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0xFF9ABAF9),
                  ),
                  iconSize: 20,
                ),
                counterText: "",
                contentPadding: EdgeInsets.fromLTRB(0, 13, 0, 10),
                hintMaxLines: 1,
                border: InputBorder.none,
                hintText: 'Şifre',
                hintStyle: TextStyle(color: Color(0xFF9ABAF9), fontSize: 16),
              ),
              autofillHints: const [AutofillHints.password],
              style: const TextStyle(
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Şifrenizi istediğiniz zaman e-posta adresinizi kullanarak sıfırlayabilirsiniz.",
              textScaleFactor: 1,
              style: GoogleFonts.rubik(
                color: const Color(0xFF000B21),
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
