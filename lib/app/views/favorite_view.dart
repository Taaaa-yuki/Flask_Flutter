import 'package:flutter/material.dart';
import 'package:lyrics_app/app/constants/app_message.dart';
import 'package:lyrics_app/app/constants/app_text.dart';
import 'package:lyrics_app/app/models/favorite_model.dart';
import 'package:lyrics_app/app/models/message_model.dart';
import 'package:lyrics_app/app/services/firebase_service.dart';
import 'package:lyrics_app/app/widgets/custom_appbar_widget.dart';
import 'package:lyrics_app/app/widgets/custom_drawer_widget.dart';
import 'package:lyrics_app/app/widgets/custom_dialog_widget.dart';
import 'package:lyrics_app/app/constants/error_message.dart';
import 'package:lyrics_app/app/widgets/custom_floatingactionbutton_widget.dart';
import 'package:lyrics_app/app/widgets/custom_loading_widget.dart';
import 'package:lyrics_app/app/widgets/custom_snackbar_widget.dart';

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
    _albumsFuture = _firebaseService.getAlbums();
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
            setState(() {
              _albumsFuture = _firebaseService.getAlbums();
            });
          },
          child: FutureBuilder<List<AlbumModel>>(
            future: _albumsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CustomLoadingWidget());
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              final favoriteAlbums = snapshot.data!;

              return ListView.builder(
                itemCount: favoriteAlbums.length + 1,
                itemBuilder: (context, index) {
                  if (index == favoriteAlbums.length) {
                    return const SizedBox(height: 80);
                  }
                  final album = favoriteAlbums[index];

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
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  TextEditingController titleController =
                                      TextEditingController(text: album.title);
                                  TextEditingController artistController =
                                      TextEditingController(text: album.artist);
                                  TextEditingController imageUrlController =
                                      TextEditingController(
                                          text: album.imageUrl);
                                  return AlertDialog(
                                    title: const Text('Edit Album'),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          TextField(
                                            controller: titleController,
                                            decoration: const InputDecoration(
                                                labelText: 'Title'),
                                          ),
                                          TextField(
                                            controller: artistController,
                                            decoration: const InputDecoration(
                                                labelText: 'Artist'),
                                          ),
                                          TextField(
                                            controller: imageUrlController,
                                            decoration: const InputDecoration(
                                                labelText: 'Image URL'),
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
                                          AlbumModel updatedAlbum = AlbumModel(
                                            id: album.id,
                                            title: titleController.text,
                                            artist: artistController.text,
                                            imageUrl: imageUrlController.text,
                                          );
                                          if (updatedAlbum.title.isEmpty ||
                                              updatedAlbum.artist.isEmpty ||
                                              updatedAlbum.imageUrl.isEmpty) {
                                            CustomDialogWidget.show(context,
                                                MessageModel(title: AppText.errorTitle ,message: ErrorMessage.emptyAlbumError.text));
                                          } else {
                                            try{
                                              await _firebaseService
                                                  .updateAlbum(updatedAlbum);
                                            } catch (e) {
                                              CustomDialogWidget.show(
                                                  context,
                                                  MessageModel(title: AppText.errorTitle ,message: ErrorMessage
                                                      .updateFailed.text));
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              try {
                                await _firebaseService.deleteAlbum(album.id);
                                CustomSnackBarWidget.show(
                                    context, AppMessage.deleteSuccess.text);
                                setState(() {
                                  _albumsFuture =
                                      _firebaseService.getAlbums();
                                });
                              } catch (e) {
                                CustomDialogWidget.show(
                                    context, MessageModel(title: AppText.errorTitle ,message: ErrorMessage.deleteFailed.text));
                              }
                              await _firebaseService.deleteAlbum(album.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: CustomFloatingactionbuttonWidget(
        // firebaseService: _firebaseService,
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController titleController = TextEditingController();
              TextEditingController artistController = TextEditingController();
              TextEditingController imageUrlController =
                  TextEditingController();

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
                        decoration: const InputDecoration(labelText: 'Artist'),
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
                      AlbumModel newAlbum = AlbumModel(
                        id: '',
                        title: titleController.text,
                        artist: artistController.text,
                        imageUrl: imageUrlController.text,
                      );
                      if (newAlbum.title.isEmpty ||
                          newAlbum.artist.isEmpty ||
                          newAlbum.imageUrl.isEmpty) {
                        CustomDialogWidget.show(context, MessageModel(title: AppText.errorTitle ,message: ErrorMessage.emptyAlbumError.text));
                      } else {
                        try {
                          await _firebaseService.addAlbum(newAlbum);
                          CustomSnackBarWidget.show(
                              context, AppMessage.addSuccess.text);
                          setState(() {
                            _albumsFuture = _firebaseService.getAlbums();
                          });
                          if (!mounted) return;
                          Navigator.of(context).pop();
                        } catch (e) {
                          CustomDialogWidget.show(
                              context, MessageModel(title: AppText.errorTitle ,message: ErrorMessage.saveFailed.text));
                        }
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
