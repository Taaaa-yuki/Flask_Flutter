import 'package:flutter/material.dart';
import 'package:lyrics_app/models/favorite_model.dart';
import 'package:lyrics_app/models/lyrics_model.dart';
import 'package:lyrics_app/services/firebase_service.dart';
import 'package:lyrics_app/widgets/appbar.dart';
import 'package:lyrics_app/widgets/drawer.dart';
import 'package:lyrics_app/widgets/error_popup.dart';
import 'package:lyrics_app/widgets/floatingactionbutton.dart';
import 'package:lyrics_app/widgets/loading.dart';

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
      appBar: const LyricsAppBar(title: "Lyrics"),
      drawer: const LyricsDrawer(),
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
                    return const Loading();
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
      floatingActionButton: CustomFloatingActionButton(
        firebaseService: _firebaseService,
        onAddPressed: () async {
          final lyricsData = await lyricsModel;
          if (lyricsData != null && context.mounted) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                _titleController.text = lyricsData.title;
                _artistController.text = lyricsData.artist;
                _imageUrlController.text = lyricsData.imageUrl;

                return AlertDialog(
                  title: const Text('Add Album'),
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
                        Album newAlbum = Album(
                          id: '',
                          title: _titleController.text,
                          artist: _artistController.text,
                          imageUrl: _imageUrlController.text,
                        );
                        await _firebaseService.addAlbum(newAlbum);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            ErrorPopup.show(context, 'Failed to get lyrics. Please try again.');
          }
        },
      ),
    );
  }
}
