import 'package:flutter/material.dart';
import '../utils/constants.dart';

void alertSnackBar({required String message, Color color = Colors.white}) {
  final context = navigatorkey.currentContext;
  if (context != null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        content: Text(
          message,
          style: TextStyle(
              color: color == Colors.white ? Colors.black : Colors.white),
        ),
        action: SnackBarAction(
          textColor: color == Colors.white ? Colors.black : Colors.white,
          label: 'Ok',
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
          },
        )));
  } else {
    debugPrint("Context is Not Found");
  }
}
