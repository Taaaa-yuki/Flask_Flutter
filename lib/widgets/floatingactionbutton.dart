import 'package:flutter/material.dart';
import 'package:lyrics_app/models/lyrics_model.dart';
import 'package:lyrics_app/services/firebase_service.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final FirebaseService firebaseService;
  final Function() onAddPressed;
  final LyricsModel? lyricsData;

  const CustomFloatingActionButton({
    required this.firebaseService,
    required this.onAddPressed,
    this.lyricsData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 70.0),
      child: FloatingActionButton(
        onPressed: onAddPressed,
        child: const Icon(Icons.add),
      ),
    );
  }
}
