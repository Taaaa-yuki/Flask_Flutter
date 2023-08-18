import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:lyrics_app/app/models/favorite_model.dart';
import 'package:lyrics_app/app/models/lyrics_model.dart';
import 'package:lyrics_app/app/services/firebase_service.dart';

class LyricsController {
  static final FirebaseService _firebaseService = FirebaseService();

  static Future<LyricsModel> getLyrics(String url) async {
    try {
      String lyricsApiUrl = "http://127.0.0.1:5000/scrape";

      var response = await post(Uri.parse(lyricsApiUrl), body: {'url': url});
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      LyricsModel lyricsData = LyricsModel.fromJson(jsonData);
      return lyricsData;
    } catch (e) {
      return throw Exception(e);
    }
  }

  static bool saveAlbumInfo(BuildContext context, AlbumModel albumModel) {
    bool isSaved = false;

    if (albumModel.title.isEmpty || albumModel.artist.isEmpty || albumModel.imageUrl.isEmpty) {
      isSaved = false;
    } else {
      _firebaseService.addAlbum(albumModel);
      isSaved = true;
    }

    return isSaved;
  }

  static bool updateAlbumInfo(BuildContext context, AlbumModel albumModel) {
    bool isUpdated = false;

    if (albumModel.title.isEmpty || albumModel.artist.isEmpty || albumModel.imageUrl.isEmpty) {
      isUpdated = false;
    } else {
      _firebaseService.updateAlbum(albumModel);
      isUpdated = true;
    }

    return isUpdated;
  }
}
