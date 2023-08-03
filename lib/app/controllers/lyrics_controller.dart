import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:lyrics_app/app/models/lyrics_model.dart';

class LyricsController {
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
}
