import 'package:flutter/material.dart';
import 'package:lyrics_app/app/constants/app_text.dart';
import 'package:lyrics_app/app/constants/error_message.dart';
import 'package:lyrics_app/app/models/favorite_model.dart';
import 'package:lyrics_app/app/models/lyrics_model.dart';
import 'package:lyrics_app/app/models/message_model.dart';
import 'package:lyrics_app/app/services/firebase_service.dart';
import 'package:lyrics_app/app/widgets/custom_appbar_widget.dart';
import 'package:lyrics_app/app/widgets/custom_drawer_widget.dart';
import 'package:lyrics_app/app/widgets/custom_dialog_widget.dart';
import 'package:lyrics_app/app/widgets/custom_floatingactionbutton_widget.dart';
import 'package:lyrics_app/app/widgets/custom_loading_widget.dart';
import 'package:lyrics_app/app/widgets/custom_snackbar_widget.dart';

import '../constants/app_message.dart';

class LyricsView extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();
  final Future<LyricsModel>? lyricsModel;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _artistController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  LyricsView({Key? key, required this.lyricsModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbarWidget(title: AppText.lyrics),
      drawer: const CustomDrawerWidget(),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<LyricsModel>(
                future: lyricsModel,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CustomLoadingWidget();
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Error loading lyrics: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final lyrics = snapshot.data!;
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16.0),
                            Container(
                              alignment: Alignment.center,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  lyrics.imageUrl,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              lyrics.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              lyrics.artist,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 32.0),
                            SingleChildScrollView(
                              child: Text(
                                lyrics.body,
                                style:
                                    const TextStyle(fontSize: 16, height: 1.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingactionbuttonWidget(
        onPressed: () async {
          final lyricsData = await lyricsModel;
          if (lyricsData != null && context.mounted) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                _titleController.text = lyricsData.title;
                _artistController.text = lyricsData.artist;
                _imageUrlController.text = lyricsData.imageUrl;

                return AlertDialog(
                  title: const Text('Add AlbumModel'),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(labelText: 'Title'),
                        ),
                        TextField(
                          controller: _artistController,
                          decoration:
                              const InputDecoration(labelText: 'Artist'),
                        ),
                        TextField(
                          controller: _imageUrlController,
                          decoration:
                              const InputDecoration(labelText: 'Image URL'),
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
                      child: const Text('Save'),
                      onPressed: () async {
                        AlbumModel newAlbum = AlbumModel(
                          id: '',
                          title: _titleController.text,
                          artist: _artistController.text,
                          imageUrl: _imageUrlController.text,
                        );
                        if (newAlbum.title.isEmpty || newAlbum.artist.isEmpty || newAlbum.imageUrl.isEmpty) {
                          CustomDialogWidget.show(context, MessageModel(title: AppText.errorTitle ,message: ErrorMessage.emptyAlbumError.text));
                        } else {
                          try {
                            await _firebaseService.addAlbum(newAlbum);
                            CustomSnackBarWidget.show(context, AppMessage.addSuccess.text);
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          } catch (e) {
                            CustomSnackBarWidget.show(context, ErrorMessage.saveFailed.text);
                          }
                        }
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            CustomDialogWidget.show(context, MessageModel(title: AppText.errorTitle ,message: ErrorMessage.lyricsFetchFailed.text));
          }
        },
      ),
    );
  }
}
