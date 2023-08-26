import 'package:flutter/material.dart';
import 'package:lyrics_app/app/constants/app_message.dart';
import 'package:lyrics_app/app/constants/app_text.dart';
import 'package:lyrics_app/app/controllers/lyrics_controller.dart';
import 'package:lyrics_app/app/models/favorite_model.dart';
import 'package:lyrics_app/app/models/lyrics_model.dart';
import 'package:lyrics_app/app/services/firebase_service.dart';
import 'package:lyrics_app/app/utils/error_helper_util.dart';
import 'package:lyrics_app/app/widgets/custom_appbar_widget.dart';
import 'package:lyrics_app/app/widgets/custom_drawer_widget.dart';
import 'package:lyrics_app/app/constants/error_message.dart';
import 'package:lyrics_app/app/widgets/custom_floatingactionbutton_widget.dart';
import 'package:lyrics_app/app/widgets/custom_loading_widget.dart';
import 'package:lyrics_app/app/widgets/custom_snackbar_widget.dart';
import 'package:lyrics_app/app/widgets/lyrics_dialog_widget.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({Key? key}) : super(key: key);

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  final FirebaseService _firebaseService = FirebaseService();
  late Future<List<AlbumModel>> _albumsFuture;

  @override
  void initState() {
    super.initState();
    _refreshAlbums();
  }

  void _refreshAlbums() {
    setState(() {
      _albumsFuture = _firebaseService.getAlbums();
    });
  }

  String _getAlbumId(AlbumModel albumModel) {
    return albumModel.id;
  }

  LyricsModel _convertAlbumToLyrics(AlbumModel albumModel) {
    return LyricsModel(
      title: albumModel.title,
      artist: albumModel.artist,
      imageUrl: albumModel.imageUrl,
      body: '',
    );
  }

  LyricsModel _initializeAlbumModel(AlbumModel? albumData) {
    if (albumData != null) {
      return _convertAlbumToLyrics(albumData);
    } else {
      return LyricsModel(
        title: '',
        artist: '',
        imageUrl: '',
        body: '',
      );
    }
  }

  void _onDeletePressed(AlbumModel album, BuildContext context) {
    try {
      _firebaseService.deleteAlbum(_getAlbumId(album));
      CustomSnackBarWidget.show(context, AppMessage.deleteSuccess.text);
      _refreshAlbums();
    } catch (e) {
      showErrorMessage(context, ErrorMessage.deleteFailed.text);
    }
  }

  void _showLyricsDialog(BuildContext context, AlbumModel? albumData) {
    Future<bool> isEditing = Future.value(albumData != null);
    LyricsModel album = _initializeAlbumModel(albumData);
    String albumId = albumData != null ? _getAlbumId(albumData) : '';

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return LyricsDialogWidget(
          lyricsModel: album,
          albumID: albumId,
          onPressed: (BuildContext innerContext, AlbumModel albumModel) async {
            try {
              bool isUpdating = await isEditing
                  ? LyricsController.updateAlbumInfo(innerContext, albumModel)
                  : LyricsController.saveAlbumInfo(innerContext, albumModel);
              if (!mounted) return;
              if (isUpdating) {
                CustomSnackBarWidget.show(innerContext, AppMessage.updateSuccess.text);
                _refreshAlbums();
              } else {
                showErrorMessage(innerContext, ErrorMessage.saveFailed.text);
              }
            } catch (e) {
              showErrorMessage(innerContext, ErrorMessage.saveFailed.text);
            }
          },
        );
      },
    );
  }


  Widget _buildAlbumList(List<AlbumModel> favoriteAlbums) {
    return ListView.builder(
      itemCount: favoriteAlbums.length + 1,
      itemBuilder: (context, index) {
        if (index == favoriteAlbums.length) {
          return const SizedBox(height: 80);
        }

        final AlbumModel album = favoriteAlbums[index];

        return Card(
          child: ListTile(
            leading: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(album.imageUrl)),
              ),
            ),
            title: Text(album.title),
            subtitle: Text(album.artist),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showLyricsDialog(context, album);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _onDeletePressed(album, context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbarWidget(title: AppText.favoriteAlbum),
      drawer: const CustomDrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 70.0),
        child: RefreshIndicator(
          onRefresh: () async {
            _refreshAlbums();
          },
          child: FutureBuilder<List<AlbumModel>>(
            future: _albumsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CustomLoadingWidget());
              }
              else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              final List<AlbumModel> favoriteAlbums = snapshot.data!;
              return _buildAlbumList(favoriteAlbums);
            },
          ),
        ),
      ),
      floatingActionButton: CustomFloatingactionbuttonWidget(
        onPressed: () {
          _showLyricsDialog(context, null);
        },
      ),
    );
  }
}
