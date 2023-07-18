import 'package:flutter/material.dart';
import 'package:tiktok_clone/shared/utils/constants.dart';

class CustomTextInputField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final bool isObscure;
  final String labelText;
  const CustomTextInputField(
      {Key? key,
      required this.controller,
      required this.icon,
       this.isObscure = false,
      required this.labelText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(

        prefixIcon: Icon(icon,color: buttonColor,),
        labelStyle:  const TextStyle(
          fontSize: 20,
          color: borderColor
        ),
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: borderColor),
        ),
      ),
      obscureText: isObscure,
    );
  }
}
