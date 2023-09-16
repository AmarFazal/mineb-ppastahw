import 'package:flutter/material.dart';

import '../pages/home_page.dart';

void redirectToNewPage(BuildContext context) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => HomePage()));
}
