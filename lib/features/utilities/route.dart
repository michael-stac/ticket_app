import 'package:flutter/cupertino.dart';

///Navigator to the next page
Future nextPage(BuildContext context, {Widget? page}) {
  return Navigator.push(
      context, CupertinoPageRoute(builder: (context) => page!));
}

Future nextPageAndRemovePrevious(BuildContext context, {Widget? page}) async {
  await Navigator.pushAndRemoveUntil(
      context, CupertinoPageRoute(builder: (_) => page!), (route) => false);
}

void nextPageOnly(BuildContext context, {Widget? page}) {
  Navigator.pushAndRemoveUntil(context,
      CupertinoPageRoute(builder: (context) => page!), (route) => false);
}
