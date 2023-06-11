import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lyrics_app/constants/error_messages.dart';
import 'package:lyrics_app/controllers/lyrics_controller.dart';
import 'package:lyrics_app/models/lyrics_model.dart';
import 'package:lyrics_app/views/lyric_view.dart';
import 'package:lyrics_app/widgets/appbar.dart';
import 'package:lyrics_app/widgets/button.dart';
import 'package:lyrics_app/widgets/drawer.dart';
import 'package:lyrics_app/widgets/error_popup.dart';
import 'package:lyrics_app/widgets/loading.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _urlController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void navigateToLyricsView(LyricsModel lyricsModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LyricsView(lyricsModel: Future.value(lyricsModel)),
      ),
    );
  }

  void handleGetLyrics() async {
    final url = _urlController.text;
    if (url.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        final lyricsModel = await LyricsController.getLyrics(url);
        if (lyricsModel.title.isNotEmpty &&
            lyricsModel.artist.isNotEmpty &&
            lyricsModel.body.isNotEmpty) {
          navigateToLyricsView(lyricsModel);
        }
      } catch (e) {
        ErrorPopup.show(context, ErrorMessages.failedToGetLyrics);
      }

      setState(() {
        _isLoading = false;
      });
    } else {
      ErrorPopup.show(context, ErrorMessages.urlEmpty);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LyricsAppBar(title: 'Lyrics'),
      drawer: const LyricsDrawer(),
      body: Padding(
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
                    final data = await Clipboard.getData(Clipboard.kTextPlain);
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
              child: _isLoading
                  ? const Loading()
                  : MyButton(
                      onPressed: handleGetLyrics,
                      text: 'Get Lyrics',
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
