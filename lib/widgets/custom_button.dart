import 'package:flutter/material.dart';
import '../features/utilities/appcolors.dart';

Widget customButton(
  BuildContext context, {
  required VoidCallback onTap,
  required String text,
  Color? bgColor,
  double? padding = 20,
  Color? textColor,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(padding!),
      decoration: BoxDecoration(
        color: bgColor ?? AppColor.primaryColor,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontFamily: 'Lexend-Black',
          fontWeight: FontWeight.w700,
          fontSize: 14,
          decoration: TextDecoration.none,
        ),
      ),
    ),
  );
}
