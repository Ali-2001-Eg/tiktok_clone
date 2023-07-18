import 'package:flutter/material.dart';
import 'package:get/get.dart';

SnackbarController customSnackBar(String title,String message){
   return Get.snackbar(title, message);
 }
