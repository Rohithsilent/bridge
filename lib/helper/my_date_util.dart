import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//for getting formatted time from milliseconds
class MyDateUtil{
  static String getFormattedTime({required BuildContext context,required String time}){
    
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }
}