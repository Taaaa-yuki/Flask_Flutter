import 'package:flutter/material.dart';
import 'package:lyrics_app/app/constants/app_message.dart';
import 'package:lyrics_app/app/constants/app_text.dart';
import 'package:lyrics_app/app/constants/error_message.dart';
import 'package:lyrics_app/app/controllers/lyrics_controller.dart';
import 'package:lyrics_app/app/models/favorite_model.dart';
import 'package:lyrics_app/app/models/lyrics_model.dart';
import 'package:lyrics_app/app/utils/error_helper_util.dart';
import 'package:lyrics_app/app/widgets/custom_appbar_widget.dart';
import 'package:lyrics_app/app/widgets/custom_drawer_widget.dart';
import 'package:lyrics_app/app/widgets/custom_loading_widget.dart';
import 'package:lyrics_app/app/widgets/custom_snackbar_widget.dart';
import 'package:lyrics_app/app/widgets/lyrics_dialog_widget.dart';

class LyricsView extends StatelessWidget {
  final LyricsModel lyricsModel;

  const LyricsView({Key? key, required this.lyricsModel}) : super(key: key);

  void _showLyricsDialog(BuildContext context, LyricsModel lyricsData) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return LyricsDialogWidget(
          lyricsModel: lyricsData,
          onPressed: (BuildContext innerContext, AlbumModel albumModel) async {
            bool isSaved = await LyricsController.saveAlbumInfo(dialogContext, albumModel);
            if (isSaved == true) {
              CustomSnackBarWidget.show(innerContext, AppMessage.addSuccess.text);
            } else {
              showErrorMessage(innerContext, ErrorMessage.saveFailed.text);
            }
          },
        );
      },
    );
  }

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
                future: Future.value(lyricsModel),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showLyricsDialog(context, lyricsModel);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
