class LyricsModel {
  String title;
  String artist;
  String body;
  String imageUrl;

  LyricsModel({
    required this.title,
    required this.artist,
    required this.body,
    required this.imageUrl
  });

  factory LyricsModel.fromJson(Map<String, dynamic> jsonData) {
    return LyricsModel(
      artist: jsonData['artist'],
      title: jsonData['title'],
      body: jsonData['body'],
      imageUrl: jsonData['photo_url'],
    );
  }
}
