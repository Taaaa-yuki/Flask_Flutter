import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lyrics_app/app/constants/error_messages.dart';
import 'package:lyrics_app/app/controllers/lyrics_controller.dart';
import 'package:lyrics_app/app/models/lyrics_model.dart';
import 'package:lyrics_app/app/views/lyric_view.dart';
import 'package:lyrics_app/app/widgets/appbar.dart';
import 'package:lyrics_app/app/widgets/button.dart';
import 'package:lyrics_app/app/widgets/drawer.dart';
import 'package:lyrics_app/app/widgets/error_popup.dart';
import 'package:lyrics_app/app/widgets/loading.dart';

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
        ErrorPopup.show(context, ErrorMessages.failedToGetLyrics.text);
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      ErrorPopup.show(context, ErrorMessages.urlEmpty.text);
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
             Stack(
              children: [
                Flexible(
                  child: TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      labelText: 'Search for lyrics',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.fromLTRB(16.0, 16.0, 48.0, 16.0)
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
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
                ),
              ]
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
