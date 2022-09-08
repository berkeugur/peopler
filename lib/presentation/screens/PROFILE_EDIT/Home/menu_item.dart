import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import 'package:peopler/others/widgets/snack_bars.dart';

class HomeItem extends StatelessWidget {
  const HomeItem({
    Key? key,
    required this.context,
    required this.title,
    required this.subtitle,
    required this.emptyText,
    this.targetPage,
  }) : super(key: key);

  final BuildContext context;
  final String title;
  final String subtitle;
  final String emptyText;
  final Widget? targetPage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              side: BorderSide(
                color: Mode().blackAndWhiteConversion()!.withOpacity(0.15),
              )),
          onPressed: () {
            if (targetPage != null) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return targetPage!;
              }));
            } else {
              SnackBars(context: context).simple("çok yakında...");
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 100,
                      child: Text(
                        title == "" ? emptyText : title,
                        textScaleFactor: 1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: GoogleFonts.rubik(fontSize: 15, color: Mode().blackAndWhiteConversion(), fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 100,
                      child: Text(
                        subtitle,
                        textScaleFactor: 1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: GoogleFonts.rubik(
                          fontSize: 12,
                          color: Mode().blackAndWhiteConversion()?.withOpacity(0.65),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox.square(
                  dimension: 20,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Mode().blackAndWhiteConversion()?.withOpacity(0.45),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
