import 'dart:ui';
import 'package:flutter/material.dart';

ElevatedButton authButton(
    {required double scWidth,
    required String text,
    required VoidCallback onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
        fixedSize:
            scWidth > 500 ? const Size(300, 50) : Size(scWidth / 1.5, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black),
    child: Text(
      text,
      style: const TextStyle(fontSize: 15),
    ),
  );
}

TextField textFieldWidget(
    {required String hintText,
    required FocusNode focusNode,
    required TextEditingController controller,
    IconButton? suffixIcon,
    List<String>? autofillHints,
    TextInputType? textInputType,
    bool obscureText = false}) {
  return TextField(
    controller: controller,
    focusNode: focusNode,
    onTapOutside: (event) {
      focusNode.unfocus();
    },
    obscureText: obscureText,
    keyboardType: textInputType,
    style: const TextStyle(color: Colors.white),
    autofillHints: autofillHints,
    decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        labelText: hintText,
        labelStyle: const TextStyle(color: Colors.white),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        suffixIcon: suffixIcon),
  );
}

Text titleText(String title) {
  return Text(
    title,
    textAlign: TextAlign.center,
    maxLines: 2,
    style: const TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
  );
}

Widget cardWidget(
    {required double scHeight,
    required double scWidth,
    required Widget child,
    required Widget? action}) {
  return SingleChildScrollView(
    child: Container(
      height: scHeight,
      width: scWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade300,
              Colors.deepPurple.shade600,
              Colors.deepPurple.shade800
            ],
            transform: const GradientRotation(1),
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
                width: scWidth > 500 ? 500 : scWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade200.withOpacity(0.1),
                ),
                margin: const EdgeInsets.all(10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: child),
          ),
          if (action != null) action
        ],
      ),
    ),
  );
}
