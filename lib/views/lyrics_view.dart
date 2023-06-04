import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lyrics_app/constants/color.dart';
import 'package:lyrics_app/constants/error_messages.dart';
import 'package:lyrics_app/controllers/lyrics_controller.dart';
import 'package:lyrics_app/models/favorite_model.dart';
import 'package:lyrics_app/models/lyrics_model.dart';
import 'package:lyrics_app/services/firebase_service.dart';
import 'package:lyrics_app/widgets/appbar.dart';
import 'package:lyrics_app/widgets/button.dart';
import 'package:lyrics_app/widgets/drawer.dart';
import 'package:lyrics_app/widgets/error_popup.dart';
import 'package:lyrics_app/widgets/floatingactionbutton.dart';
import 'package:lyrics_app/widgets/loading.dart';

class LyricsView extends StatefulWidget {
  const LyricsView({Key? key}) : super(key: key);

  @override
  State<LyricsView> createState() => _LyricsViewState();
}

class _LyricsViewState extends State<LyricsView> {
  final FirebaseService _firebaseService = FirebaseService();
  Future<LyricsModel>? _lyricsModel;
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LyricsAppBar(title: 'Lyrics'),
      drawer: const LyricsDrawer(),
      body: RefreshIndicator(
        color: AppColors.yellow,
        onRefresh: () async {
          setState(() {
            _lyricsModel = LyricsController.getLyrics(_urlController.text);
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              const Text(
                'Search for lyrics',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: TextField(
                      controller: _urlController,
                      decoration: const InputDecoration(
                        labelText: 'URL',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(16.0),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final data =
                          await Clipboard.getData(Clipboard.kTextPlain);
                      if (data != null) {
                        setState(() {
                          _urlController.text = data.text!;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Copied to clipboard'),
                            ),
                          );
                        });
                      }
                    },
                    icon: const Icon(Icons.content_paste),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              Container(
                alignment: Alignment.center,
                child: MyButton(
                  onPressed: () {
                    setState(() {
                      _lyricsModel =
                          LyricsController.getLyrics(_urlController.text);
                    });
                  },
                  text: 'Get Lyrics',
                ),
              ),
              const SizedBox(height: 32.0),
              Expanded(
                child: FutureBuilder<LyricsModel>(
                  future: _lyricsModel,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Loading(),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                          child: Text(ErrorMessages.failedToGetLyrics));
                    } else if (snapshot.hasData) {
                      final lyrics = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 100.0, left: 10),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                lyrics.title,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Text(
                                lyrics.artist,
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(height: 32.0),
                              Text(
                                lyrics.body,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const Center(
                          child:
                              Text(ErrorMessages.enterLyricsUrlAndPressButton));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        firebaseService: _firebaseService,
        onAddPressed: () async {
          final lyricsData = await _lyricsModel;
          if (lyricsData != null) {
            if (!mounted) return;
            showDialog(
              context: context,
              builder: (BuildContext context) {
                TextEditingController titleController =
                    TextEditingController(text: lyricsData.title ?? '');
                TextEditingController artistController =
                    TextEditingController(text: lyricsData.artist ?? '');
                TextEditingController imageUrlController =
                    TextEditingController(text: lyricsData.imageUrl ?? '');

                return AlertDialog(
                  title: const Text('Add Album'),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          controller: titleController,
                          decoration: const InputDecoration(labelText: 'Title'),
                        ),
                        TextField(
                          controller: artistController,
                          decoration:
                              const InputDecoration(labelText: 'Artist'),
                        ),
                        TextField(
                          controller: imageUrlController,
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
                          title: titleController.text,
                          artist: artistController.text,
                          imageUrl: imageUrlController.text,
                        );
                        await _firebaseService.addAlbum(newAlbum);
                        setState(() {});
                        if (!mounted) return;
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } else if (lyricsData == null) {
            if (!mounted) return;
              ErrorPopup.show(context, 'Failed to get lyrics. Please try again.');
          }
        },
      ),
    );
  }
}
