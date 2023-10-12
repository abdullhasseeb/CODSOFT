import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:to_do_app/constants/colors.dart';

class Toast{
  show(String msg){
    Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: textColor,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}