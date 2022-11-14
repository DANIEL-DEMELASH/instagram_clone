import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.only(left: 12),
  constraints: BoxConstraints(
    maxHeight: 45,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(5.0),
    ),
  ),
);

const primaryColor = Colors.white;
const secondaryColor = Colors.grey;
const bgColor = Color.fromRGBO(0, 0, 0, 1);
