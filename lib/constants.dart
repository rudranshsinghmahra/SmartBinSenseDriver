import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showCustomToast(String msg) {
  return Fluttertoast.showToast(
      msg: msg,
      backgroundColor: const Color(0xfff0f0f0),
      textColor: Colors.black);
}
