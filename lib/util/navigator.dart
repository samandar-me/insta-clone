import 'package:flutter/cupertino.dart';

void navigate(BuildContext context, Widget to) {
  Navigator.of(context).push(CupertinoPageRoute(builder: (context) => to));
}
void navigateAndRemove(BuildContext context, Widget to) {
  Navigator.of(context)
      .pushAndRemoveUntil(CupertinoPageRoute(builder: (context) => to), (route) => false);
}