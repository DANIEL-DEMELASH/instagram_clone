import 'package:flutter/material.dart';

class MyButtonWidget extends StatelessWidget {
  const MyButtonWidget({
    Key? key,
    required this.bgColor,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final Color bgColor;
  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      height: 45,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      minWidth: double.infinity,
      color: bgColor,
      onPressed: () => onPressed,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
