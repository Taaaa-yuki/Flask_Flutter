import 'package:flutter/material.dart';
import 'package:lyrics_app/app/models/message_model.dart';


class CustomDialogWidget {
  static void show(BuildContext context, MessageModel message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message.title),
          content: Text(message.message),
          actions: <Widget>[
            if (message.actionText != null && message.action != null)
              TextButton(
                child: Text(message.actionText!),
                onPressed: () {
                    message.action!();
                    Navigator.of(context).pop();
                },
              ) 
            else
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
}