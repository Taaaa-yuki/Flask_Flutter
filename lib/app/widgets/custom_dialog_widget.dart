import 'package:flutter/material.dart';
import 'package:lyrics_app/app/models/dialog_model.dart';


class CustomDialogWidget {
  static void show(BuildContext context, DialogModel message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message.title),
          content: Text(message.message),
          actions: <Widget>[
            if (message.actionText != null && message.action != null)
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            TextButton(
              child: Text(message.actionText ?? 'OK'),
              onPressed: () {
                if (message.action != null) {
                  message.action!();
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}