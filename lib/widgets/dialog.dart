import 'package:flutter/material.dart';

import '../1frf_api.dart';

void showErrorDialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(errorMessage),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showErrorAndLogoutDialog(BuildContext context, String errorMessage) {
  showDialog(
    barrierDismissible: false, // Dialog will not close when tapping outside or pressing back
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false, // Prevent the dialog from closing when pressing back
        child: AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                AuthUtils.logout(context);
              },
            ),
          ],
        ),
      );
    },
  );
}

