import 'package:flutter/material.dart';

class CustomFloatingactionbuttonWidget extends StatelessWidget {
  const CustomFloatingactionbuttonWidget({required this.onPressed, Key? key,}) : super(key: key);
  
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 70.0),
      child: FloatingActionButton(
        onPressed: onPressed,
        child: const Icon(Icons.add),
      ),
    );
  }
}
