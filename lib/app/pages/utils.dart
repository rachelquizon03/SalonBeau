import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(BuildContext context, String message){
  Fluttertoast.showToast(msg: message);
}