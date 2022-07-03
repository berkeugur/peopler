import 'package:flutter/material.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';

class EmptyNotification extends StatelessWidget {
  const EmptyNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 240,
                  margin: const EdgeInsets.only(bottom: 20),
                  color: Colors.yellow,
                  child: Center(
                    child: Container(
                      color: Colors.red,
                      height: 120,
                      width: 200,
                    ),
                  ),
                ),
                const Text("Bildirim listeniz boş ")
              ],
            ),
          );
        });
  }
}
