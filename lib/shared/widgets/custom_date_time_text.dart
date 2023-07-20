import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateTimeText extends StatelessWidget {
  final DateTime dateTime;
  final TextStyle style;

  const CustomDateTimeText(this.dateTime, {super.key, required this.style});

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('EEE h:mm a');
    final formatted = formatter.format(dateTime);
    return Text(
      formatted,
      style: style,
    );
  }
}