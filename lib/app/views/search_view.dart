import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lyrics_app/app/constants/app_message.dart';
import 'package:lyrics_app/app/constants/app_text.dart';
import 'package:lyrics_app/app/constants/error_message.dart';
import 'package:lyrics_app/app/controllers/lyrics_controller.dart';
import 'package:lyrics_app/app/models/lyrics_model.dart';
import 'package:lyrics_app/app/utils/error_helper_util.dart';
import 'package:lyrics_app/app/views/lyric_view.dart';
import 'package:lyrics_app/app/widgets/custom_appbar_widget.dart';
import 'package:lyrics_app/app/widgets/custom_button_widget.dart';
import 'package:lyrics_app/app/widgets/custom_drawer_widget.dart';
import 'package:lyrics_app/app/widgets/custom_loading_widget.dart';
import 'package:lyrics_app/app/widgets/custom_snackbar_widget.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _urlController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _navigateToLyricsView(LyricsModel lyricsModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LyricsView(lyricsModel: Future.value(lyricsModel)),
      ),
    );
  }

  void _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  bool _isValidLyricsModel(LyricsModel lyricsModel) {
    return lyricsModel.title.isNotEmpty &&
        lyricsModel.artist.isNotEmpty &&
        lyricsModel.body.isNotEmpty;
  }

  void _handleGetLyrics() async {
    final String url = _urlController.text;
    if (url.isNotEmpty) {
      _setLoading(true);
      try {
        final lyricsModel = await LyricsController.getLyrics(url);
        if (_isValidLyricsModel(lyricsModel)) {
          _navigateToLyricsView(lyricsModel);
        } else {
          if (!mounted) return;
          showErrorMessage(context, ErrorMessage.lyricsFetchFailed.text);
        }
      } catch (e) {
        showErrorMessage(context, ErrorMessage.lyricsFetchFailed.text);
      }
      _setLoading(false);
    } else {
      showErrorMessage(context, ErrorMessage.emptyUrlError.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbarWidget(title: AppText.lyrics),
      drawer: const CustomDrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            Stack(children: [
              Flexible(
                child: TextField(
                  controller: _urlController,
                  decoration: const InputDecoration(
                      labelText: 'Search for lyrics',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.fromLTRB(16.0, 16.0, 48.0, 16.0)),
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
                        CustomSnackBarWidget.show(
                            context, AppMessage.copyClipBoard.text);
                      });
                    }
                  },
                  icon: const Icon(Icons.content_paste),
                ),
              ),
            ]),
            const SizedBox(height: 24.0),
            Container(
              alignment: Alignment.center,
              child: _isLoading
                  ? const CustomLoadingWidget()
                  : CustomButtonWidget(
                      onPressed: _handleGetLyrics,
                      text: 'Get Lyrics',
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
