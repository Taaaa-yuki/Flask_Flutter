import 'package:flutter/material.dart';
import 'package:lyrics_app/app/constants/app_text.dart';
import 'package:lyrics_app/app/models/dialog_model.dart';
import 'package:lyrics_app/app/widgets/custom_dialog_widget.dart';

void showErrorMessage(BuildContext context, String errorMessage) {
  CustomDialogWidget.show(
    context,
    DialogModel(title: AppText.errorTitle, message: errorMessage),
  );
}