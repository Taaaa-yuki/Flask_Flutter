import 'package:flutter/material.dart';

class DialogModel {
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? action;

  DialogModel({
    required this.title,
    required this.message,
    this.actionText,
    this.action,
  });
}