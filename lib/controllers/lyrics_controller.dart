import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:lyrics_app/models/lyrics_model.dart';

class LyricsController {
  static Future<LyricsModel> getLyrics(String url) async {
    try {
      String lyricsUrl = "http://127.0.0.1:5000/scrape";

      var response = await post(Uri.parse(lyricsUrl), body: {'url': url});
      Map<String, dynamic> data = jsonDecode(response.body);
      LyricsModel lyricsModel = LyricsModel.fromJson(data);
      return lyricsModel;
    } catch (e) {
      return throw Exception(e);
    }
  }
}
