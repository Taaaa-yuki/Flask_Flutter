import 'package:flutter/material.dart';
import 'package:lyrics_app/app/models/favorite_model.dart';
import 'package:lyrics_app/app/models/lyrics_model.dart';

class LyricsDialogWidget extends StatefulWidget {
  final Function(BuildContext context, AlbumModel albumModel) onPressed;
  final LyricsModel? lyricsModel;
  final String? albumID;

  const LyricsDialogWidget({
    Key? key, 
    required this.onPressed,
    required this.lyricsModel,
    this.albumID,
  }) : super(key: key);

  @override
  State<LyricsDialogWidget> createState() => _LyricsDialogWidgetState();
}

class _LyricsDialogWidgetState extends State<LyricsDialogWidget> {
  late AlbumModel albumModel;
  late TextEditingController titleController;
  late TextEditingController artistController;
  late TextEditingController imageUrlController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    if (widget.lyricsModel != null) {
      titleController = TextEditingController(text: widget.lyricsModel!.title);
      artistController = TextEditingController(text: widget.lyricsModel!.artist);
      imageUrlController = TextEditingController(text: widget.lyricsModel!.imageUrl);
    } else {
      titleController = TextEditingController();
      artistController = TextEditingController();
      imageUrlController = TextEditingController();
    }
  }

  void _setAlbumModel() {
    albumModel = AlbumModel(
      id: widget.albumID ?? '',
      title: titleController.text,
      artist: artistController.text,
      imageUrl: imageUrlController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Lyrics'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: artistController,
              decoration: const InputDecoration(labelText: 'Artist'),
            ),
            TextField(
              controller: imageUrlController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          onPressed: () {
            _setAlbumModel();
            widget.onPressed(context, albumModel);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
