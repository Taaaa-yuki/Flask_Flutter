import 'package:flutter/material.dart';
import 'package:lyrics_app/app/constants/app_color.dart';

class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget({super.key, required this.onPressed, required this.text});

  final void Function() onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColor.secondaryTextColor,
        backgroundColor: AppColor.buttonColor,
        padding: const EdgeInsets.all(20.0),
        minimumSize: const Size(120, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
      child: Text(text),
    );
  }
}
