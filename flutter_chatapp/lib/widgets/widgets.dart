import 'package:flutter/material.dart';
import 'package:flutter_chatapp/shared/constants.dart';

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(
      color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.w300),
  focusedBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromARGB(255, 4, 173, 153), width: 2)),
  enabledBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromARGB(255, 4, 173, 153), width: 2)),
  errorBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromARGB(255, 4, 173, 153), width: 2)),
);

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}
