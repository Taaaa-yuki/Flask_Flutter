import 'package:flutter/material.dart';
import 'package:lyrics_app/controllers/lyrics_controller.dart';
import 'package:lyrics_app/models/lyrics_model.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class LyricsView extends StatefulWidget {
  const LyricsView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LyricsViewState createState() => _LyricsViewState();
}

class _LyricsViewState extends State<LyricsView> {
  final _urlController = TextEditingController();
  Future<LyricsModel>? _lyricsModel;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lyrics App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Enter lyrics URL',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _lyricsModel = LyricsController.getLyrics(_urlController.text);
                });
              },
              child: const Text('Get Lyrics'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: FutureBuilder<LyricsModel>(
                future: _lyricsModel,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: SimpleCircularProgressBar(
                          mergeMode: true,
                          animationDuration: 1,
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final lyrics = snapshot.data!;
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(lyrics.title, style: const TextStyle(fontSize: 24)),
                          const SizedBox(height: 8.0),
                          Text(lyrics.artist, style: const TextStyle(fontSize: 20)),
                          const SizedBox(height: 16.0),
                          Text(lyrics.body, style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    );
                  } else {
                    return const Center(child: Text('Enter a lyrics URL and press the button to get lyrics.'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
