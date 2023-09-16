import 'package:flutter/material.dart';

void MySnackBar(BuildContext context, String yourTitle) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(yourTitle),
    duration: const Duration(seconds: 2),
  ));
}
