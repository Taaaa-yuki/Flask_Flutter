import 'package:flutter/material.dart';

class MessageModel {
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? action;

  MessageModel({
    required this.title,
    required this.message,
    this.actionText,
    this.action,
  });
}