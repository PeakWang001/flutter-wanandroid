import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' ;
import 'package:fluttertoast/fluttertoast.dart' as prefix0;

class T{
  static void showToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: prefix0.Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  }
