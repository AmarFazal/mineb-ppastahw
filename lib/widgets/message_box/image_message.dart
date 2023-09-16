import 'dart:io';

import 'package:flutter/material.dart';

class ImageMessageWidget extends StatelessWidget {
  final File imageFile;

  const ImageMessageWidget({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Image.file(imageFile,width: 250),
    );
  }
}