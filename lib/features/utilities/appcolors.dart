import 'package:flutter/material.dart';
import 'dart:math';

const Color primaryColor = Color(0xffE31C20);
const Color placeholderBackground = Color.fromRGBO(235, 235, 235, 1.0);

class AppColor {
  static Color primaryColor = const Color(0xff056033);
  static Color navIconColor = const Color(0xff78686D);
  static Color unselectedColor = const Color(0xff7A7A7A);
  static Color scaffoldBgColor = const Color(0xffFFEFEF);
  static Color red = const Color(0xffFF0000);
  static Color lightGray = const Color(0xffE5E7E6);
  static Color altPrimary = const Color.fromARGB(255, 230, 145, 144);
  static Color quickSilver = const Color(0xff9BA59F);
  static Color onboard = const Color(0xff2C2C2C);
  static Color dateColor = const Color(0xff333333);
  static Color subHeaderColor = const Color(0xff616161);

  static Color cultured = const Color(0xffF5F5F5);
  static Color gray = const Color(0xff666666);
  static Color Gainsboro = const Color(0xffDADADA);

  static Color filledColor = const Color(0xffDDE5E9);
  static Color black = const Color(0xff000000);
  static Color foundation = const Color(0xff000000);
  static Color romanSilver = const Color(0xff808192);

  static Color placeholderBackground = const Color.fromRGBO(235, 235, 235, 1.0);

  static Color chineseWhite = const Color(0xffE1E1E1);
  static Color white = const Color(0xffF5F5F5);

  static Map<int, Color> colorPallete = {
    50: const Color.fromRGBO(27, 93, 47, .1),
    100: const Color.fromRGBO(27, 93, 47, .2),
    200: const Color.fromRGBO(27, 93, 47, .3),
    300: const Color.fromRGBO(27, 93, 47, .4),
    400: const Color.fromRGBO(27, 93, 47, .5),
    500: const Color.fromRGBO(27, 93, 47, .6),
    600: const Color.fromRGBO(27, 93, 47, .7),
    700: const Color.fromRGBO(27, 93, 47, .8),
    800: const Color.fromRGBO(27, 93, 47, .9),
    900: const Color.fromRGBO(27, 93, 47, 1),
  };

  static MaterialColor primaryMaterialColor =
  MaterialColor(0xFF1B5D2F, AppColor.colorPallete);
  static Color transColor = const Color.fromRGBO(0, 0, 0, 0.2);
  static Color grayColor = const Color.fromRGBO(128, 128, 128, 1.0);
  static Color whiteSmokeColor = const Color.fromRGBO(235, 235, 235, 1.0);
  static Color whiteSmokeColor2 = const Color.fromRGBO(235, 235, 235, 0.7);
  static Color separatorColor = const Color.fromRGBO(128, 128, 128, 0.3);

  static Color primaryRandColour = randColor();
  static Color randColor() {
    var colourList = [
      primaryColor,
      const Color.fromRGBO(0, 100, 255, 0.4),
      const Color.fromRGBO(0, 104, 132, 1),
      const Color.fromRGBO(0, 144, 158, 1),
      const Color.fromRGBO(234, 0, 52, 1),
      const Color.fromRGBO(250, 157, 0, 1),
      const Color.fromRGBO(145, 39, 143, 1),
      const Color.fromRGBO(87, 62, 126, 1),
      const Color.fromRGBO(255, 130, 42, 1),
      const Color.fromRGBO(102, 136, 90, 1),
      const Color.fromRGBO(27, 93, 47, 1),
      const Color.fromRGBO(192, 108, 132, 1),
      const Color.fromRGBO(246, 114, 128, 1),
      const Color.fromRGBO(248, 177, 149, 1),
      const Color.fromRGBO(116, 180, 155, 1),
    ];
    Random random = Random();
    return colourList[random.nextInt(8)];
  }
}
