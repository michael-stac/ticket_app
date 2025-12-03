import 'package:flutter/material.dart';
import '../utilities/appcolors.dart';
import 'global_verables.dart';


class PageService{
  static BuildContext? homeContext;
  Size pageSize(BuildContext context){
    var context=GlobalVariable.navState.currentContext;
    if(context!=null) {
      var size = MediaQuery.of(context).size;
      return Size(size.width, size.height);
    }
    return const Size(0, 0);
  }

  void showSnackBar(BuildContext context, String content){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(content)));
  }
  void errorshowSnackBar(BuildContext context, String content, Color color){
    ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(content: Text(content))
    );
  }
  static double? headerFontSize=17;
  static double? textFontSize=15;
  static SizedBox textSpaceS=  const SizedBox(
    height: 5,
    width: 5,
  );
  static SizedBox textSpace=  const SizedBox(
    height: 10,
    width: 10,
  );
  static SizedBox textSpace12=  const SizedBox(
    height: 12,
    width: 12,
  );
  static SizedBox textSpaceL=  const SizedBox(
      height: 15,
      width:15
  );
  static SizedBox authTextSpaceL=  const SizedBox(
      height: 18,
      width:18
  );
  static SizedBox labelSpaceL=  const SizedBox(
      height: 4,
      width:4
  );
  static SizedBox textSpacexL=  const SizedBox(
    height: 20,
    width: 20,
  );
  static SizedBox textSpacexxL=  const SizedBox(
    height: 30,
    width: 30,
  );
  static TextStyle bigHeaderStyle= TextStyle(fontSize: 28,fontWeight: FontWeight.w600,color: AppColor.onboard, fontFamily: 'Lexend-Black', decoration: TextDecoration.none);
  static TextStyle dateHeaderStyle= TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: AppColor.dateColor, fontFamily: 'Lexend-Black');
  static TextStyle headerStyle= TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: AppColor.primaryColor);
  static TextStyle subheaderStyle= TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: AppColor.subHeaderColor);


  static TextStyle labelStyle=TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColor.navIconColor,  fontFamily: 'Lexend-Black');
  static TextStyle authLabelStyle=TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColor.black,  fontFamily: 'Lexend-Black');
  static TextStyle ticketLabelStyle=TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColor.black,  fontFamily: 'Lexend-Black');
  static TextStyle ticketSpan1LabelStyle=TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColor.black,  fontFamily: 'Lexend-Black');
  static TextStyle ticketSpan2LabelStyle=TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColor.black,  fontFamily: 'Lexend-Black');
  static TextStyle bottomSheetLabel=TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColor.black, fontFamily: 'Lexend-Black', decoration: TextDecoration.none);
  static TextStyle normalLabelStyle=TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: 'Lexend-Black',
      color: AppColor.black);
  static TextStyle emailLabelStyle=TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColor.foundation, fontFamily: 'Lexend-Black');
  static TextStyle whitelabelStyle=TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: AppColor.white, fontFamily: 'Lexend-Black');
  static TextStyle textEditStyle=const TextStyle(fontSize: 14, fontFamily: 'Lexend-Black');
}